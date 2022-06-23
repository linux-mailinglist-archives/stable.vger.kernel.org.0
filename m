Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF27855822B
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbiFWRLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiFWRJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:09:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF76B4B85F;
        Thu, 23 Jun 2022 09:57:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 11200B82493;
        Thu, 23 Jun 2022 16:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64144C3411B;
        Thu, 23 Jun 2022 16:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003445;
        bh=S2mte76aH7kqcqbNPMSUvjm5m4VlBrxixRxn7+AsZ5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQPV+x1wVm8pLNphU5Rx61vBQp4jy47qHMQolkRMRdkU17Vtt3yB+AogXQdp1257r
         OoKx6eFdVDUiM/b7pIcO24BmUNgzndJm9N+QgaWpoALBsEmG5K2B3UEjgzLDN6aN2W
         X8vJLHNHmUG7nkYVK5C86saCmBbceuX9fdJnjk1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zijun_hu <zijun_hu@htc.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 241/264] irqchip/gic-v3: Iterate over possible CPUs by for_each_possible_cpu()
Date:   Thu, 23 Jun 2022 18:43:54 +0200
Message-Id: <20220623164350.893321580@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zijun_hu <zijun_hu@htc.com>

[ Upstream commit 3fad4cdac235c5b13227d0c09854c689ae62c70b ]

get_cpu_number() doesn't use existing helper to iterate over possible
CPUs, It will cause an error in case of discontinuous @cpu_possible_mask
such as 0b11110001, which can result from a core having failed to come
up on a SMP machine.

Fixed by using existing helper for_each_possible_cpu().

Signed-off-by: zijun_hu <zijun_hu@htc.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 2ab6060031a4..9ae24ffb9b09 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -982,7 +982,7 @@ static int get_cpu_number(struct device_node *dn)
 {
 	const __be32 *cell;
 	u64 hwid;
-	int i;
+	int cpu;
 
 	cell = of_get_property(dn, "reg", NULL);
 	if (!cell)
@@ -996,9 +996,9 @@ static int get_cpu_number(struct device_node *dn)
 	if (hwid & ~MPIDR_HWID_BITMASK)
 		return -1;
 
-	for (i = 0; i < num_possible_cpus(); i++)
-		if (cpu_logical_map(i) == hwid)
-			return i;
+	for_each_possible_cpu(cpu)
+		if (cpu_logical_map(cpu) == hwid)
+			return cpu;
 
 	return -1;
 }
-- 
2.35.1



