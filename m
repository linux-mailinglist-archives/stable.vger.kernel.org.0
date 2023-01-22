Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5D6676F7D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjAVPWV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbjAVPWU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:22:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED13222DEF
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:22:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A96B9B80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128B6C433D2;
        Sun, 22 Jan 2023 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400920;
        bh=XeeT7DKUxI/5tvd117BzTyiPFaMY0St/VNU0XigYg4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SV4xwHbxXfxv4ABLNTiBIwneYTWqDIFVeC/HA1oze0+hmpCj0JqBbrspWu3UFMDCz
         0FoFT85cI9YpzuXOlBiQcLP1pUVH6JKEDh9Ge770ipKfL8Fa0Qp5tIIqlpQXE6yCpE
         hUx5np43Pv6GhqDiJi0F3TTk/WVvE1exJdhV3M1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yinyu Cai <caiyinyu@loongson.cn>,
        Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 042/193] LoongArch: Add HWCAP_LOONGARCH_CPUCFG to elf_hwcap
Date:   Sun, 22 Jan 2023 16:02:51 +0100
Message-Id: <20230122150248.317978996@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhuacai@loongson.cn>

commit d52fec86a465355b379e839fa372ead0334d62e6 upstream.

HWCAP_LOONGARCH_CPUCFG is missing in elf_hwcap, so add it for glibc's
later use.

Cc: stable@vger.kernel.org
Reported-by: Yinyu Cai <caiyinyu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/cpu-probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -94,7 +94,7 @@ static void cpu_probe_common(struct cpui
 	c->options = LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_CSR |
 		     LOONGARCH_CPU_TLB | LOONGARCH_CPU_VINT | LOONGARCH_CPU_WATCH;
 
-	elf_hwcap |= HWCAP_LOONGARCH_CRC32;
+	elf_hwcap = HWCAP_LOONGARCH_CPUCFG | HWCAP_LOONGARCH_CRC32;
 
 	config = read_cpucfg(LOONGARCH_CPUCFG1);
 	if (config & CPUCFG1_UAL) {


