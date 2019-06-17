Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 786B249345
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbfFQV3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:29:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730168AbfFQV3V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:29:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFC9D2070B;
        Mon, 17 Jun 2019 21:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806960;
        bh=bARVfcUCbmuW2vaRSIe61rMyBmPVikjcO8HqO9tWEhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1fY9+/86piSsLONH9ZWkzmFAdtl4B3DjLvvKq4zNS5A3/KaubU2ePqj2Nk7oeGGj2
         SzX9Zbl6Zcq2hj3kIb5qDTwJPL/XBtY2lTZC5hRsULmXQAoOUWlHzKVZLT78yzVvd7
         wiT6bZvcxIEEwOAhbNyxdazhCpVPzQ01kBdAbu4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9437020c82413d00222d@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 24/53] ALSA: seq: Fix race of get-subscription call vs port-delete ioctls
Date:   Mon, 17 Jun 2019 23:10:07 +0200
Message-Id: <20190617210750.044414043@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
References: <20190617210745.104187490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 2eabc5ec8ab4d4748a82050dfcb994119b983750 ]

The snd_seq_ioctl_get_subscription() retrieves the port subscriber
information as a pointer, while the object isn't protected, hence it
may be deleted before the actual reference.  This race was spotted by
syzkaller and may lead to a UAF.

The fix is simply copying the data in the lookup function that
performs in the rwsem to protect against the deletion.

Reported-by: syzbot+9437020c82413d00222d@syzkaller.appspotmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 10 ++--------
 sound/core/seq/seq_ports.c     | 13 ++++++++-----
 sound/core/seq/seq_ports.h     |  5 +++--
 3 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 692631bd4a35..068880ac47b5 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1904,20 +1904,14 @@ static int snd_seq_ioctl_get_subscription(struct snd_seq_client *client,
 	int result;
 	struct snd_seq_client *sender = NULL;
 	struct snd_seq_client_port *sport = NULL;
-	struct snd_seq_subscribers *p;
 
 	result = -EINVAL;
 	if ((sender = snd_seq_client_use_ptr(subs->sender.client)) == NULL)
 		goto __end;
 	if ((sport = snd_seq_port_use_ptr(sender, subs->sender.port)) == NULL)
 		goto __end;
-	p = snd_seq_port_get_subscription(&sport->c_src, &subs->dest);
-	if (p) {
-		result = 0;
-		*subs = p->info;
-	} else
-		result = -ENOENT;
-
+	result = snd_seq_port_get_subscription(&sport->c_src, &subs->dest,
+					       subs);
       __end:
       	if (sport)
 		snd_seq_port_unlock(sport);
diff --git a/sound/core/seq/seq_ports.c b/sound/core/seq/seq_ports.c
index d3fc73ac230b..c8fa4336bccd 100644
--- a/sound/core/seq/seq_ports.c
+++ b/sound/core/seq/seq_ports.c
@@ -635,20 +635,23 @@ int snd_seq_port_disconnect(struct snd_seq_client *connector,
 
 
 /* get matched subscriber */
-struct snd_seq_subscribers *snd_seq_port_get_subscription(struct snd_seq_port_subs_info *src_grp,
-							  struct snd_seq_addr *dest_addr)
+int snd_seq_port_get_subscription(struct snd_seq_port_subs_info *src_grp,
+				  struct snd_seq_addr *dest_addr,
+				  struct snd_seq_port_subscribe *subs)
 {
-	struct snd_seq_subscribers *s, *found = NULL;
+	struct snd_seq_subscribers *s;
+	int err = -ENOENT;
 
 	down_read(&src_grp->list_mutex);
 	list_for_each_entry(s, &src_grp->list_head, src_list) {
 		if (addr_match(dest_addr, &s->info.dest)) {
-			found = s;
+			*subs = s->info;
+			err = 0;
 			break;
 		}
 	}
 	up_read(&src_grp->list_mutex);
-	return found;
+	return err;
 }
 
 /*
diff --git a/sound/core/seq/seq_ports.h b/sound/core/seq/seq_ports.h
index 26bd71f36c41..06003b36652e 100644
--- a/sound/core/seq/seq_ports.h
+++ b/sound/core/seq/seq_ports.h
@@ -135,7 +135,8 @@ int snd_seq_port_subscribe(struct snd_seq_client_port *port,
 			   struct snd_seq_port_subscribe *info);
 
 /* get matched subscriber */
-struct snd_seq_subscribers *snd_seq_port_get_subscription(struct snd_seq_port_subs_info *src_grp,
-							  struct snd_seq_addr *dest_addr);
+int snd_seq_port_get_subscription(struct snd_seq_port_subs_info *src_grp,
+				  struct snd_seq_addr *dest_addr,
+				  struct snd_seq_port_subscribe *subs);
 
 #endif
-- 
2.20.1



