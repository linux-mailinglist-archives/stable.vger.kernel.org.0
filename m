Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095AF6B40B4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbjCJNpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbjCJNpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:45:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4D59545C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:45:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEB59617AF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BA1C4339B;
        Fri, 10 Mar 2023 13:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678455906;
        bh=66dWPDY6YQiRJZ/wdMnTaRXpUh5VpRssfKqmzur64bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6bvX1Q/WN7mYefCbHnyYVkVqJdJ1k5n3Gms/nmXqVe8OI1a57vi3O6JhGbXL976T
         AAa7CeOaQBuLPKCNRmbRSLgpYXLcirqogay15FWqaexPWlvWGIuxyShUbcUMMTYCS7
         TsI7TYF8ADewj9Irwj/fjJpKct967jUGEhUMSMhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qiheng Lin <linqiheng@huawei.com>,
        Michal Simek <michal.simek@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 016/193] ARM: zynq: Fix refcount leak in zynq_early_slcr_init
Date:   Fri, 10 Mar 2023 14:36:38 +0100
Message-Id: <20230310133711.471146109@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiheng Lin <linqiheng@huawei.com>

[ Upstream commit 9eedb910a3be0005b88c696a8552c0d4c9937cd4 ]

of_find_compatible_node() returns a node pointer with refcount incremented,
we should use of_node_put() on error path.
Add missing of_node_put() to avoid refcount leak.

Fixes: 3329659df030 ("ARM: zynq: Simplify SLCR initialization")
Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
Link: https://lore.kernel.org/r/20221129140544.41293-1-linqiheng@huawei.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-zynq/slcr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index f0292a30e6f69..6b75ef7be3fda 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -222,6 +222,7 @@ int __init zynq_early_slcr_init(void)
 	zynq_slcr_regmap = syscon_regmap_lookup_by_compatible("xlnx,zynq-slcr");
 	if (IS_ERR(zynq_slcr_regmap)) {
 		pr_err("%s: failed to find zynq-slcr\n", __func__);
+		of_node_put(np);
 		return -ENODEV;
 	}
 
-- 
2.39.2



