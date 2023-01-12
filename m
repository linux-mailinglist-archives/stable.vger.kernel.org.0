Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA96667411
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjALOCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjALOCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:02:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0698F25D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:02:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96F196202D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE89C433F1;
        Thu, 12 Jan 2023 14:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532132;
        bh=vdVfQSw18IDOpTlUFqaoZ4Uv2dQxfvs0ajNchpSelfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=16jd6iox68elHW9p7zr2dItH++Rlpni+IgrJ+3AKZCtm1AZj/E8u8UMsKKJW+FidS
         RwNBUHC1eNWnl/cCilGS0R22NDduaQSxNcYCQ+6jMRiVdGm6eU8iN1Wrh8Sz7CyjC0
         8+bwCUNlyn3P6M9LucaLnFWf8ZWYUgmXoaMdjOAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/783] perf/x86/intel/uncore: Fix reference count leak in hswep_has_limit_sbox()
Date:   Thu, 12 Jan 2023 14:46:18 +0100
Message-Id: <20230112135527.014691952@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 1ff9dd6e7071a561f803135c1d684b13c7a7d01d ]

pci_get_device() will increase the reference count for the returned
'dev'. We need to call pci_dev_put() to decrease the reference count.
Since 'dev' is only used in pci_read_config_dword(), let's add
pci_dev_put() right after it.

Fixes: 9d480158ee86 ("perf/x86/intel/uncore: Remove uncore extra PCI dev HSWEP_PCI_PCU_3")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20221118063137.121512-3-wangxiongfeng2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 03c8047bebb3..aa5da42ff948 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -2828,6 +2828,7 @@ static bool hswep_has_limit_sbox(unsigned int device)
 		return false;
 
 	pci_read_config_dword(dev, HSWEP_PCU_CAPID4_OFFET, &capid4);
+	pci_dev_put(dev);
 	if (!hswep_get_chop(capid4))
 		return true;
 
-- 
2.35.1



