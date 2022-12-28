Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B193E65839D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiL1QtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiL1Qsb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:48:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA6113F10
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:44:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3A8EB817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576E4C433EF;
        Wed, 28 Dec 2022 16:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245846;
        bh=eIsbVJkaLNsF8FU6WqOBh2MXTC86+Bz3Li2Q9EgLgqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWhlgOpeB5LWVsAM+fNgMEKT4wFNzIV+9+kX7jXRH5t26KeEHYr/1btDtQrmlk5Fo
         XQyhw05Dxwrp/w9v6T2TK6rtkwvcPMiZP0qJpFmQAc/5GpN/fVuORcVVlSsY0SLQwy
         +snJ5FEvoyDLwFm+Xc8Sqdf5Nk48W0d1Uut7DgPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0935/1146] HID: amd_sfh: Add missing check for dma_alloc_coherent
Date:   Wed, 28 Dec 2022 15:41:14 +0100
Message-Id: <20221228144355.694045491@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 53ffa6a9f83b2170c60591da1ead8791d5a42e81 ]

Add check for the return value of the dma_alloc_coherent since
it may return NULL pointer if allocation fails.

Fixes: 4b2c53d93a4b ("SFH:Transport Driver to add support of AMD Sensor Fusion Hub (SFH)")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20221220024921.21992-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index 8275bba63611..ab125f79408f 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -237,6 +237,10 @@ int amd_sfh_hid_client_init(struct amd_mp2_dev *privdata)
 		in_data->sensor_virt_addr[i] = dma_alloc_coherent(dev, sizeof(int) * 8,
 								  &cl_data->sensor_dma_addr[i],
 								  GFP_KERNEL);
+		if (!in_data->sensor_virt_addr[i]) {
+			rc = -ENOMEM;
+			goto cleanup;
+		}
 		cl_data->sensor_sts[i] = SENSOR_DISABLED;
 		cl_data->sensor_requested_cnt[i] = 0;
 		cl_data->cur_hid_dev = i;
-- 
2.35.1



