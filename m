Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF9E5949BD
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbiHOXHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353070AbiHOXHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:07:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BA286730;
        Mon, 15 Aug 2022 12:59:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 090C8CE12C1;
        Mon, 15 Aug 2022 19:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EECBC433D6;
        Mon, 15 Aug 2022 19:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593547;
        bh=N9TJ94ZoPUoNsloQHfrpn0GyEU2bxkyC7I82FkaGEUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Age8BI9rsFZdRfFRoWWw+w7x1X2FV9anAzkbtiD2wcU7b39F49XTbhBRIL/iwEttg
         l7Czhx70Em5FADiPzIo2oEhgB8BesuIuiM2oMEWQlFVt/6NAbCoWg625bkWApVkdsB
         doeFA9VB/Rl+TyjfuBReQlWujiO2J8DiTtL3WTeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Qiang <xuqiang36@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0286/1157] irqdomain: Report irq number for NOMAP domains
Date:   Mon, 15 Aug 2022 19:54:02 +0200
Message-Id: <20220815180451.059458446@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index d5ce96510549..481abb885d61 100644
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



