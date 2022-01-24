Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6945E498AFA
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245513AbiAXTIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:08:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34852 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346466AbiAXTGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:06:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B657F60B7B;
        Mon, 24 Jan 2022 19:06:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACFFC340E5;
        Mon, 24 Jan 2022 19:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051191;
        bh=6aZxP0g4u8y40VBC+MWBOQ/7B6eeg9OTY1wH6MZHeqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xow3ulbR/E45AjR19OBCJSTYO9wZiAdv/GbSlm4keaFiuBVhVu5giYPDnRPPNdDUe
         jekIX4FJunsV0bTbzYn5B14DPUAIjDxyNODXyhrV/BqUtS2yfHuUvBedlLUNArC3Tt
         gWAtCAl+e0KR88jnFWdrkH3oOX1HU8vCHLd/Y1pI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 084/186] mips: bcm63xx: add support for clk_set_parent()
Date:   Mon, 24 Jan 2022 19:42:39 +0100
Message-Id: <20220124183939.819403611@linuxfoundation.org>
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
index d2a5054b0492b..73f2534b9676d 100644
--- a/arch/mips/bcm63xx/clk.c
+++ b/arch/mips/bcm63xx/clk.c
@@ -343,6 +343,12 @@ struct clk *clk_get_parent(struct clk *clk)
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
 	if (!clk)
-- 
2.34.1



