Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47D24601F83
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbiJRAVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiJRAUU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:20:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7918C005;
        Mon, 17 Oct 2022 17:16:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A4CBB81B62;
        Tue, 18 Oct 2022 00:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204A1C433D6;
        Tue, 18 Oct 2022 00:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051916;
        bh=o75o+6oKx5y4PpkAivNhZ9rAwEVjvoYaFDTF8LWXaWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYuKGX512r/83Ux4fxoyG+MwPdy7MiW3OXk6H3mY/VASVc50WqeKLNxi1m42TcUh1
         EX4d5QTVH4uUasyShGTS3q4jLjDhTUsVjMQatd3bLqoOUH9ihHDYDZJGWfvY8PTRnP
         q4oUARijwlFIOXKvatnu8+pKYyGeB9QWl4jg85rTx+89rV3NdC3HAjQr+juN0yL5Wq
         0RgR3co9u2qctvcBUVgKFR+lF36dsDLj9sOFllFepZt+26K/pvoMqBvK2K9qi3M9xB
         APuKonjqZVkPwJ3yeU9k1Oj2pPFO7QZNTVlkkNlXBQBv2Nj5vLHsblc18TPscpYIHt
         MfWWyIbNsvLDw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Ungerer <gerg@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 4.14 5/8] m68knommu: fix non-mmu classic 68000 legacy timer tick selection
Date:   Mon, 17 Oct 2022 20:11:44 -0400
Message-Id: <20221018001147.2732350-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018001147.2732350-1-sashal@kernel.org>
References: <20221018001147.2732350-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Ungerer <gerg@linux-m68k.org>

[ Upstream commit 18011e50c497f04a57a8e00122906f04922b30b4 ]

The family of classic 68000 parts supported when in non-mmu mode all
currently use the legacy timer support. Move the selection of that config
option, LEGACY_TIMER_TICK, into the core CPU configuration.

This fixes compilation if no specific CPU variant is selected, since
the LEGACY_TIMER_TICK option was only selected in the specific CPU
variant configurations.

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/Kconfig.cpu | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index 6f13c53c8dc7..3f5b92f567dc 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -43,6 +43,7 @@ config M68000
 	select GENERIC_CSUM
 	select CPU_NO_EFFICIENT_FFS
 	select HAVE_ARCH_HASH
+	select LEGACY_TIMER_TICK
 	help
 	  The Freescale (was Motorola) 68000 CPU is the first generation of
 	  the well known M68K family of processors. The CPU core as well as
-- 
2.35.1

