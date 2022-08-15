Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352EB5936A7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243554AbiHOSoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242868AbiHOSnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:43:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A21C2A7;
        Mon, 15 Aug 2022 11:26:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC47760FC4;
        Mon, 15 Aug 2022 18:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41C1C433C1;
        Mon, 15 Aug 2022 18:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587996;
        bh=2U69VoSm4UpXK3h1vY5AEo5exNg8mkLjEbQ48eUiu1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pa53CDpHF4y0KZvcvBKS+S8q1HS4WJwn2MQkXTqhImIiNsP8q4L2Y2IGgzUJbI7/T
         d8snWy6KL2TV6WamgXq100KhCw4aAU6pVxwu/UN41h6LaBCwoE/zrVkBYroaHpHvuy
         sBhjgbepsB66PcuqEcU7XEBvvCICcpgtfX9OGS24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Qiang <xuqiang36@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 221/779] irqdomain: Report irq number for NOMAP domains
Date:   Mon, 15 Aug 2022 19:57:45 +0200
Message-Id: <20220815180346.730050414@linuxfoundation.org>
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

From: Xu Qiang <xuqiang36@huawei.com>

[ Upstream commit 6f194c99f466147148cc08452718b46664112548 ]

When using a NOMAP domain, __irq_resolve_mapping() doesn't store
the Linux IRQ number at the address optionally provided by the caller.
While this isn't a huge deal (the returned value is guaranteed
to the hwirq that was passed as a parameter), let's honour the letter
of the API by writing the expected value.

Fixes: d22558dd0a6c (“irqdomain: Introduce irq_resolve_mapping()”)
Signed-off-by: Xu Qiang <xuqiang36@huawei.com>
[maz: commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220719063641.56541-2-xuqiang36@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 4d8fc65cf38f..035e3038c4de 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -910,6 +910,8 @@ struct irq_desc *__irq_resolve_mapping(struct irq_domain *domain,
 			data = irq_domain_get_irq_data(domain, hwirq);
 			if (data && data->hwirq == hwirq)
 				desc = irq_data_to_desc(data);
+			if (irq && desc)
+				*irq = hwirq;
 		}
 
 		return desc;
-- 
2.35.1



