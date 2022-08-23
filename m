Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8880859DEFA
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244194AbiHWLRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357455AbiHWLPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:15:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2571BCC2D;
        Tue, 23 Aug 2022 02:19:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8594B61227;
        Tue, 23 Aug 2022 09:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1C9C433C1;
        Tue, 23 Aug 2022 09:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246359;
        bh=xbxje7Xy91BKf6ztvGQ+0cfijGGWz58C+kaJ3TBrwCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/YA5oN1YxyZ+c1lunS00ZVbbxTVwb2Q0v5tncnKZq5WUAESQP24iWZ67W35nPAeV
         XL4ibU5CeSYcGWhfNAMVIcXU3My5fCF1soDLhB3fLJ2Lbi4ZJWm2Duo9TtG1WBMBFa
         VqOiRSomoPSNHHOrnLFBPMWk/5BhTRbACpb9pFDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Michal Simek <michal.simek@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/389] cpufreq: zynq: Fix refcount leak in zynq_get_revision
Date:   Tue, 23 Aug 2022 10:22:42 +0200
Message-Id: <20220823080119.139222678@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit d1ff2559cef0f6f8d97fba6337b28adb10689e16 ]

of_find_compatible_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: 00f7dc636366 ("ARM: zynq: Add support for SOC_BUS")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220605082807.21526-1-linmq006@gmail.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-zynq/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
index 3a4248fd7962..25530ddae1fa 100644
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@ -77,6 +77,7 @@ static int __init zynq_get_revision(void)
 	}
 
 	zynq_devcfg_base = of_iomap(np, 0);
+	of_node_put(np);
 	if (!zynq_devcfg_base) {
 		pr_err("%s: Unable to map I/O memory\n", __func__);
 		return -1;
-- 
2.35.1



