Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0C1593597
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241645AbiHOS1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242579AbiHOS0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:26:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C34B72AE13;
        Mon, 15 Aug 2022 11:19:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CB56B81076;
        Mon, 15 Aug 2022 18:19:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4342C433D7;
        Mon, 15 Aug 2022 18:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587550;
        bh=Gw7ty+G5lbAAotKSMNZhOw0+vgFQSF/mhHY+Ujdz0gE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZIaHxJNcjyEgl/zV2R0cPus8+lht+3uBRV//Ng2Bck3Uq7OpdpajlBa168dmJeVT
         JjRywi1FxmM1ax8foiJIoZdnjSnvSji+OPASRTW9oqun2/6JEZd0rRiDeOmk0tFkO4
         rQyU8RMDWSC309bL/UCw6AqsXdAwBd+sqbBI7fQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Antonio Borneo <antonio.borneo@foss.st.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/779] genirq: Dont return error on missing optional irq_request_resources()
Date:   Mon, 15 Aug 2022 19:56:02 +0200
Message-Id: <20220815180342.371126246@linuxfoundation.org>
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



