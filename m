Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150884F37CA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359533AbiDELTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349211AbiDEJt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1C122B1F;
        Tue,  5 Apr 2022 02:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EE952CE1C6F;
        Tue,  5 Apr 2022 09:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11453C385A2;
        Tue,  5 Apr 2022 09:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151766;
        bh=OtMJiNTcTHUQcPH4dSGJwZZlh+3lpDszUo2IbFnk9JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kUZqkYbugCwFPooCbkRwFGPm/qokvEgn2EGt4EPk6tRa8PJ7rkzJter5iIns9Rsdi
         FZhYNfyXYTVW28nd4075CY0mMw21UJZmSmoD2xiX5HyN2J2w7PWvc8vYCDvkAlYqQ3
         tNH/Q9Wj+7/hzfYL1ZBmvLw4duQV25Ou+C1nz8cU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Serge Semin <fancer.lancer@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 532/913] mips: cdmm: Fix refcount leak in mips_cdmm_phys_base
Date:   Tue,  5 Apr 2022 09:26:34 +0200
Message-Id: <20220405070355.796436628@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit 4528668ca331f7ce5999b7746657b46db5b3b785 ]

The of_find_compatible_node() function returns a node pointer with
refcount incremented, We should use of_node_put() on it when done
Add the missing of_node_put() to release the refcount.

Fixes: 2121aa3e2312 ("mips: cdmm: Add mti,mips-cdmm dtb node support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Acked-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mips_cdmm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bus/mips_cdmm.c b/drivers/bus/mips_cdmm.c
index 626dedd110cb..fca0d0669aa9 100644
--- a/drivers/bus/mips_cdmm.c
+++ b/drivers/bus/mips_cdmm.c
@@ -351,6 +351,7 @@ phys_addr_t __weak mips_cdmm_phys_base(void)
 	np = of_find_compatible_node(NULL, NULL, "mti,mips-cdmm");
 	if (np) {
 		err = of_address_to_resource(np, 0, &res);
+		of_node_put(np);
 		if (!err)
 			return res.start;
 	}
-- 
2.34.1



