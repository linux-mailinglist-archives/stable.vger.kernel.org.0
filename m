Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFEB59E0E0
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355965AbiHWKsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348824AbiHWKoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:44:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65731F623;
        Tue, 23 Aug 2022 02:10:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AECFB81C63;
        Tue, 23 Aug 2022 09:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AC5C433D6;
        Tue, 23 Aug 2022 09:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245837;
        bh=M7TKMYo57ff+jZ0hl6iAQ7cIE6ReY/Atz2km7YpeMGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGgjpk4UIsm2C67OsB5S9jzpk3ww5FCTG8gcW0TSW3R7nXB0WIYIxV7EjjqXGnoVJ
         BzMnRbq2chue/0cxht+6WGuMAWqdL0XWH53lQLpq5OcM+dNkJKk3Am2Jux5pZfufXI
         GrDU4NFMikqel0NrOflnTqYElIL6zLP1eC2eZx0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 175/287] powerpc/pci: Fix PHB numbering when using opal-phbid
Date:   Tue, 23 Aug 2022 10:25:44 +0200
Message-Id: <20220823080106.654879180@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit f4b39e88b42d13366b831270306326b5c20971ca ]

The recent change to the PHB numbering logic has a logic error in the
handling of "ibm,opal-phbid".

When an "ibm,opal-phbid" property is present, &prop is written to and
ret is set to zero.

The following call to of_alias_get_id() is skipped because ret == 0.

But then the if (ret >= 0) is true, and the body of that if statement
sets prop = ret which throws away the value that was just read from
"ibm,opal-phbid".

Fix the logic by only doing the ret >= 0 check in the of_alias_get_id()
case.

Fixes: 0fe1e96fef0a ("powerpc/pci: Prefer PCI domain assignment via DT 'linux,pci-domain' and alias")
Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220802105723.1055178-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/pci-common.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index b0bd55f2ce3a..740dcbdd56d8 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -98,11 +98,13 @@ static int get_phb_number(struct device_node *dn)
 	}
 	if (ret)
 		ret = of_property_read_u64(dn, "ibm,opal-phbid", &prop);
-	if (ret)
+
+	if (ret) {
 		ret = of_alias_get_id(dn, "pci");
-	if (ret >= 0) {
-		prop = ret;
-		ret = 0;
+		if (ret >= 0) {
+			prop = ret;
+			ret = 0;
+		}
 	}
 	if (ret) {
 		u32 prop_32;
-- 
2.35.1



