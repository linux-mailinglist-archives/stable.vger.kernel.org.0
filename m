Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51BB466CA1F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbjAPQ7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233940AbjAPQ6v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:58:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E94C636FC7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:41:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E59B5B8108F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B12C433EF;
        Mon, 16 Jan 2023 16:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887313;
        bh=MjM81aUBAFOwzo3m9Wb7B2rUEGryCV94JBI1CmLi4oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MiFEiQ2iqN5kjHzww2aivgE+UsQ1CSnpBifjbI8EMAdPxF5Yqsp5BPHJB3ij+QbDo
         4YDw4CpkLVnw19LYRkDAfvgaDpa815zC/EAw2iWsW0ttdfTRdcp4tpnPklf/UTKueU
         qseXhlGL1kKw+kw8RjXpDrl8hKtcc1OtgBasT2Hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anastasia Belova <abelova@astralinux.ru>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 073/521] MIPS: BCM63xx: Add check for NULL for clk in clk_enable
Date:   Mon, 16 Jan 2023 16:45:35 +0100
Message-Id: <20230116154850.496231908@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Anastasia Belova <abelova@astralinux.ru>

[ Upstream commit ee9ef11bd2a59c2fefaa0959e5efcdf040d7c654 ]

Check clk for NULL before calling clk_enable_unlocked where clk
is dereferenced. There is such check in other implementations
of clk_enable.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: e7300d04bd08 ("MIPS: BCM63xx: Add support for the Broadcom BCM63xx family of SOCs.")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/bcm63xx/clk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/mips/bcm63xx/clk.c b/arch/mips/bcm63xx/clk.c
index dcfa0ea912fe..f183c45503ce 100644
--- a/arch/mips/bcm63xx/clk.c
+++ b/arch/mips/bcm63xx/clk.c
@@ -361,6 +361,8 @@ static struct clk clk_periph = {
  */
 int clk_enable(struct clk *clk)
 {
+	if (!clk)
+		return 0;
 	mutex_lock(&clocks_mutex);
 	clk_enable_unlocked(clk);
 	mutex_unlock(&clocks_mutex);
-- 
2.35.1



