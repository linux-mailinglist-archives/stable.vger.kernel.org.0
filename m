Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD7F21FB2F
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731276AbgGNS7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729694AbgGNS7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:59:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C599122B30;
        Tue, 14 Jul 2020 18:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753170;
        bh=AtVRfcjq3s0KS66WD2PIO0/e7a2vkESa5UXWYT5fqgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0FB2OVZs7xAkqnmWcXvWwOQtyvmK/rA3jdhOoQInrhwp9SpXgJFwAAYOR8tRr5tRc
         ecTvNA3YslCVfOF5Q0rlWBxKW/mZCduUI4YLEnqvHG5gc/gTqCOcZZS+guF6CK//db
         WR1+W5Z/32soaOA35LjEiOv8EwB7TAgZe8CcPicg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 5.7 146/166] cifs: fix reference leak for tlink
Date:   Tue, 14 Jul 2020 20:45:11 +0200
Message-Id: <20200714184122.817333975@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

commit a77592a70081edb58a95b9da18fd5a2882a25666 upstream.

Don't leak a reference to tlink during the NOTIFY ioctl

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
CC: Stable <stable@vger.kernel.org> # v5.6+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/ioctl.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -169,6 +169,7 @@ long cifs_ioctl(struct file *filep, unsi
 	unsigned int xid;
 	struct cifsFileInfo *pSMBFile = filep->private_data;
 	struct cifs_tcon *tcon;
+	struct tcon_link *tlink;
 	struct cifs_sb_info *cifs_sb;
 	__u64	ExtAttrBits = 0;
 	__u64   caps;
@@ -307,13 +308,19 @@ long cifs_ioctl(struct file *filep, unsi
 				break;
 			}
 			cifs_sb = CIFS_SB(inode->i_sb);
-			tcon = tlink_tcon(cifs_sb_tlink(cifs_sb));
+			tlink = cifs_sb_tlink(cifs_sb);
+			if (IS_ERR(tlink)) {
+				rc = PTR_ERR(tlink);
+				break;
+			}
+			tcon = tlink_tcon(tlink);
 			if (tcon && tcon->ses->server->ops->notify) {
 				rc = tcon->ses->server->ops->notify(xid,
 						filep, (void __user *)arg);
 				cifs_dbg(FYI, "ioctl notify rc %d\n", rc);
 			} else
 				rc = -EOPNOTSUPP;
+			cifs_put_tlink(tlink);
 			break;
 		default:
 			cifs_dbg(FYI, "unsupported ioctl\n");


