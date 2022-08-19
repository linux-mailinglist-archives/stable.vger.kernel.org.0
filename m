Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD8859A23F
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353046AbiHSQdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353576AbiHSQcD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:32:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8875511DF7E;
        Fri, 19 Aug 2022 09:06:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A74D6181D;
        Fri, 19 Aug 2022 16:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8A7C433C1;
        Fri, 19 Aug 2022 16:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925155;
        bh=AD/vWRMOvNFRxnHKMIJOvSwHXchkrJHKZPayuloKjnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LLbE++CMZuwfM/aDSYtxQBJv26qWvuO7ZPWqNUVk4r1myC/y60wTP9ZVMVxm9w4NC
         I/CDpoyRjBLzbcXKrexB4V9YWSuagmbLYWPwuy9HllQWETXH9pvRy4ZC6M5Nk0Ug0C
         EaS3RORrB3jhbTzn9bSrQGghL6CSjd4VkeWLuL4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Sibi Sankar <quic_sibis@quicinc.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 401/545] remoteproc: sysmon: Wait for SSCTL service to come up
Date:   Fri, 19 Aug 2022 17:42:51 +0200
Message-Id: <20220819153847.371989448@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index b37b111b15b3..a26221a6f6c2 100644
--- a/drivers/remoteproc/qcom_sysmon.c
+++ b/drivers/remoteproc/qcom_sysmon.c
@@ -41,6 +41,7 @@ struct qcom_sysmon {
 	struct completion comp;
 	struct completion ind_comp;
 	struct completion shutdown_comp;
+	struct completion ssctl_comp;
 	struct mutex lock;
 
 	bool ssr_ack;
@@ -422,6 +423,8 @@ static int ssctl_new_server(struct qmi_handle *qmi, struct qmi_service *svc)
 
 	svc->priv = sysmon;
 
+	complete(&sysmon->ssctl_comp);
+
 	return 0;
 }
 
@@ -478,6 +481,7 @@ static int sysmon_start(struct rproc_subdev *subdev)
 		.ssr_event = SSCTL_SSR_EVENT_AFTER_POWERUP
 	};
 
+	reinit_completion(&sysmon->ssctl_comp);
 	mutex_lock(&sysmon->state_lock);
 	sysmon->state = SSCTL_SSR_EVENT_AFTER_POWERUP;
 	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
@@ -520,6 +524,11 @@ static void sysmon_stop(struct rproc_subdev *subdev, bool crashed)
 	if (crashed)
 		return;
 
+	if (sysmon->ssctl_instance) {
+		if (!wait_for_completion_timeout(&sysmon->ssctl_comp, HZ / 2))
+			dev_err(sysmon->dev, "timeout waiting for ssctl service\n");
+	}
+
 	if (sysmon->ssctl_version)
 		ssctl_request_shutdown(sysmon);
 	else if (sysmon->ept)
@@ -606,6 +615,7 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
 	init_completion(&sysmon->comp);
 	init_completion(&sysmon->ind_comp);
 	init_completion(&sysmon->shutdown_comp);
+	init_completion(&sysmon->ssctl_comp);
 	mutex_init(&sysmon->lock);
 	mutex_init(&sysmon->state_lock);
 
-- 
2.35.1



