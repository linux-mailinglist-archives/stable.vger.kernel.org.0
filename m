Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC5158C001
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242763AbiHHBrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243244AbiHHBqb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:46:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0662015701;
        Sun,  7 Aug 2022 18:36:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 778E560DF5;
        Mon,  8 Aug 2022 01:36:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3436AC4314A;
        Mon,  8 Aug 2022 01:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922598;
        bh=Gw7ty+G5lbAAotKSMNZhOw0+vgFQSF/mhHY+Ujdz0gE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ttw/FLAn1wyiM4lSKXtd9LnTjWpwT4kCrR4cTvHcQKa6zulm5HiOiDPVVsypSzhjE
         CpAiDxkjDwGw/uqv5D/VKKVtBlhBsnA4o52DWYxL93TyZ0NEII8dXYc+gXU5DZsM4N
         sHzHbGKhOt3htL6/zGuAAuzKUy1py4pbrEEw4Nx5WHj9v4kih34aL3esM6+u/yGMly
         PbL4j/yMF7tnuWvhnbpo+Ac5GdCx+VJkGo57SSUg5mN8hMMsw9ShrbbHfo0d/rrtue
         Xw2mkFmPqoZINvW1iud5w4ZFm0YrrHY1UTntLLaEZi2n1n2ZDXAmIuJe0eaUkl/p3F
         td4MO1/Q9kZPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Antonio Borneo <antonio.borneo@foss.st.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        tglx@linutronix.de
Subject: [PATCH AUTOSEL 5.15 12/45] genirq: Don't return error on missing optional irq_request_resources()
Date:   Sun,  7 Aug 2022 21:35:16 -0400
Message-Id: <20220808013551.315446-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013551.315446-1-sashal@kernel.org>
References: <20220808013551.315446-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Antonio Borneo <antonio.borneo@foss.st.com>

[ Upstream commit 95001b756467ecc9f5973eb5e74e97699d9bbdf1 ]

Function irq_chip::irq_request_resources() is reported as optional
in the declaration of struct irq_chip.
If the parent irq_chip does not implement it, we should ignore it
and return.

Don't return error if the functions is missing.

Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220512160544.13561-1-antonio.borneo@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/chip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index a98bcfc4be7b..f3920374f71c 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -1516,7 +1516,8 @@ int irq_chip_request_resources_parent(struct irq_data *data)
 	if (data->chip->irq_request_resources)
 		return data->chip->irq_request_resources(data);
 
-	return -ENOSYS;
+	/* no error on missing optional irq_chip::irq_request_resources */
+	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_chip_request_resources_parent);
 
-- 
2.35.1

