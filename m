Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168E46088EE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiJVIZ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbiJVIYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:24:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CD05D881;
        Sat, 22 Oct 2022 01:00:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29D3260B88;
        Sat, 22 Oct 2022 07:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33089C433D7;
        Sat, 22 Oct 2022 07:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425506;
        bh=f0I55/u99pGYDq+p5TcYl8mlp27PqkFcOL+TYbcY9o0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3kfXn9fR4kZYL+gPt8xrU1oATBPZn58CqkOIl9Ka1+N/9KHIpvHjcZeQR/EOyyLI
         AwAffsBltF5Ne+oxvfpaen4cnAxNz/GGfkQEWf98RttihglgcDjSnQTwtJ9js2TkwY
         GLyVVLdSkUFFqegETaAwz9bJS11I4Dfge4zBtqMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 493/717] powerpc/configs: Properly enable PAPR_SCM in pseries_defconfig
Date:   Sat, 22 Oct 2022 09:26:12 +0200
Message-Id: <20221022072520.096335533@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit aa398d88aea4ec863bd7aea35d5035a37096dc59 ]

My commit to add PAPR_SCM to pseries_defconfig failed to add the
required dependencies, meaning the driver doesn't get built.

Add the required LIBNVDIMM=m.

Fixes: d6481a7195df ("powerpc/configs: Add PAPR_SCM to pseries_defconfig")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220901014253.252927-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/configs/pseries_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/configs/pseries_defconfig b/arch/powerpc/configs/pseries_defconfig
index b571d084c148..c05e37af9f1e 100644
--- a/arch/powerpc/configs/pseries_defconfig
+++ b/arch/powerpc/configs/pseries_defconfig
@@ -40,6 +40,7 @@ CONFIG_PPC_SPLPAR=y
 CONFIG_DTL=y
 CONFIG_PPC_SMLPAR=y
 CONFIG_IBMEBUS=y
+CONFIG_LIBNVDIMM=m
 CONFIG_PAPR_SCM=m
 CONFIG_PPC_SVM=y
 # CONFIG_PPC_PMAC is not set
-- 
2.35.1



