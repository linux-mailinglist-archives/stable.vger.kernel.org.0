Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DBD498950
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344310AbiAXSyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343954AbiAXSwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:52:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170C1C06177D;
        Mon, 24 Jan 2022 10:52:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABA8F614EC;
        Mon, 24 Jan 2022 18:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715D0C340E8;
        Mon, 24 Jan 2022 18:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050345;
        bh=x4SL9WF8io313e5A39RZiytXL/H7HNZcY5I6SgbcOpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LK+AkndQO4wk0E76lRCINlYVI3r72xApg4bYfV2FPKQYUefeL1KqYmVeALO/zPTh9
         720EoYCFXFterTUAXuUea4/ne7b3q+jvdscAcTnkwCUBOBD7dms3ZKRySEUhmWQgjA
         On4HeLH7lUji/djLQfnrPWN4DaBqfrqLqP76Y7S8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 055/114] mips: bcm63xx: add support for clk_set_parent()
Date:   Mon, 24 Jan 2022 19:42:30 +0100
Message-Id: <20220124183928.802970550@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
References: <20220124183927.095545464@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 6f03055d508ff4feb8db02ba3df9303a1db8d381 ]

The MIPS BMC63XX subarch does not provide/support clk_set_parent().
This causes build errors in a few drivers, so add a simple implementation
of that function so that callers of it will build without errors.

Fixes these build errors:

ERROR: modpost: "clk_set_parent" [sound/soc/jz4740/snd-soc-jz4740-i2s.ko] undefined!
ERROR: modpost: "clk_set_parent" [sound/soc/atmel/snd-soc-atmel-i2s.ko] undefined!

Fixes: e7300d04bd08 ("MIPS: BCM63xx: Add support for the Broadcom BCM63xx family of SOCs." )
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/bcm63xx/clk.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/mips/bcm63xx/clk.c b/arch/mips/bcm63xx/clk.c
index ef268c9aac80d..fe90c1c86a600 100644
--- a/arch/mips/bcm63xx/clk.c
+++ b/arch/mips/bcm63xx/clk.c
@@ -339,6 +339,12 @@ struct clk *clk_get_parent(struct clk *clk)
 }
 EXPORT_SYMBOL(clk_get_parent);
 
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	return 0;
+}
+EXPORT_SYMBOL(clk_set_parent);
+
 unsigned long clk_get_rate(struct clk *clk)
 {
 	return clk->rate;
-- 
2.34.1



