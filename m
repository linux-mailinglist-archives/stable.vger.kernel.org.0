Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38944FD911
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351953AbiDLIAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358334AbiDLHlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:41:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D64B13F8A;
        Tue, 12 Apr 2022 00:17:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AA91B81B66;
        Tue, 12 Apr 2022 07:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DD3C385A1;
        Tue, 12 Apr 2022 07:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747866;
        bh=9iTxZGbtSi2vsNDuzzMAyGdD7jEVaEg0CO34a/UwlTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNAqO/JU8rbb0dR4Umu2qMBk9YMIZpQ9NOi3oJfz4rf61+4nckbn7aDR1gfva3/dd
         UxdfBeHALILoANzYNDNZYk1BQ+8SWQ2SLVSpia1eLDBuZ7hxFiQNZ33vn49NdM1JiZ
         Q4nzLwFoFoFDGhbdSsSjS+M0hVDfDzwfbRlzF030=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 232/343] dpaa2-ptp: Fix refcount leak in dpaa2_ptp_probe
Date:   Tue, 12 Apr 2022 08:30:50 +0200
Message-Id: <20220412062958.033253963@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

[ Upstream commit 2b04bd4f03bba021959ca339314f6739710f0954 ]

This node pointer is returned by of_find_compatible_node() with
refcount incremented. Calling of_node_put() to aovid the refcount leak.

Fixes: d346c9e86d86 ("dpaa2-ptp: reuse ptp_qoriq driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220404125336.13427-1-linmq006@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
index 5f5f8c53c4a0..c8cb541572ff 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
@@ -167,7 +167,7 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 	base = of_iomap(node, 0);
 	if (!base) {
 		err = -ENOMEM;
-		goto err_close;
+		goto err_put;
 	}
 
 	err = fsl_mc_allocate_irqs(mc_dev);
@@ -210,6 +210,8 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 	fsl_mc_free_irqs(mc_dev);
 err_unmap:
 	iounmap(base);
+err_put:
+	of_node_put(node);
 err_close:
 	dprtc_close(mc_dev->mc_io, 0, mc_dev->mc_handle);
 err_free_mcp:
-- 
2.35.1



