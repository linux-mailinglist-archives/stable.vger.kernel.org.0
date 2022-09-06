Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 270EE5AE9C6
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240628AbiIFNel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240652AbiIFNdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:33:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BA7792C3;
        Tue,  6 Sep 2022 06:33:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 101976154A;
        Tue,  6 Sep 2022 13:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0645FC433D6;
        Tue,  6 Sep 2022 13:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471190;
        bh=ZhllgM/u62vQ6ni2nTKw2xtAWribG4BtnEkaGvqdINw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/u4hkVMeKbeZZUQ1tfw0U8M0KZG2ujJhsdVDHO6v2hkCD6BZ47A9JJPV58yOKaS5
         n4g9jm3HM4CmJLPCNMMOEKwL5e3UkHGK11IYwPlwXlK6bckaOR8HpVOXlGjcV1dFvc
         LLI2ivMQ6F6BELlv0bG+wU1InxQatT7UlVl/J7p4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 5.10 29/80] misc: fastrpc: fix memory corruption on probe
Date:   Tue,  6 Sep 2022 15:30:26 +0200
Message-Id: <20220906132818.163361501@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 9baa1415d9abdd1e08362ea2dcfadfacee8690b5 upstream.

Add the missing sanity check on the probed-session count to avoid
corrupting memory beyond the fixed-size slab-allocated session array
when there are more than FASTRPC_MAX_SESSIONS sessions defined in the
devicetree.

Fixes: f6f9279f2bf0 ("misc: fastrpc: Add Qualcomm fastrpc basic driver model")
Cc: stable@vger.kernel.org      # 5.1
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220829080531.29681-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1548,6 +1548,11 @@ static int fastrpc_cb_probe(struct platf
 	of_property_read_u32(dev->of_node, "qcom,nsessions", &sessions);
 
 	spin_lock_irqsave(&cctx->lock, flags);
+	if (cctx->sesscount >= FASTRPC_MAX_SESSIONS) {
+		dev_err(&pdev->dev, "too many sessions\n");
+		spin_unlock_irqrestore(&cctx->lock, flags);
+		return -ENOSPC;
+	}
 	sess = &cctx->session[cctx->sesscount];
 	sess->used = false;
 	sess->valid = true;


