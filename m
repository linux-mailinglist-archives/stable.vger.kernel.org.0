Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BB955C89D
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238725AbiF0Lxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238853AbiF0Lwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AA6BC0F;
        Mon, 27 Jun 2022 04:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EDD29CE171B;
        Mon, 27 Jun 2022 11:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1192DC36AED;
        Mon, 27 Jun 2022 11:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330358;
        bh=nNhet8or/hoY+pxRtadru407botWQgZVpH0oUBA5Dhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0rbIIPoelFS5iEJ66OCs/BvGd3nRDxFke8xgRTRC/lIji0hLKDkEBkfLd5W/GOTy
         0WyGM+xUyQYFGmG0qm59DhWNqbP/yPeMzs5etESg+DuAPJtcC4ZJv1Na+fbYwjqCwS
         K8kJmywigJ8oPleP0zzCbcXhjzXZQCd/1Ly5/zKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.18 170/181] memory: mtk-smi: add missing put_device() call in mtk_smi_device_link_common
Date:   Mon, 27 Jun 2022 13:22:23 +0200
Message-Id: <20220627111949.615555228@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit 038ae37c510fd57cbc543ac82db1e7b23b28557a upstream.

The reference taken by 'of_find_device_by_node()' must be released when
not needed anymore.
Add the corresponding 'put_device()' in the error handling paths.

Fixes: 47404757702e ("memory: mtk-smi: Add device link for smi-sub-common")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220601120118.60225-1-linmq006@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/mtk-smi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/memory/mtk-smi.c b/drivers/memory/mtk-smi.c
index 86a3d34f418e..4c5154e0bf00 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -404,13 +404,16 @@ static int mtk_smi_device_link_common(struct device *dev, struct device **com_de
 	of_node_put(smi_com_node);
 	if (smi_com_pdev) {
 		/* smi common is the supplier, Make sure it is ready before */
-		if (!platform_get_drvdata(smi_com_pdev))
+		if (!platform_get_drvdata(smi_com_pdev)) {
+			put_device(&smi_com_pdev->dev);
 			return -EPROBE_DEFER;
+		}
 		smi_com_dev = &smi_com_pdev->dev;
 		link = device_link_add(dev, smi_com_dev,
 				       DL_FLAG_PM_RUNTIME | DL_FLAG_STATELESS);
 		if (!link) {
 			dev_err(dev, "Unable to link smi-common dev\n");
+			put_device(&smi_com_pdev->dev);
 			return -ENODEV;
 		}
 		*com_dev = smi_com_dev;
-- 
2.36.1



