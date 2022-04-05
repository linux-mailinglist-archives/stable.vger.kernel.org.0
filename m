Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB32B4F2A9C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241797AbiDEIfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239333AbiDEIT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32026E284;
        Tue,  5 Apr 2022 01:11:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 754EAB81A32;
        Tue,  5 Apr 2022 08:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C328EC385A0;
        Tue,  5 Apr 2022 08:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146275;
        bh=h5Nq70pcGsqPB021TQrxeMRcJuiRv7B5yH9iGD2+nD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdtPQsf/9V4D1mGJIB1B/S/GeUXnDcWfmSXext7yxb0DSmcu0G2EASas1pmJqkQQD
         V0w58rZ4dHXgzskgYgUQ2joyNpLZaRSjhLMooKPQ0bCQhZ5anZgMYZmnylMFWcLMiT
         FIqbGlq2tp/Xq9snqlzLcXX32bcq42UMRdYwH7Cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0704/1126] net: wwan: qcom_bam_dmux: fix wrong pointer passed to IS_ERR()
Date:   Tue,  5 Apr 2022 09:24:11 +0200
Message-Id: <20220405070428.268770560@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 6b3c74550224c3be24c4cf6ab8c333602b458bff ]

It should check dmux->tx after calling dma_request_chan().

Fixes: 21a0ffd9b38c ("net: wwan: Add Qualcomm BAM-DMUX WWAN network driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20220319032450.3288224-1-yangyingliang@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/qcom_bam_dmux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/qcom_bam_dmux.c b/drivers/net/wwan/qcom_bam_dmux.c
index 5dfa2eba6014..17d46f4d2913 100644
--- a/drivers/net/wwan/qcom_bam_dmux.c
+++ b/drivers/net/wwan/qcom_bam_dmux.c
@@ -755,7 +755,7 @@ static int __maybe_unused bam_dmux_runtime_resume(struct device *dev)
 		return 0;
 
 	dmux->tx = dma_request_chan(dev, "tx");
-	if (IS_ERR(dmux->rx)) {
+	if (IS_ERR(dmux->tx)) {
 		dev_err(dev, "Failed to request TX DMA channel: %pe\n", dmux->tx);
 		dmux->tx = NULL;
 		bam_dmux_runtime_suspend(dev);
-- 
2.34.1



