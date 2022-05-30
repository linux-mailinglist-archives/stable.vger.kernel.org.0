Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CED537EFC
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238022AbiE3Nv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238964AbiE3Nu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:50:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C268723F;
        Mon, 30 May 2022 06:35:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADECA60F24;
        Mon, 30 May 2022 13:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF979C3411C;
        Mon, 30 May 2022 13:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917712;
        bh=31HpYQaWeWqtZN+AGWXO2osKlfGZ7/fW6vbdG5g5fus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1i8jIaXVDvDd5HxkphIjq6d3sQ4eOEJLDlRrRx+BlJpXMAXTlxCsTDBErrTiyVgQ
         2OCp3xpRJegFeYyRxxWaTeGjrlnhfZ+OCdAu08mNFAoIHWyyvFm/pdHPBpdIZKNbOc
         8E4EwlEKujUS6Fktlv7tW1DQ+HMfIZPruMA4TR9VWhms1bKXoWrnmsWh/GlFcQlK3x
         Czol/M3xKvdK2RCxPoQNlxPaXfM8iXotERi7kJXUulZCVA3epe+8dON7XPclCwVdC/
         0UApR6JE2mrnLwjfU2h6+8/GTzaZ6ukFFcaLHXSEPxx75SSUXBRTMHSWz830OAeR6z
         toGI1nDu7Y5tQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Rob Herring <robh@kernel.org>, Baoquan He <bhe@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        frowand.list@gmail.com, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 073/135] of: Support more than one crash kernel regions for kexec -s
Date:   Mon, 30 May 2022 09:30:31 -0400
Message-Id: <20220530133133.1931716-73-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
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

