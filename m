Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C2759A282
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353275AbiHSQhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353382AbiHSQfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:35:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4561B107AF3;
        Fri, 19 Aug 2022 09:07:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7892B82813;
        Fri, 19 Aug 2022 16:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DDDC433C1;
        Fri, 19 Aug 2022 16:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925233;
        bh=ylVkh8v+450dEiwjru0VBg5cl/Fq58A+w4Oz09L0Oco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qo4Gsn9lWrliddcyb1ORKSl3JUWJ+m6slNc2Vb/5WVwktOeYZzqF39hGLf0zNEJiN
         4PQyAUUIugUv7d8a6yj4ibeeZDBlpU6SgIKAz/gRc0bwXnOeVFUpmJ9c1voEp7bsrm
         I1U+zIdB5Anm6PwPO+PZNNqFE8sZ6RpAi1dT84L4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 426/545] powerpc/pci: Fix PHB numbering when using opal-phbid
Date:   Fri, 19 Aug 2022 17:43:16 +0200
Message-Id: <20220819153848.477906421@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 7af00a880e16..f9d35c9ea4ae 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -89,11 +89,13 @@ static int get_phb_number(struct device_node *dn)
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



