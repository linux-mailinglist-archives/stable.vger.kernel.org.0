Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDC35F2905
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiJCHMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiJCHMT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:12:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A2938465;
        Mon,  3 Oct 2022 00:12:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8140B80E67;
        Mon,  3 Oct 2022 07:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBA4C433D7;
        Mon,  3 Oct 2022 07:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781131;
        bh=EV0UFiTw4zmp+/QrmHKwqSCnv35GQfstFaelby4prYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P08kGE+iHAvf8Tgl8u1oIPJwy5HB94nfh//XvkIWDAsg7+yIGanPL1uar51UDcg5Y
         +WWD2DaNrG3DTfCwUyFLiKPbcPyUwgjzAM22L8nFgKw0nFbZYahhVsD5jd2b5G2cdc
         fIEH2HdAkdllV7tZGlQXw43PlLE2A/XtNH26do7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Heiko Stuebner <heiko@sntech.de>, Guo Ren <guoren@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 001/101] riscv: make t-head erratas depend on MMU
Date:   Mon,  3 Oct 2022 09:09:57 +0200
Message-Id: <20221003070724.531191578@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 2a2018c3ac84c2dc7cfbad117ce9339ea0914622 ]

Both basic extensions of SVPBMT and ZICBOM depend on CONFIG_MMU.
Make the T-Head errata implementations of the similar functionality
also depend on it to prevent build errors.

Fixes: a35707c3d850 ("riscv: add memory-type errata for T-Head")
Fixes: d20ec7529236 ("riscv: implement cache-management errata for T-Head SoCs")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Guo Ren <guoren@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220907154932.2858518-1-heiko@sntech.de
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/Kconfig.erratas | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig.erratas b/arch/riscv/Kconfig.erratas
index 457ac72c9b36..e59a770b4432 100644
--- a/arch/riscv/Kconfig.erratas
+++ b/arch/riscv/Kconfig.erratas
@@ -46,7 +46,7 @@ config ERRATA_THEAD
 
 config ERRATA_THEAD_PBMT
 	bool "Apply T-Head memory type errata"
-	depends on ERRATA_THEAD && 64BIT
+	depends on ERRATA_THEAD && 64BIT && MMU
 	select RISCV_ALTERNATIVE_EARLY
 	default y
 	help
-- 
2.35.1



