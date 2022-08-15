Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD0D5937C0
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240801AbiHOSbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243063AbiHOSai (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:30:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412072AE0C;
        Mon, 15 Aug 2022 11:20:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2405560693;
        Mon, 15 Aug 2022 18:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3B0C433C1;
        Mon, 15 Aug 2022 18:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587645;
        bh=UkgRBGRGiND0e5vjUxLk3kZH+BsEyc38Jo903maH+RY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1cN178jiQzkJJXwStn8VggaggE0IOSQE1nnVtRtoAVZ7+kUiYGHJJ4lWTcdCxDl5x
         R6sEFMucHGgsHw8i28l7W25Y60B2Q0jC3/P56ue32BfJEZB3F4EdJUzVaal6T3FwBw
         M5QBhgMKp7iyOSOnQL+zSiqE45fEEfR13abspHz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hacash Robot <hacashRobot@santino.com>,
        William Dean <williamsukatube@163.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 122/779] irqchip/mips-gic: Check the return value of ioremap() in gic_of_init()
Date:   Mon, 15 Aug 2022 19:56:06 +0200
Message-Id: <20220815180342.526837221@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Dean <williamsukatube@163.com>

[ Upstream commit 71349cc85e5930dce78ed87084dee098eba24b59 ]

The function ioremap() in gic_of_init() can fail, so
its return value should be checked.

Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@163.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220723100128.2964304-1-williamsukatube@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mips-gic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/irqchip/irq-mips-gic.c b/drivers/irqchip/irq-mips-gic.c
index f03f47ffea1e..d815285f1efe 100644
--- a/drivers/irqchip/irq-mips-gic.c
+++ b/drivers/irqchip/irq-mips-gic.c
@@ -767,6 +767,10 @@ static int __init gic_of_init(struct device_node *node,
 	}
 
 	mips_gic_base = ioremap(gic_base, gic_len);
+	if (!mips_gic_base) {
+		pr_err("Failed to ioremap gic_base\n");
+		return -ENOMEM;
+	}
 
 	gicconfig = read_gic_config();
 	gic_shared_intrs = gicconfig & GIC_CONFIG_NUMINTERRUPTS;
-- 
2.35.1



