Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5690593A46
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241673AbiHOTeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244155AbiHOTcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:32:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D3E606A6;
        Mon, 15 Aug 2022 11:45:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D133B81057;
        Mon, 15 Aug 2022 18:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818BFC433C1;
        Mon, 15 Aug 2022 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589104;
        bh=0uKQ4XlDoVmec3sjjPuLPu/Rai684n2yPKBqpnW4JQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lHIgNfg0FvvMJpRdK1SdFLFw4FHmV98LiDwcZIuYut4qRMrDpOkTUBklvqgmLRPVJ
         5SpTqFKGuTO1uvqiRm1huhner7HayXLm71awcF4xtUijZLPJYWttXfOW9hDBykIWuK
         Qe0uQmh6Egi2ROh1CUsbXfKblRh99sCwR6Dvc6ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Sibi Sankar <quic_sibis@quicinc.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 614/779] remoteproc: sysmon: Wait for SSCTL service to come up
Date:   Mon, 15 Aug 2022 20:04:18 +0200
Message-Id: <20220815180403.610017606@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Sibi Sankar <quic_sibis@quicinc.com>

[ Upstream commit 47c04e00eff86a81cd357c3feed04c86089bcb85 ]

The SSCTL service comes up after a finite time when the remote Q6 comes
out of reset. Any graceful shutdowns requested during this period will
be a NOP and abrupt tearing down of the glink channel might lead to pending
transactions on the remote Q6 side and will ultimately lead to a fatal
error. Fix this by waiting for the SSCTL service when a graceful shutdown
is requested.

Fixes: 1fb82ee806d1 ("remoteproc: qcom: Introduce sysmon")
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Sibi Sankar <quic_sibis@quicinc.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1657022900-2049-7-git-send-email-quic_sibis@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_sysmon.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/remoteproc/qcom_sysmon.c b/drivers/remoteproc/qcom_sysmon.c
index 9fca81492863..a9f04dd83ab6 100644
--- a/drivers/remoteproc/qcom_sysmon.c
+++ b/drivers/remoteproc/qcom_sysmon.c
@@ -41,6 +41,7 @@ struct qcom_sysmon {
 	struct completion comp;
 	struct completion ind_comp;
 	struct completion shutdown_comp;
+	struct completion ssctl_comp;
 	struct mutex lock;
 
 	bool ssr_ack;
@@ -445,6 +446,8 @@ static int ssctl_new_server(struct qmi_handle *qmi, struct qmi_service *svc)
 
 	svc->priv = sysmon;
 
+	complete(&sysmon->ssctl_comp);
+
 	return 0;
 }
 
@@ -501,6 +504,7 @@ static int sysmon_start(struct rproc_subdev *subdev)
 		.ssr_event = SSCTL_SSR_EVENT_AFTER_POWERUP
 	};
 
+	reinit_completion(&sysmon->ssctl_comp);
 	mutex_lock(&sysmon->state_lock);
 	sysmon->state = SSCTL_SSR_EVENT_AFTER_POWERUP;
 	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
@@ -545,6 +549,11 @@ static void sysmon_stop(struct rproc_subdev *subdev, bool crashed)
 	if (crashed)
 		return;
 
+	if (sysmon->ssctl_instance) {
+		if (!wait_for_completion_timeout(&sysmon->ssctl_comp, HZ / 2))
+			dev_err(sysmon->dev, "timeout waiting for ssctl service\n");
+	}
+
 	if (sysmon->ssctl_version)
 		sysmon->shutdown_acked = ssctl_request_shutdown(sysmon);
 	else if (sysmon->ept)
@@ -631,6 +640,7 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
 	init_completion(&sysmon->comp);
 	init_completion(&sysmon->ind_comp);
 	init_completion(&sysmon->shutdown_comp);
+	init_completion(&sysmon->ssctl_comp);
 	mutex_init(&sysmon->lock);
 	mutex_init(&sysmon->state_lock);
 
-- 
2.35.1



