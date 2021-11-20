Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43725457E3C
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 13:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237139AbhKTMmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Nov 2021 07:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbhKTMmu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Nov 2021 07:42:50 -0500
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DCFC06173E
        for <stable@vger.kernel.org>; Sat, 20 Nov 2021 04:39:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1637411985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GtMYygK9CveU6Qg0qkcv5EHFKfWIoCejXMN28DDIRIY=;
        b=mRFyaOYVDSJP4O2rjxp8DbsFExQjcs+wmPTu+x0xn0HNQX3IR5SRcjSsSc8/vzn+SANXIZ
        G9acRpR+yN4kRvtgNJjeWjFj8qLDY7TFlHfncl4CVTAeOtAeBSOA02O2wtQm2z9iuId35C
        kDixKdMqRh9WfV5iMnR0UaXwk+fxLmw=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org, Taehee Yoo <ap420073@gmail.com>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 4.4 07/11] batman-adv: set .owner to THIS_MODULE
Date:   Sat, 20 Nov 2021 13:39:35 +0100
Message-Id: <20211120123939.260723-8-sven@narfation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211120123939.260723-1-sven@narfation.org>
References: <20211120123939.260723-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

commit 14a2e551faea53d45bc11629a9dac88f88950ca7 upstream.

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
[ bp: 4.4 backported: switch to old filename. ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
---
 net/batman-adv/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/debugfs.c b/net/batman-adv/debugfs.c
index b2ef03a3a2d4..b905763dc2e7 100644
--- a/net/batman-adv/debugfs.c
+++ b/net/batman-adv/debugfs.c
@@ -214,6 +214,7 @@ static const struct file_operations batadv_log_fops = {
 	.read           = batadv_log_read,
 	.poll           = batadv_log_poll,
 	.llseek         = no_llseek,
+	.owner          = THIS_MODULE,
 };
 
 static int batadv_debug_log_setup(struct batadv_priv *bat_priv)
-- 
2.30.2

