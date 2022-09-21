Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2596B5C02EC
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232072AbiIUP5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbiIUP4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:56:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920DF9E2C9;
        Wed, 21 Sep 2022 08:50:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FD66B8236C;
        Wed, 21 Sep 2022 15:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C81EC433C1;
        Wed, 21 Sep 2022 15:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775452;
        bh=tPurWEEhB1tjacmXIiMYZ8dsf94axedVu01GjbMSARc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKhMtomc9VDu15Y5JSVZlq50opUXW4Jj+UgjjbmSsRnO+6tr1rt6WlDwTibOUWDva
         KgHwCavKLpwS+2de/Yq9FQ6XcnlQsbaZ9E4424o3Gmwhvv0OOSdJL4OEDYh7lRYY5u
         O2564dvEIyQEUyaa9Z87XzJiEkWeFXBEEG5QCNoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergey Shtylyov <s.shtylyov@omp.ru>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/39] of: fdt: fix off-by-one error in unflatten_dt_nodes()
Date:   Wed, 21 Sep 2022 17:46:17 +0200
Message-Id: <20220921153646.153746553@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
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

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 2f945a792f67815abca26fa8a5e863ccf3fa1181 ]

Commit 78c44d910d3e ("drivers/of: Fix depth when unflattening devicetree")
forgot to fix up the depth check in the loop body in unflatten_dt_nodes()
which makes it possible to overflow the nps[] buffer...

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Fixes: 78c44d910d3e ("drivers/of: Fix depth when unflattening devicetree")
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/7c354554-006f-6b31-c195-cdfe4caee392@omp.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 57ff31b6b1e4..5a1b8688b460 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -315,7 +315,7 @@ static int unflatten_dt_nodes(const void *blob,
 	for (offset = 0;
 	     offset >= 0 && depth >= initial_depth;
 	     offset = fdt_next_node(blob, offset, &depth)) {
-		if (WARN_ON_ONCE(depth >= FDT_MAX_DEPTH))
+		if (WARN_ON_ONCE(depth >= FDT_MAX_DEPTH - 1))
 			continue;
 
 		if (!IS_ENABLED(CONFIG_OF_KOBJ) &&
-- 
2.35.1



