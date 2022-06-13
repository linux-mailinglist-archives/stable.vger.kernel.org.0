Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6D05490CB
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357117AbiFMMAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358390AbiFML75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:59:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FFC4EF4C;
        Mon, 13 Jun 2022 03:56:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B1DC61346;
        Mon, 13 Jun 2022 10:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DE3C3411E;
        Mon, 13 Jun 2022 10:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117816;
        bh=yezBWBIj2lDVCShdvT7sJfdI2ltpm1U6UJxUTLHm4jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ewijdeDFviF/w6h8U3pX5w0pLq8xwtaBKESEKdMhh+YVN7vjc33qLy4BJ1YkNWUzh
         slpeFqxF4mhPHW94GESp2JsIXDkDdVcku32cuz38nzrgpX2qirmzCUsay9WFXvLrLn
         0g5TeGtJHugBNtuSiW5GGXnXiKTtNSeg/Yt0/SAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 129/287] powerpc/fsl_rio: Fix refcount leak in fsl_rio_setup
Date:   Mon, 13 Jun 2022 12:09:13 +0200
Message-Id: <20220613094927.791098528@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit fcee96924ba1596ca80a6770b2567ca546f9a482 ]

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: abc3aeae3aaa ("fsl-rio: Add two ports and rapidio message units support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220512123724.62931-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/fsl_rio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 5011ffea4e4b..c48ebe677962 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -509,8 +509,10 @@ int fsl_rio_setup(struct platform_device *dev)
 	if (rc) {
 		dev_err(&dev->dev, "Can't get %pOF property 'reg'\n",
 				rmu_node);
+		of_node_put(rmu_node);
 		goto err_rmu;
 	}
+	of_node_put(rmu_node);
 	rmu_regs_win = ioremap(rmu_regs.start, resource_size(&rmu_regs));
 	if (!rmu_regs_win) {
 		dev_err(&dev->dev, "Unable to map rmu register window\n");
-- 
2.35.1



