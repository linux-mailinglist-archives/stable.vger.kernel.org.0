Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E55459D9AF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243274AbiHWJ7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243699AbiHWJ56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:57:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75CEA1D1E;
        Tue, 23 Aug 2022 01:47:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6191AB81C3B;
        Tue, 23 Aug 2022 08:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09D7C433D7;
        Tue, 23 Aug 2022 08:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244466;
        bh=cGv9YYiCAnF/hXVtpd8NFHpulmJj4WgT2Ko+E71vVug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OP8SxbLdDrD5qcxJT8qXnaJQyhxyQ/UayEBZi5fMwoGZF+IohwWczYNN7ZWHtmyFq
         f0aIts7KgSZfesKZFkf9/+eayiGqKCThxL1RbvrxRkxUWqWklskI/Cw2Yc+03/1+TX
         b5sTZPKfkS12M+30Xmeu2YdpShxlnRbngZHKJIVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 141/229] powerpc/pci: Fix PHB numbering when using opal-phbid
Date:   Tue, 23 Aug 2022 10:25:02 +0200
Message-Id: <20220823080058.719989060@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
index 2e2cc80bf592..936f24d7ab4c 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -96,11 +96,13 @@ static int get_phb_number(struct device_node *dn)
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



