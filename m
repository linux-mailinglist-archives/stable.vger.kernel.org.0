Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FC21B3D85
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbgDVKPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729678AbgDVKPj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:15:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92B212070B;
        Wed, 22 Apr 2020 10:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550539;
        bh=Oa3weY7BfUIns8j7jNX/b1G9HlmZHjIRmvuenY3urTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffJ2U42esklSNjXOhX7PWIdh0zKWmTGARFD3TDovlGBExpydd+LMZ6JxpVsXG/r5L
         guLgs+Ml3r2eKHuBUbPTLvaBHsDcosEjhn2pxSb+QMvLytYoBmmzf7gzXHs44cBPSC
         yD2W429qqtsElZCCeLyVDpGJrrWa4OYVpuP0XLwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 55/64] net: dsa: bcm_sf2: Fix overflow checks
Date:   Wed, 22 Apr 2020 11:57:39 +0200
Message-Id: <20200422095022.788532969@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
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
@@ -742,17 +742,14 @@ static int bcm_sf2_cfp_rule_set(struct d
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
 	/* This rule is a Wake-on-LAN filter and we must specifically
 	 * target the CPU port in order for it to be working.
 	 */
@@ -839,7 +836,7 @@ static int bcm_sf2_cfp_rule_del(struct b
 	u32 next_loc = 0;
 	int ret;
 
-	if (loc >= CFP_NUM_RULES)
+	if (loc > bcm_sf2_cfp_rule_size(priv))
 		return -EINVAL;
 
 	/* Refuse deleting unused rules, and those that are not unique since


