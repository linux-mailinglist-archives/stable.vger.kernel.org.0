Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A550D1B3FE4
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731456AbgDVKlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730074AbgDVKUN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:20:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61B45208E4;
        Wed, 22 Apr 2020 10:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550807;
        bh=CV4lsd8GFjskQ68BrjCsNHsoRiEhRicJFGhZqLBaR7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCQ0JxXzvLKxAe2hOJ0WUpgR4psir2T4VKXKfRNrJbFifgzpedsN649RaPAPIPl6w
         5jjjd6UHgUkz/LgbAFZXztq1eX/s1kQLhU/5RdGorYNalcS0TQY8HNKMEKhSHt5mWy
         jINg5Uk2ou5JXM8K5LSoUIg5ZC1vu3OhWhFRUPgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 101/118] net: dsa: bcm_sf2: Fix overflow checks
Date:   Wed, 22 Apr 2020 11:57:42 +0200
Message-Id: <20200422095047.845206568@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit d0802dc411f469569a537283b6f3833af47aece9 upstream.

Commit f949a12fd697 ("net: dsa: bcm_sf2: fix buffer overflow doing
set_rxnfc") tried to fix the some user controlled buffer overflows in
bcm_sf2_cfp_rule_set() and bcm_sf2_cfp_rule_del() but the fix was using
CFP_NUM_RULES, which while it is correct not to overflow the bitmaps, is
not representative of what the device actually supports. Correct that by
using bcm_sf2_cfp_rule_size() instead.

The latter subtracts the number of rules by 1, so change the checks from
greater than or equal to greater than accordingly.

Fixes: f949a12fd697 ("net: dsa: bcm_sf2: fix buffer overflow doing set_rxnfc")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/dsa/bcm_sf2_cfp.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -882,17 +882,14 @@ static int bcm_sf2_cfp_rule_set(struct d
 	     fs->m_ext.data[1]))
 		return -EINVAL;
 
-	if (fs->location != RX_CLS_LOC_ANY && fs->location >= CFP_NUM_RULES)
+	if (fs->location != RX_CLS_LOC_ANY &&
+	    fs->location > bcm_sf2_cfp_rule_size(priv))
 		return -EINVAL;
 
 	if (fs->location != RX_CLS_LOC_ANY &&
 	    test_bit(fs->location, priv->cfp.used))
 		return -EBUSY;
 
-	if (fs->location != RX_CLS_LOC_ANY &&
-	    fs->location > bcm_sf2_cfp_rule_size(priv))
-		return -EINVAL;
-
 	ret = bcm_sf2_cfp_rule_cmp(priv, port, fs);
 	if (ret == 0)
 		return -EEXIST;
@@ -973,7 +970,7 @@ static int bcm_sf2_cfp_rule_del(struct b
 	struct cfp_rule *rule;
 	int ret;
 
-	if (loc >= CFP_NUM_RULES)
+	if (loc > bcm_sf2_cfp_rule_size(priv))
 		return -EINVAL;
 
 	/* Refuse deleting unused rules, and those that are not unique since


