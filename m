Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6F2601F35
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiJRAQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbiJRAOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:14:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2F88A1E4;
        Mon, 17 Oct 2022 17:12:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9A7B61350;
        Tue, 18 Oct 2022 00:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEADDC43470;
        Tue, 18 Oct 2022 00:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051902;
        bh=MQB3+rqQQiv9DzGp/23KOPIWRdOXtGc2aFcNcsP9Oz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T//1Zmr/FkHXqpjhrVZYtL+oHeQEg7XN5ICFNh4kSFIM1W5c4FaN4DSmFC2Uvl3Ud
         LF4vZUFFmZSOX7eRsPwv8swibPPzCsLBRvsHD6+FfGKpdm5z8h0SXKy0pCrFQUMKUs
         Z+xNtci+l7hBaeIpSa0bq4B6vVrzzOJ/AqtFseuB48dn32WRtxPkPb24/GxXIbFbtY
         4jchwWGN139auXxrzGl64J05+798QSrDu7ywn5ALNldMxCKY7ks2XStIePn/kvnKsk
         NhvumZOrCW/exokmeGoldunqAoR+id4OhjqGByTk7SSnjVt/HGjsKb2JIYqNEe6buM
         qvNUyVZaW/1Qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Ungerer <gerg@linux-m68k.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 4.19 07/10] m68knommu: fix non-mmu classic 68000 legacy timer tick selection
Date:   Mon, 17 Oct 2022 20:11:25 -0400
Message-Id: <20221018001128.2732162-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018001128.2732162-1-sashal@kernel.org>
References: <20221018001128.2732162-1-sashal@kernel.org>
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
index b2fd1e2fbd89..013a410a3843 100644
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

