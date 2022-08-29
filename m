Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B845A4486
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 10:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiH2IGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 04:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiH2IGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 04:06:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6658A5282D;
        Mon, 29 Aug 2022 01:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6F69B80D64;
        Mon, 29 Aug 2022 08:06:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82197C433B5;
        Mon, 29 Aug 2022 08:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661760404;
        bh=EXEzU9O3c7+eI/vI4BoKI0XiPzlDZwpzrxTE7ddbiQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CzNspwFPE/7c/OBlx2eljllkVfd5/QXZkYTL6C9GTwgUuMYMv8uDxsoGX0y0Fbfa2
         lRHS1S8npu0BeAp7whjx8qyIRnwU/AN6bPC1leBrtVsB1ddYlgqgnzY29HZvzCU2Pq
         TMb2yax8WZVKvTfuUIM5LsQkP9NuJ7GSukMjbkwrF3v/thxKEf2KFLYtiiLTy4QX4X
         DfW9WuYeuKJ4fAkPk9qz1DkEyccme7x7vS24P4ujNJ5QtCdZa1sgYgcNXHsjNwzTZo
         QzXW3kFeADFdceIO0L/gMjGxbVFeGby6huffKmlygICKA/wefC7pJLNDjs+4S7SEM1
         FOo1gMkCK83Eg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1oSZnI-0007jU-19; Mon, 29 Aug 2022 10:06:52 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Amol Maheshwari <amahesh@qti.qualcomm.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <andersson@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/3] misc: fastrpc: fix memory corruption on probe
Date:   Mon, 29 Aug 2022 10:05:29 +0200
Message-Id: <20220829080531.29681-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220829080531.29681-1-johan+linaro@kernel.org>
References: <20220829080531.29681-1-johan+linaro@kernel.org>
MIME-Version: 1.0
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

Add the missing sanity check on the probed-session count to avoid
corrupting memory beyond the fixed-size slab-allocated session array
when there are more than FASTRPC_MAX_SESSIONS sessions defined in the
devicetree.

Fixes: f6f9279f2bf0 ("misc: fastrpc: Add Qualcomm fastrpc basic driver model")
Cc: stable@vger.kernel.org      # 5.1
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/misc/fastrpc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index 93ebd174d848..88091778c1b8 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1943,6 +1943,11 @@ static int fastrpc_cb_probe(struct platform_device *pdev)
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
-- 
2.35.1

