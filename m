Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5AC6042D7
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiJSLLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232922AbiJSLKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:10:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D9210A7F5;
        Wed, 19 Oct 2022 03:38:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BB71B822E3;
        Wed, 19 Oct 2022 08:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6AEC433D7;
        Wed, 19 Oct 2022 08:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168955;
        bh=DuBg9+YDwGfVhiIKCEuJSBEIpdJSRSK0lHMA2+ye9Qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwnBkhXTuDQtJW3DpFhHttJU1ykUo7soO7SMyYCAUp/v6rQsHJFFJBkZuiIdQV96m
         7bWYVTSgVY2L9LGN8CUWPv5+yg2EI9/A2jlWo9zZRb9ek+xWZ3u2Fw+gzSd4Z/K8FH
         UaLeAuVNTPPk6oDkII08rMM6lxDwiiTZ24AqJ2T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Marangi <ansuelsmth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.0 072/862] dmaengine: qcom-adm: fix wrong sizeof config in slave_config
Date:   Wed, 19 Oct 2022 10:22:39 +0200
Message-Id: <20221019083253.109400728@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Marangi <ansuelsmth@gmail.com>

commit 7c8765308371be30f50c1b5b97618b731514b207 upstream.

Fix broken slave_config function that uncorrectly compare the
peripheral_size with the size of the config pointer instead of the size
of the config struct. This cause the crci value to be ignored and cause
a kernel panic on any slave that use adm driver.

To fix this, compare to the size of the struct and NOT the size of the
pointer.

Fixes: 03de6b273805 ("dmaengine: qcom-adm: stop abusing slave_id config")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.17+
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20220915204844.3838-1-ansuelsmth@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/qcom/qcom_adm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/qcom/qcom_adm.c
+++ b/drivers/dma/qcom/qcom_adm.c
@@ -494,7 +494,7 @@ static int adm_slave_config(struct dma_c
 
 	spin_lock_irqsave(&achan->vc.lock, flag);
 	memcpy(&achan->slave, cfg, sizeof(struct dma_slave_config));
-	if (cfg->peripheral_size == sizeof(config))
+	if (cfg->peripheral_size == sizeof(*config))
 		achan->crci = config->crci;
 	spin_unlock_irqrestore(&achan->vc.lock, flag);
 


