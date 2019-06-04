Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4114F3545B
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfFDXWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:22:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726635AbfFDXWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:22:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1C6E20859;
        Tue,  4 Jun 2019 23:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690541;
        bh=YtglIMwK7INQuWj4c2V37XI7x+t8ztLWvGFCnEyoZ6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iaHXO8ADX5y16Ntpm+bg8LZk7rFB8H2f5DhgEsAB7J1tQYbiD+oZamhlF19o992T9
         JDIbTtRxUOMe2xBnUZzCCMFrZFnnJWtB9KkE9AwFz0+NpanLuGtm0aAki8HVJEyv8g
         YGakRl7mDKuxWb8akoSI/D8DgMOhQ/FU8OeUN5ks=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        syzbot+9437020c82413d00222d@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 03/60] ALSA: seq: Fix race of get-subscription call vs port-delete ioctls
Date:   Tue,  4 Jun 2019 19:21:13 -0400
Message-Id: <20190604232212.6753-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232212.6753-1-sashal@kernel.org>
References: <20190604232212.6753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

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
index b3280e81bfd1..8599f2937ac1 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1900,20 +1900,14 @@ static int snd_seq_ioctl_get_subscription(struct snd_seq_client *client,
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
index 24d90abfc64d..a31e16cc012e 100644
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

