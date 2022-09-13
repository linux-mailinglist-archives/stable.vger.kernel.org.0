Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 160265B7179
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiIMOli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiIMOkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C85E6D9E3;
        Tue, 13 Sep 2022 07:21:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38EAA614AE;
        Tue, 13 Sep 2022 14:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D2DC433C1;
        Tue, 13 Sep 2022 14:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078842;
        bh=tZ63s44RQjryfuCe0CUUP58SoCsvCG597kk38pNZ/W4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wb48VH/FJ58+DR1JSNqNgtz8Gk4lApCCZCs1Kzcyf4p6CCBWMm73aDiSprY3a4zEc
         wgTjqKo3p3c6CxpiYnOtxTUU5bOEC+4GMZB3v5q+Od7+1k9iuI8RCuvy44zBuxLYaW
         +xjYJJ+ilke7PjPxmPPuY1tmTicBmnjxzq6S6Vhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/121] kbuild: disable header exports for UML in a straightforward way
Date:   Tue, 13 Sep 2022 16:04:55 +0200
Message-Id: <20220913140401.818922514@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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
index eca45b7be9c1e..32253ea989217 100644
--- a/Makefile
+++ b/Makefile
@@ -1332,8 +1332,7 @@ hdr-inst := -f $(srctree)/scripts/Makefile.headersinst obj
 
 PHONY += headers
 headers: $(version_h) scripts_unifdef uapi-asm-generic archheaders archscripts
-	$(if $(wildcard $(srctree)/arch/$(SRCARCH)/include/uapi/asm/Kbuild),, \
-	  $(error Headers not exportable for the $(SRCARCH) architecture))
+	$(if $(filter um, $(SRCARCH)), $(error Headers not exportable for UML))
 	$(Q)$(MAKE) $(hdr-inst)=include/uapi
 	$(Q)$(MAKE) $(hdr-inst)=arch/$(SRCARCH)/include/uapi
 
-- 
2.35.1



