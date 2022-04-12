Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3AD94FD761
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240853AbiDLHT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351682AbiDLHMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:12:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F4A15A0F;
        Mon, 11 Apr 2022 23:51:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FE706149D;
        Tue, 12 Apr 2022 06:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCA4C385A1;
        Tue, 12 Apr 2022 06:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746292;
        bh=AY9XliJqhQHz3+D1GqTzQinJSnUeCbZ2PTPqsNyVaYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agMODraYXgVdxVMQlLzmVSblZ2vTmVrujzgM6RsYuHC8ZacFVE04W0AGW5K3iO07E
         +RfezlH7sZFIwCXRsS3QSLP9RTvLiB2YDe4E60JqdouLgXBOS7BN4sPb3dBOwX1SJP
         vF765D+XKff288Wnk/KrUykPTPmtRjI7mXSY+M/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/277] dpaa2-ptp: Fix refcount leak in dpaa2_ptp_probe
Date:   Tue, 12 Apr 2022 08:29:43 +0200
Message-Id: <20220412062947.245289421@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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
index 32b5faa87bb8..208a3459f2e2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
@@ -168,7 +168,7 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 	base = of_iomap(node, 0);
 	if (!base) {
 		err = -ENOMEM;
-		goto err_close;
+		goto err_put;
 	}
 
 	err = fsl_mc_allocate_irqs(mc_dev);
@@ -212,6 +212,8 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
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



