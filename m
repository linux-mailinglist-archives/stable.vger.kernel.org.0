Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A085E9FC9
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbiIZK3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235668AbiIZK2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:28:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3864E635;
        Mon, 26 Sep 2022 03:19:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AFE560B9A;
        Mon, 26 Sep 2022 10:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B912C433D6;
        Mon, 26 Sep 2022 10:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187543;
        bh=YPPEjoCPjC9HlGhDQWssN0d3LCxUhreMTxZRurIUMl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u+zuHRepmM/TGfyPZr6WRE5mVod6qUeb6Ndk7Vx4x6cN0aaLSI/e1ao6h96heJG36
         LesoH+9WRukqhz/Tw+DibMDh9BjMRW4u+gi5xv/38bYL0mBUfbjHKohRqhMddjHRav
         hCve4iYBHB0zWW42HiDztfWLNmvoy6V2FoG9SHo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        John Crispin <john@phrozen.org>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 41/58] MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko
Date:   Mon, 26 Sep 2022 12:12:00 +0200
Message-Id: <20220926100742.963610389@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 502550123bee6a2ffa438409b5b9aad4d6db3a8c ]

The lantiq WDT driver uses clk_get_io(), which is not exported,
so export it to fix a build error:

ERROR: modpost: "clk_get_io" [drivers/watchdog/lantiq_wdt.ko] undefined!

Fixes: 287e3f3f4e68 ("MIPS: lantiq: implement support for clkdev api")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: John Crispin <john@phrozen.org>
Cc: linux-mips@vger.kernel.org
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/clk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/lantiq/clk.c b/arch/mips/lantiq/clk.c
index f5fab99d1751..851f6bf925a6 100644
--- a/arch/mips/lantiq/clk.c
+++ b/arch/mips/lantiq/clk.c
@@ -52,6 +52,7 @@ struct clk *clk_get_io(void)
 {
 	return &cpu_clk_generic[2];
 }
+EXPORT_SYMBOL_GPL(clk_get_io);
 
 struct clk *clk_get_ppe(void)
 {
-- 
2.35.1



