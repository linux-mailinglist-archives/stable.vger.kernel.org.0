Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA49054183D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379209AbiFGVLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379682AbiFGVKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:10:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F47721565D;
        Tue,  7 Jun 2022 11:51:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4888617A4;
        Tue,  7 Jun 2022 18:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F74C341C7;
        Tue,  7 Jun 2022 18:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627915;
        bh=31HpYQaWeWqtZN+AGWXO2osKlfGZ7/fW6vbdG5g5fus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koQnRJnnVWWo5kDwuDW4MZxhZl4XbuCBe0t7hyQC5PUhRhXmyQlVZt2b+hnOKJ139
         TpWKa4T1nullHKoMKS2XK/3e6nrP8mikClaqf/4CI55K5+Xx9vjDC+rpgwWWulvvmK
         NFBff4JPPO1D5efzdRW5V0uZ2NytP7ZrcFgjVmNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhen Lei <thunder.leizhen@huawei.com>,
        Rob Herring <robh@kernel.org>, Baoquan He <bhe@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 138/879] of: Support more than one crash kernel regions for kexec -s
Date:   Tue,  7 Jun 2022 18:54:16 +0200
Message-Id: <20220607165006.711247089@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



