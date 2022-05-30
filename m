Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35878537D1C
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbiE3Nhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237669AbiE3Nfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:35:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498E194196;
        Mon, 30 May 2022 06:28:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6E9FB80DBA;
        Mon, 30 May 2022 13:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C26C3411A;
        Mon, 30 May 2022 13:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917296;
        bh=31HpYQaWeWqtZN+AGWXO2osKlfGZ7/fW6vbdG5g5fus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBGvoK2vRXbBGgAEFEmsfiJzzRmGoPiW4R76IQrIikTH7QTUpWBcr2n+nuTw3KLAE
         lq2B+1+Ult5g9cqoB1uwO49CQX2jMSVmXhq1vpasgOmVkuXLQhdvhuWBsG0v+O6oGm
         blsN6wUGEsyQnKsPQq043tZC+NkJ8Gn0tSSP4q8MzdBBXOvO2uB+yZBdM37gwTQXNz
         OOSNAPPqbKungFxPq7XFatTadJ7oiAFr4m+kfOFBJ5KpRuGaSW1MQcyN/cg2LM0KDW
         1kVC+uPRzDN8fuMw585LMWi/JsTX9Y2B8EQ3j5mhBembG3GuSDsYeTLEOHJrazXaih
         1Gq+hdddgLHjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Rob Herring <robh@kernel.org>, Baoquan He <bhe@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        frowand.list@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 088/159] of: Support more than one crash kernel regions for kexec -s
Date:   Mon, 30 May 2022 09:23:13 -0400
Message-Id: <20220530132425.1929512-88-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 8af6b91f58341325bf74ecb0389ddc0039091d84 ]

When "crashkernel=X,high" is used, there may be two crash regions:
high=crashk_res and low=crashk_low_res. But now the syscall
kexec_file_load() only add crashk_res into "linux,usable-memory-range",
this may cause the second kernel to have no available dma memory.

Fix it like kexec-tools does for option -c, add both 'high' and 'low'
regions into the dtb.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Baoquan He <bhe@redhat.com>
Link: https://lore.kernel.org/r/20220506114402.365-6-thunder.leizhen@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/kexec.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
index b9bd1cff1793..8d374cc552be 100644
--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -386,6 +386,15 @@ void *of_kexec_alloc_and_setup_fdt(const struct kimage *image,
 				crashk_res.end - crashk_res.start + 1);
 		if (ret)
 			goto out;
+
+		if (crashk_low_res.end) {
+			ret = fdt_appendprop_addrrange(fdt, 0, chosen_node,
+					"linux,usable-memory-range",
+					crashk_low_res.start,
+					crashk_low_res.end - crashk_low_res.start + 1);
+			if (ret)
+				goto out;
+		}
 	}
 
 	/* add bootargs */
-- 
2.35.1

