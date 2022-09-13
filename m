Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1315B70A4
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiIMO3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiIMO1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:27:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956A467C81;
        Tue, 13 Sep 2022 07:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 11161614AE;
        Tue, 13 Sep 2022 14:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D007C433C1;
        Tue, 13 Sep 2022 14:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078564;
        bh=nZlTkWxulH2UpdsCFOA3yRVT5nN7ysECwwHbj4rH5Yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pu6jXDWaEStngFhy6R+sVgvsMGxEfIrRhMHq5okpQnc5kREX9M7LfJDZZutJiTSEQ
         xMDvkAUuU6JbetqVBMPwZy/jvuiGmJ9QTM2rLWsxdSFpogHzeUsUfWFCi5C0Ge7gBO
         Vl4u8PW6cL2nqYUPw/sfAmcolqcuB3oIYcfbcY/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 163/192] kbuild: disable header exports for UML in a straightforward way
Date:   Tue, 13 Sep 2022 16:04:29 +0200
Message-Id: <20220913140418.152401588@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 1b620d539ccc18a1aca1613d9ff078115a7891a1 ]

Previously 'make ARCH=um headers' stopped because of missing
arch/um/include/uapi/asm/Kbuild.

The error is not shown since commit ed102bf2afed ("um: Fix W=1
missing-include-dirs warnings") added arch/um/include/uapi/asm/Kbuild.

Hard-code the unsupported architecture, so it works like before.

Fixes: ed102bf2afed ("um: Fix W=1 missing-include-dirs warnings")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index e361c6230e9e5..2acd87dd62591 100644
--- a/Makefile
+++ b/Makefile
@@ -1286,8 +1286,7 @@ hdr-inst := -f $(srctree)/scripts/Makefile.headersinst obj
 
 PHONY += headers
 headers: $(version_h) scripts_unifdef uapi-asm-generic archheaders archscripts
-	$(if $(wildcard $(srctree)/arch/$(SRCARCH)/include/uapi/asm/Kbuild),, \
-	  $(error Headers not exportable for the $(SRCARCH) architecture))
+	$(if $(filter um, $(SRCARCH)), $(error Headers not exportable for UML))
 	$(Q)$(MAKE) $(hdr-inst)=include/uapi
 	$(Q)$(MAKE) $(hdr-inst)=arch/$(SRCARCH)/include/uapi
 
-- 
2.35.1



