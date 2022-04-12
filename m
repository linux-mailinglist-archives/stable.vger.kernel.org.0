Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A87484FD0ED
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350771AbiDLG4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351415AbiDLGxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:53:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9E03BFAB;
        Mon, 11 Apr 2022 23:40:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2113B81B44;
        Tue, 12 Apr 2022 06:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39892C385A6;
        Tue, 12 Apr 2022 06:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745630;
        bh=AY9XliJqhQHz3+D1GqTzQinJSnUeCbZ2PTPqsNyVaYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAfFSRviKqs4G5OOZYr3h6z/U1VjfmccWnq5MR9BRKeEq18fijW38Gz9iweRz5if9
         0DS4FtMJFRjUkyHEGbrBextk3yxZVvVLyqjWzth3+nqfzebFUiMnnXUFOBOmpz2VhU
         NaJSRqSL3AFmo8Sx6SVaQjXsU+koZmpFCOL2Xrvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/171] dpaa2-ptp: Fix refcount leak in dpaa2_ptp_probe
Date:   Tue, 12 Apr 2022 08:30:04 +0200
Message-Id: <20220412062931.154811738@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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



