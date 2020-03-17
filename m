Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E50189223
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgCQX2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:28:31 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53960 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727150AbgCQX2b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:28:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CeJ/bYIqtOheRKe9BZTPNWDn8zoW+HWaPsaAuBlspCo=;
        b=1zelvDBMgl91+/TqiX6MpZpy77dupFfW+2wKjxJdWGZC+enDvA1jQNRLZwBAYmyvxG3CIH
        iCNznoUWpvVyhy1R1uytrop7fbNpr/uNVUdtgaqbGvlLCOjHKiIrO+tidnt8wTB2LtjNtG
        /cqPlfJMESEkj48RlKXc5Od+ikJpyl8=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        syzbot+a98f2016f40b9cd3818a@syzkaller.appspotmail.com,
        syzbot+ac36b6a33c28a491e929@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 48/48] batman-adv: Don't schedule OGM for disabled interface
Date:   Wed, 18 Mar 2020 00:27:34 +0100
Message-Id: <20200317232734.6127-49-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A transmission scheduling for an interface which is currently dropped by
batadv_iv_ogm_iface_disable could still be in progress. The B.A.T.M.A.N. V
is simply cancelling the workqueue item in an synchronous way but this is
not possible with B.A.T.M.A.N. IV because the OGM submissions are
intertwined.

Instead it has to stop submitting the OGM when it detect that the buffer
pointer is set to NULL.

Reported-by: syzbot+a98f2016f40b9cd3818a@syzkaller.appspotmail.com
Reported-by: syzbot+ac36b6a33c28a491e929@syzkaller.appspotmail.com
Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/bat_iv_ogm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index eb2f2ed9a956..caea5bb38d4b 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -944,6 +944,10 @@ static void batadv_iv_ogm_schedule_buff(struct batadv_hard_iface *hard_iface)
 
 	lockdep_assert_held(&hard_iface->bat_iv.ogm_buff_mutex);
 
+	/* interface already disabled by batadv_iv_ogm_iface_disable */
+	if (!*ogm_buff)
+		return;
+
 	primary_if = batadv_primary_if_get_selected(bat_priv);
 
 	if (hard_iface == primary_if) {
-- 
2.20.1

