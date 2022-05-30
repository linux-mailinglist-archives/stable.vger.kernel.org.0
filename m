Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D87E1537F51
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbiE3OJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239893AbiE3OGY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:06:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274532FFFD;
        Mon, 30 May 2022 06:41:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1853D60FA3;
        Mon, 30 May 2022 13:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C76EC3411E;
        Mon, 30 May 2022 13:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918102;
        bh=K2Ct8v612oBd7AGh9aMx4iuQ2nz0lA2eVt8p+V/mDAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDdjHn6PcRun6xfMWZudlq8w8WhkRT+7UF1cKGZ2Hdo1n+csDznfJ0SYSeahXWKqC
         Ndb8xe4AwODrsDCVcr6KBd9OhUrgE8oV0uEZIAiR4Q0HjEBF0XvoepMxt9Y+XpL35Q
         5Xd7Umbpl9hwIdTnvkGE5/3WuNffrKh91QTlbBSeuY9dYlD387/8YGlH0K0WICOFWR
         /RGw7azO2HNBt1o7A4TtWVL3ehmEtrk0dqxjPcaWOhgvMjWVkA7J64cDnR94NQCgxN
         sSOP800u+6SGjdZbREcBi/+mmN5sb68ASm+PVDTsAsgHZzo0KQ53bYW+NLnTsdLTa0
         z4FlDI0RgDoxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Rob Herring <robh@kernel.org>, Baoquan He <bhe@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        frowand.list@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 061/109] of: Support more than one crash kernel regions for kexec -s
Date:   Mon, 30 May 2022 09:37:37 -0400
Message-Id: <20220530133825.1933431-61-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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
index 761fd870d1db..72c790a3c910 100644
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

