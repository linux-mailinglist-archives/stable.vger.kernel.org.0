Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811E1498B2F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345407AbiAXTMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:12:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36400 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345862AbiAXTG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:06:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9294860BB9;
        Mon, 24 Jan 2022 19:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A519C340E5;
        Mon, 24 Jan 2022 19:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051188;
        bh=wNJQ1Il1mgRJmfGV4m1U3Mn/8rvUO5cjMqt67o9ex3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yp0d9xtOKZ+0rcluJELQ6GBmL0se5Jr6YjZlUsDiUb+0ApGchO39KgF5EbpOwWdjH
         HkFjwUgO9v/OKIjePwAy2L1vOqwxau+M36IbRw0eEd0n5c5N8+APvxG29OfUI8Ewm4
         bosT7CPqv1kpOjKAO908QqspzWeAOawXYd0ndgzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 083/186] mips: lantiq: add support for clk_set_parent()
Date:   Mon, 24 Jan 2022 19:42:38 +0100
Message-Id: <20220124183939.789780159@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 76f66dfd60dc5d2f9dec22d99091fea1035c5d03 ]

Provide a simple implementation of clk_set_parent() in the lantiq
subarch so that callers of it will build without errors.

Fixes these build errors:

ERROR: modpost: "clk_set_parent" [sound/soc/jz4740/snd-soc-jz4740-i2s.ko] undefined!
ERROR: modpost: "clk_set_parent" [sound/soc/atmel/snd-soc-atmel-i2s.ko] undefined!

Fixes: 171bb2f19ed6 ("MIPS: Lantiq: Add initial support for Lantiq SoCs")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
--to=linux-mips@vger.kernel.org --cc="John Crispin <john@phrozen.org>" --cc="Jonathan Cameron <jic23@kernel.org>" --cc="Russell King <linux@armlinux.org.uk>" --cc="Andy Shevchenko <andy.shevchenko@gmail.com>" --cc=alsa-devel@alsa-project.org --to="Thomas Bogendoerfer <tsbogend@alpha.franken.de>"
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/lantiq/clk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/lantiq/clk.c b/arch/mips/lantiq/clk.c
index a8e309dcd38d7..f5fab99d1751c 100644
--- a/arch/mips/lantiq/clk.c
+++ b/arch/mips/lantiq/clk.c
@@ -166,6 +166,12 @@ struct clk *clk_get_parent(struct clk *clk)
 }
 EXPORT_SYMBOL(clk_get_parent);
 
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	return 0;
+}
+EXPORT_SYMBOL(clk_set_parent);
+
 static inline u32 get_counter_resolution(void)
 {
 	u32 res;
-- 
2.34.1



