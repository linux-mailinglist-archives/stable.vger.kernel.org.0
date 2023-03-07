Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4746AEEED
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbjCGSSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbjCGSSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:18:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CB676B2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:13:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55FF0B819C2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80641C433D2;
        Tue,  7 Mar 2023 18:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212777;
        bh=Ieevzb72Tp4clAm6jd3V2JofjiB9KvCO+j6nF8eOlM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Khb5PzeNXs4pb0Jup8QnexvXTFJIC9qu/gOe1Ycjgd7N3/ys7Ubrf3fKG+fjgZ9hH
         Tu85InPJtpgLH5uFsm4oL/YW9jS9W9A3WfI3YcjfUrpQlR8ZXhkbL+cC+hq5Jc3itR
         y1zbP2sE0Ev5jX/krhuqqzN2ei67OrwO2H448y2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hui Tang <tanghui20@huawei.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 276/885] drm/msm/dpu: check for null return of devm_kzalloc() in dpu_writeback_init()
Date:   Tue,  7 Mar 2023 17:53:30 +0100
Message-Id: <20230307170013.999183932@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 21e9a838f505178e109ccb3bf19d7808eb0326f4 ]

Because of the possilble failure of devm_kzalloc(), dpu_wb_conn might
be NULL and will cause null pointer dereference later.

Therefore, it might be better to check it and directly return -ENOMEM.

Fixes: 77b001acdcfe ("drm/msm/dpu: add the writeback connector layer")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/512277/
Link: https://lore.kernel.org/r/20221119055518.179937-1-tanghui20@huawei.com
[DB: fixed typo in commit message]
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c
index 088ec990a2f26..2a5a68366582b 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_writeback.c
@@ -70,6 +70,8 @@ int dpu_writeback_init(struct drm_device *dev, struct drm_encoder *enc,
 	int rc = 0;
 
 	dpu_wb_conn = devm_kzalloc(dev->dev, sizeof(*dpu_wb_conn), GFP_KERNEL);
+	if (!dpu_wb_conn)
+		return -ENOMEM;
 
 	drm_connector_helper_add(&dpu_wb_conn->base.base, &dpu_wb_conn_helper_funcs);
 
-- 
2.39.2



