Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECF41B3E49
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbgDVK1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:27:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730805AbgDVK1A (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:27:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32CF32075A;
        Wed, 22 Apr 2020 10:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551219;
        bh=Fiy/C+hMDSiklLTNMwKsro5YSZ51P2tQcXoshYJOGXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2CcMe7nD2cvWrKoOdXFftA4YRZ1uFd+zu1tKh+b6e8pcceQq0nKL3J/e5npqgfSn1
         PzJ2meu9337p86HM/2VTaMduoT3Xg5LC9GgFif5sIT3lPdvsv+SmgRkdyF/1EzwltX
         bgw/SIeCRfqbB4of2fhncc5lk53Kzs+Ifb4tDdiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aurelien Aptel <aaptel@suse.com>,
        Steve French <stfrench@microsoft.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: [PATCH 5.6 148/166] cifs: ignore cached share root handle closing errors
Date:   Wed, 22 Apr 2020 11:57:55 +0200
Message-Id: <20200422095104.463905753@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aurelien Aptel <aaptel@suse.com>

commit e79b0332ae06b4895dcecddf4bbc5d3917e9383c upstream.

Fix tcon use-after-free and NULL ptr deref.

Customer system crashes with the following kernel log:

[462233.169868] CIFS VFS: Cancelling wait for mid 4894753 cmd: 14       => a QUERY DIR
[462233.228045] CIFS VFS: cifs_put_smb_ses: Session Logoff failure rc=-4
[462233.305922] CIFS VFS: cifs_put_smb_ses: Session Logoff failure rc=-4
[462233.306205] CIFS VFS: cifs_put_smb_ses: Session Logoff failure rc=-4
[462233.347060] CIFS VFS: cifs_put_smb_ses: Session Logoff failure rc=-4
[462233.347107] CIFS VFS: Close unmatched open
[462233.347113] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
...
    [exception RIP: cifs_put_tcon+0xa0] (this is doing tcon->ses->server)
 #6 [...] smb2_cancelled_close_fid at ... [cifs]
 #7 [...] process_one_work at ...
 #8 [...] worker_thread at ...
 #9 [...] kthread at ...

The most likely explanation we have is:

* When we put the last reference of a tcon (refcount=0), we close the
  cached share root handle.
* If closing a handle is interrupted, SMB2_close() will
  queue a SMB2_close() in a work thread.
* The queued object keeps a tcon ref so we bump the tcon
  refcount, jumping from 0 to 1.
* We reach the end of cifs_put_tcon(), we free the tcon object despite
  it now having a refcount of 1.
* The queued work now runs, but the tcon, ses & server was freed in
  the meantime resulting in a crash.

THREAD 1
========
cifs_put_tcon                 => tcon refcount reach 0
  SMB2_tdis
   close_shroot_lease
    close_shroot_lease_locked => if cached root has lease && refcount = 0
     smb2_close_cached_fid    => if cached root valid
      SMB2_close              => retry close in a thread if interrupted
       smb2_handle_cancelled_close
        __smb2_handle_cancelled_close    => !! tcon refcount bump 0 => 1 !!
         INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
         queue_work(cifsiod_wq, &cancelled->work) => queue work
 tconInfoFree(tcon);    ==> freed!
 cifs_put_smb_ses(ses); ==> freed!

THREAD 2 (workqueue)
========
smb2_cancelled_close_fid
  SMB2_close(0, cancelled->tcon, ...); => use-after-free of tcon
  cifs_put_tcon(cancelled->tcon);      => tcon refcount reach 0 second time
  *CRASH*

Fixes: d9191319358d ("CIFS: Close cached root handle only if it has a lease")
Signed-off-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2misc.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -766,6 +766,20 @@ smb2_handle_cancelled_close(struct cifs_
 
 	cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
 	spin_lock(&cifs_tcp_ses_lock);
+	if (tcon->tc_count <= 0) {
+		struct TCP_Server_Info *server = NULL;
+
+		WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative");
+		spin_unlock(&cifs_tcp_ses_lock);
+
+		if (tcon->ses)
+			server = tcon->ses->server;
+
+		cifs_server_dbg(FYI, "tid=%u: tcon is closing, skipping async close retry of fid %llu %llu\n",
+				tcon->tid, persistent_fid, volatile_fid);
+
+		return 0;
+	}
 	tcon->tc_count++;
 	spin_unlock(&cifs_tcp_ses_lock);
 


