Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7FD6586A5A
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiHAMPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234032AbiHAMOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8529F78222;
        Mon,  1 Aug 2022 04:58:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 127F6601CD;
        Mon,  1 Aug 2022 11:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21691C433C1;
        Mon,  1 Aug 2022 11:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355080;
        bh=CLVAxviFNkM+6MZHDWRFc5Wxzx2ONWeNJkWfDn1Ffvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yecUOsqLXBZxWWJOCfeGryzO5wTYA4e4llFvJTrtwOxtP+2ABkW9072YjdjSKjTBe
         hStt3dYXiG4dHBIJk+gqruiBqfqzFvcJAFCVQ3ZcnwFyqk99mMjXolMsrWlCIUWsPz
         chAXJGN/BfvppCY7fIN4vYEOisBuDSp6QRXw6gCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 55/88] macsec: always read MACSEC_SA_ATTR_PN as a u64
Date:   Mon,  1 Aug 2022 13:47:09 +0200
Message-Id: <20220801114140.554941467@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit c630d1fe6219769049c87d1a6a0e9a6de55328a1 ]

Currently, MACSEC_SA_ATTR_PN is handled inconsistently, sometimes as a
u32, sometimes forced into a u64 without checking the actual length of
the attribute. Instead, we can use nla_get_u64 everywhere, which will
read up to 64 bits into a u64, capped by the actual length of the
attribute coming from userspace.

This fixes several issues:
 - the check in validate_add_rxsa doesn't work with 32-bit attributes
 - the checks in validate_add_txsa and validate_upd_sa incorrectly
   reject X << 32 (with X != 0)

Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index b3834e353c22..95578f04f212 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1698,7 +1698,7 @@ static bool validate_add_rxsa(struct nlattr **attrs)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_PN] &&
-	    *(u64 *)nla_data(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	    nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -1941,7 +1941,7 @@ static bool validate_add_txsa(struct nlattr **attrs)
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
 		return false;
 
-	if (nla_get_u32(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	if (nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
@@ -2295,7 +2295,7 @@ static bool validate_upd_sa(struct nlattr **attrs)
 	if (nla_get_u8(attrs[MACSEC_SA_ATTR_AN]) >= MACSEC_NUM_AN)
 		return false;
 
-	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u32(attrs[MACSEC_SA_ATTR_PN]) == 0)
+	if (attrs[MACSEC_SA_ATTR_PN] && nla_get_u64(attrs[MACSEC_SA_ATTR_PN]) == 0)
 		return false;
 
 	if (attrs[MACSEC_SA_ATTR_ACTIVE]) {
-- 
2.35.1



