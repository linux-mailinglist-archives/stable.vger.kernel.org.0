Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75AFB510818
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 21:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353796AbiDZTGt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 15:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353887AbiDZTGP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 15:06:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03895199817;
        Tue, 26 Apr 2022 12:03:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4939BB8224F;
        Tue, 26 Apr 2022 19:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70A8C385C0;
        Tue, 26 Apr 2022 19:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650999782;
        bh=KR943c8CFkXLKMhnK9yAbS4g5Lha2CsC/opzgmgUJ6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXcj/APqDlgo35PF2YjIDIDTzb29tFWyTROA37lcjVoJohX1LH7b0rqv9xNFkGSYT
         m5XdtHA6vuaA4+6gycQu9xlPBpfGjRxL7aiPNCVhtd26wvwGGPjZdwLrpCpDDRRbJT
         dUAPALrh7OyGbxICrzUkKudd7t9ku8fNhmOonkAtKhkL4pxPDa3AxG4RZO/ETvTo9i
         aBCPQo2lpl68MIHYCCVW12/r+6QK19T4ZXOijQa61Hn9VKpKnT6ddFpoWFdc42F23p
         y9xMyyg1YNLZuQPfsuHwsEPcJeSgiY7GpzKX7ih3efm9AnxK20Hwujka/+PMU0CNzk
         zTgboskxRCgoQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Xiaoli Feng <xifeng@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.14 3/5] cifs: destage any unwritten data to the server before calling copychunk_write
Date:   Tue, 26 Apr 2022 15:02:54 -0400
Message-Id: <20220426190258.2351902-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426190258.2351902-1-sashal@kernel.org>
References: <20220426190258.2351902-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit f5d0f921ea362636e4a2efb7c38d1ead373a8700 ]

because the copychunk_write might cover a region of the file that has not yet
been sent to the server and thus fail.

A simple way to reproduce this is:
truncate -s 0 /mnt/testfile; strace -f -o x -ttT xfs_io -i -f -c 'pwrite 0k 128k' -c 'fcollapse 16k 24k' /mnt/testfile

the issue is that the 'pwrite 0k 128k' becomes rearranged on the wire with
the 'fcollapse 16k 24k' due to write-back caching.

fcollapse is implemented in cifs.ko as a SMB2 IOCTL(COPYCHUNK_WRITE) call
and it will fail serverside since the file is still 0b in size serverside
until the writes have been destaged.
To avoid this we must ensure that we destage any unwritten data to the
server before calling COPYCHUNK_WRITE.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1997373
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2ops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ba56c00f2650..3280a801b1d7 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -855,9 +855,17 @@ smb2_copychunk_range(const unsigned int xid,
 	int chunks_copied = 0;
 	bool chunk_sizes_updated = false;
 	ssize_t bytes_written, total_bytes_written = 0;
+	struct inode *inode;
 
 	pcchunk = kmalloc(sizeof(struct copychunk_ioctl), GFP_KERNEL);
 
+	/*
+	 * We need to flush all unwritten data before we can send the
+	 * copychunk ioctl to the server.
+	 */
+	inode = d_inode(trgtfile->dentry);
+	filemap_write_and_wait(inode->i_mapping);
+
 	if (pcchunk == NULL)
 		return -ENOMEM;
 
-- 
2.35.1

