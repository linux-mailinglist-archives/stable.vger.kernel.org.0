Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46543354A5
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 02:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfFEAPo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 20:15:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51472 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbfFEAPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 20:15:44 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6CE67223879;
        Wed,  5 Jun 2019 00:15:42 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-17.bne.redhat.com [10.64.54.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0529912A65;
        Wed,  5 Jun 2019 00:15:41 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Stable <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: fix panic in smb2_reconnect
Date:   Wed,  5 Jun 2019 10:15:34 +1000
Message-Id: <20190605001534.28278-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 05 Jun 2019 00:15:42 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RH Bugzilla: 1702264

We need to protect so that the call to smb2_reconnect() in
smb2_reconnect_server() does not end up freeing the session
because it can lead to a use after free and crash.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2pdu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 565b60b62f4d..ab8dc73d2282 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3113,9 +3113,14 @@ void smb2_reconnect_server(struct work_struct *work)
 				tcon_exist = true;
 			}
 		}
+		/*
+		 * IPC has the same lifetime as its session and uses its
+		 * refcount.
+		 */
 		if (ses->tcon_ipc && ses->tcon_ipc->need_reconnect) {
 			list_add_tail(&ses->tcon_ipc->rlist, &tmp_list);
 			tcon_exist = true;
+			ses->ses_count++;
 		}
 	}
 	/*
@@ -3134,7 +3139,10 @@ void smb2_reconnect_server(struct work_struct *work)
 		else
 			resched = true;
 		list_del_init(&tcon->rlist);
-		cifs_put_tcon(tcon);
+		if (tcon->ipc)
+			cifs_put_smb_ses(tcon->ses);
+		else
+			cifs_put_tcon(tcon);
 	}
 
 	cifs_dbg(FYI, "Reconnecting tcons finished\n");
-- 
2.13.6

