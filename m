Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60C33C5253
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242244AbhGLHpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:51582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349528AbhGLHmu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:42:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4273161165;
        Mon, 12 Jul 2021 07:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075601;
        bh=p7ki6QLfwXV3JfZ6iMqIRhwhsOhjQbxlo8xW8Ckg5L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNx+9wbriBU2AzLO4TuYzBvrrcmjGCE9RUSmiAFTBeSuAfYUKcnPVeGBySIxnBDAs
         Fbx4FMoo0Ip2rbxqvYtY1IA3pZbytrP115Bnsm/8yuVIKRFjMucTf1/jy1slugsqIf
         aKggPKriuBiGX8vXiUvFb92elIKN9czYNlOjT6jI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thiago Rafael Becker <trbecker@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 247/800] cifs: retry lookup and readdir when EAGAIN is returned.
Date:   Mon, 12 Jul 2021 08:04:30 +0200
Message-Id: <20210712060948.511245282@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thiago Rafael Becker <trbecker@gmail.com>

[ Upstream commit 6efa994e35a402ae4ae2161b6439c94b64816cee ]

According to the investigation performed by Jacob Shivers at Red Hat,
cifs_lookup and cifs_readdir leak EAGAIN when the user session is
deleted on the server. Fix this issue by implementing a retry with
limits, as is implemented in cifs_revalidate_dentry_attr.

Reproducer based on the work by Jacob Shivers:

  ~~~
  $ cat readdir-cifs-test.sh
  #!/bin/bash

  # Install and configure powershell and sshd on the windows
  #  server as descibed in
  # https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview
  # This script uses expect(1)

  USER=dude
  SERVER=192.168.0.2
  RPATH=root
  PASS='password'

  function debug_funcs {
  	for line in $@ ; do
  		echo "func $line +p" > /sys/kernel/debug/dynamic_debug/control
  	done
  }

  function setup {
  	echo 1 > /proc/fs/cifs/cifsFYI
  	debug_funcs wait_for_compound_request \
                smb2_query_dir_first cifs_readdir \
                compound_send_recv cifs_reconnect_tcon \
                generic_ip_connect cifs_reconnect \
                smb2_reconnect_server smb2_reconnect \
                cifs_readv_from_socket cifs_readv_receive
  	tcpdump -i eth0 -w cifs.pcap host 192.168.2.182 & sleep 5
  	dmesg -C
  }

  function test_call {
  	if [[ $1 == 1 ]] ; then
  		tracer="strace -tt -f -s 4096 -o trace-$(date -Iseconds).txt"
  	fi
        # Change the command here to anything appropriate
  	$tracer ls $2 > /dev/null
  	res=$?
  	if [[ $1 == 1 ]] ; then
  		if [[ $res == 0 ]] ; then
  			1>&2 echo success
  		else
  			1>&2 echo "failure ($res)"
  		fi
  	fi
  }

  mountpoint /mnt > /dev/null || mount -t cifs -o username=$USER,pass=$PASS //$SERVER/$RPATH /mnt

  test_call 0 /mnt/

  /usr/bin/expect << EOF
  	set timeout 60

  	spawn ssh $USER@$SERVER

  	expect "yes/no" {
  		send "yes\r"
  		expect "*?assword" { send "$PASS\r" }
  	} "*?assword" { send "$PASS\r" }

  	expect ">" { send "powershell close-smbsession -force\r" }
  	expect ">" { send "exit\r" }
  	expect eof
  EOF

  sysctl -w vm.drop_caches=2 > /dev/null
  sysctl -w vm.drop_caches=2 > /dev/null

  setup

  test_call 1 /mnt/
  ~~~

Signed-off-by: Thiago Rafael Becker <trbecker@gmail.com>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/dir.c     | 4 ++++
 fs/cifs/smb2ops.c | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 6bcd3e8f7cda..7c641f9a3dac 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -630,6 +630,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	struct inode *newInode = NULL;
 	const char *full_path;
 	void *page;
+	int retry_count = 0;
 
 	xid = get_xid();
 
@@ -673,6 +674,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	cifs_dbg(FYI, "Full path: %s inode = 0x%p\n",
 		 full_path, d_inode(direntry));
 
+again:
 	if (pTcon->posix_extensions)
 		rc = smb311_posix_get_inode_info(&newInode, full_path, parent_dir_inode->i_sb, xid);
 	else if (pTcon->unix_ext) {
@@ -687,6 +689,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		/* since paths are not looked up by component - the parent
 		   directories are presumed to be good here */
 		renew_parental_timestamps(direntry);
+	} else if (rc == -EAGAIN && retry_count++ < 10) {
+		goto again;
 	} else if (rc == -ENOENT) {
 		cifs_set_time(direntry, jiffies);
 		newInode = NULL;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index b68ba92893b6..903de7449aa3 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2325,6 +2325,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	struct smb2_query_directory_rsp *qd_rsp = NULL;
 	struct smb2_create_rsp *op_rsp = NULL;
 	struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
+	int retry_count = 0;
 
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path)
@@ -2372,10 +2373,14 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 
 	smb2_set_related(&rqst[1]);
 
+again:
 	rc = compound_send_recv(xid, tcon->ses, server,
 				flags, 2, rqst,
 				resp_buftype, rsp_iov);
 
+	if (rc == -EAGAIN && retry_count++ < 10)
+		goto again;
+
 	/* If the open failed there is nothing to do */
 	op_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
 	if (op_rsp == NULL || op_rsp->sync_hdr.Status != STATUS_SUCCESS) {
-- 
2.30.2



