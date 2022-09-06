Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 961045AECAE
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239707AbiIFOFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241423AbiIFOET (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:04:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F8623BEA;
        Tue,  6 Sep 2022 06:44:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 64FEACE1787;
        Tue,  6 Sep 2022 13:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5322FC433D6;
        Tue,  6 Sep 2022 13:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471827;
        bh=3hpdQp57BRCXBbsCxXizJ7fG6VM4WmSuuLi+zKB2HRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1gvUVwZL31p9V9no9DTRXnWpZ7fVzXf4gHrtdRDOyGVP3vGCbwtzNEmBFSxAbjU0
         JNz5ENx7O7SoiO0zSXYR1fRZJHtOW77YgkpksO8OeUIZEifuRNlhm6M6pRmTujdv3F
         hCRRFCwAaDpMhglrfktqBjp4sAlI6ez2xlnOGtSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 052/155] soundwire: qcom: fix device status array range
Date:   Tue,  6 Sep 2022 15:30:00 +0200
Message-Id: <20220906132831.621159459@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 4ef3f2aff1267bfa6d5a90c42a30b927b8aa239b ]

This patch updates device status array range from 11 to 12 as we will
be reading status from device number 0 to device number 11 inclusive.

Without this patch we can potentially access status array out of range
during auto-enumeration.

Fixes: aa1262ca6695 ("soundwire: qcom: Check device status before reading devid")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220708104747.8722-1-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/qcom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index b5ec7726592c8..71d2931cb885c 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -167,7 +167,7 @@ struct qcom_swrm_ctrl {
 	u8 wcmd_id;
 	struct qcom_swrm_port_config pconfig[QCOM_SDW_MAX_PORTS];
 	struct sdw_stream_runtime *sruntime[SWRM_MAX_DAIS];
-	enum sdw_slave_status status[SDW_MAX_DEVICES];
+	enum sdw_slave_status status[SDW_MAX_DEVICES + 1];
 	int (*reg_read)(struct qcom_swrm_ctrl *ctrl, int reg, u32 *val);
 	int (*reg_write)(struct qcom_swrm_ctrl *ctrl, int reg, int val);
 	u32 slave_status;
@@ -411,7 +411,7 @@ static int qcom_swrm_get_alert_slave_dev_num(struct qcom_swrm_ctrl *ctrl)
 
 	ctrl->reg_read(ctrl, SWRM_MCP_SLV_STATUS, &val);
 
-	for (dev_num = 0; dev_num < SDW_MAX_DEVICES; dev_num++) {
+	for (dev_num = 0; dev_num <= SDW_MAX_DEVICES; dev_num++) {
 		status = (val >> (dev_num * SWRM_MCP_SLV_STATUS_SZ));
 
 		if ((status & SWRM_MCP_SLV_STATUS_MASK) == SDW_SLAVE_ALERT) {
@@ -431,7 +431,7 @@ static void qcom_swrm_get_device_status(struct qcom_swrm_ctrl *ctrl)
 	ctrl->reg_read(ctrl, SWRM_MCP_SLV_STATUS, &val);
 	ctrl->slave_status = val;
 
-	for (i = 0; i < SDW_MAX_DEVICES; i++) {
+	for (i = 0; i <= SDW_MAX_DEVICES; i++) {
 		u32 s;
 
 		s = (val >> (i * 2));
-- 
2.35.1



