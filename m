Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C675AEAFB
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238625AbiIFNui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbiIFNsG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:48:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E577EFF4;
        Tue,  6 Sep 2022 06:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F12A0B8162F;
        Tue,  6 Sep 2022 13:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA68C433D6;
        Tue,  6 Sep 2022 13:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471479;
        bh=7Fhvm9OcobuWfFBX6jJb8EOjxbuI0u9TdnI2YzueB4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1uhMw+zmF7w9XijJbb3IlV4vFkJxsG8zwbWQd6UGZgIWBYb4brzusAwZxOrY56aD
         2g/ezj48tZrrKvU5hW/mzAdajSLQB/6rxG6fLmxIRzr0lTbSxiFACVmM6O26oODtDO
         QZ8CuLciZBxeM7L3u95kOXc5A+zl+sG36vwL0kyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH 5.15 041/107] misc: fastrpc: fix memory corruption on probe
Date:   Tue,  6 Sep 2022 15:30:22 +0200
Message-Id: <20220906132823.556976460@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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
@@ -1550,6 +1550,11 @@ static int fastrpc_cb_probe(struct platf
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


