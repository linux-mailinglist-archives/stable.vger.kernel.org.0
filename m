Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8906E5EA4A9
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238757AbiIZLtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239020AbiIZLtF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:49:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFCA57201;
        Mon, 26 Sep 2022 03:48:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1C07B80171;
        Mon, 26 Sep 2022 10:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DC2C433C1;
        Mon, 26 Sep 2022 10:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189209;
        bh=FGL8GAtxfMw4n0JvjxgP9LDX324kIAJjB3fsedpwHWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qS1xfuibYClXLDgk3xDCQSMh1DWwEvPW2KjG4z2X9RgSuQasFTaxBN+fefe0njhqn
         mXrX0p1L7t6y1O9AdzF28lo/y9spGz6ff5G2U+pxAjfj0o8TvfbsKpDnbCGD1lrJ/F
         801ehcMPKGx2Wv4ZVstyT2ffNpHimSoPylkVLQWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        John Crispin <john@phrozen.org>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 110/207] MIPS: lantiq: export clk_get_io() for lantiq_wdt.ko
Date:   Mon, 26 Sep 2022 12:11:39 +0200
Message-Id: <20220926100811.527633314@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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
index 7a623684d9b5..2d5a0bcb0cec 100644
--- a/arch/mips/lantiq/clk.c
+++ b/arch/mips/lantiq/clk.c
@@ -50,6 +50,7 @@ struct clk *clk_get_io(void)
 {
 	return &cpu_clk_generic[2];
 }
+EXPORT_SYMBOL_GPL(clk_get_io);
 
 struct clk *clk_get_ppe(void)
 {
-- 
2.35.1



