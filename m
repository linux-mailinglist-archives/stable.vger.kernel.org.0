Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147E44F2E0C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350255AbiDEJ4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242685AbiDEJIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:08:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D4D6F4B7;
        Tue,  5 Apr 2022 01:57:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A0BC6117A;
        Tue,  5 Apr 2022 08:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77F75C385A0;
        Tue,  5 Apr 2022 08:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149023;
        bh=+JEE0Ko2epQOw9p8Y1HZu2AvWRrrxNXwTXSbRl53Sw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMa6NvIhwZEhb9+MRURppIqj+4EqBT0aZr0WxTZUMEyX27rMEmD9Of1lXyWVXlkaA
         f0KRi3LWwZuUpgDDmf8/ag1trPWuf00ThOYhUI4ymEwQvQ/eEuUIOazNo7BsCsvWqs
         t144bNbgwVUMHC0D/YXduq0jWIsBemAzX5G6yGyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0567/1017] KVM: arm64: Enable Cortex-A510 erratum 2077057 by default
Date:   Tue,  5 Apr 2022 09:24:40 +0200
Message-Id: <20220405070411.110755242@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 4c11113c1a3d10f5b617e5d2b9acd8d1d715450f ]

The recently added configuration option for Cortex A510 erratum 2077057 does
not have a "default y" unlike other errata fixes. This appears to simply be
an oversight since the help text suggests enabling the option if unsure and
there's nothing in the commit log to suggest it is intentional.

Fixes: 1dd498e5e26ad ("KVM: arm64: Workaround Cortex-A510's single-step and PAC trap errata")
Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220225184658.172527-1-broonie@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index d05d94d2b28b..0a83e1728f7e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -683,6 +683,7 @@ config ARM64_ERRATUM_2051678
 
 config ARM64_ERRATUM_2077057
 	bool "Cortex-A510: 2077057: workaround software-step corrupting SPSR_EL2"
+	default y
 	help
 	  This option adds the workaround for ARM Cortex-A510 erratum 2077057.
 	  Affected Cortex-A510 may corrupt SPSR_EL2 when the a step exception is
-- 
2.34.1



