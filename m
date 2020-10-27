Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0D929BFB4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1816446AbgJ0RGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1787599AbgJ0PAO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:00:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF8B520714;
        Tue, 27 Oct 2020 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810813;
        bh=09BtgDStkjmQQSw+UuaeyxieHWs44qv+TUAKa6HcKmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dfy3DNB0b3NXTSbM/GoHyfc7iOSXAJ1VevhhdRk0+CUPY3r0brLunp5Faw7fXWv/x
         0j2EtgGUW82cDr6VsfQTtJ7umTc17s0jrsFdWqkOy3gTohZpikd5yZXZ29hK2yPNWd
         BEboXt4oIyCkMigS5Dxsr8JKHFNnRpDdgboVN0+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 272/633] slimbus: qcom-ngd-ctrl: disable ngd in qmi server down callback
Date:   Tue, 27 Oct 2020 14:50:15 +0100
Message-Id: <20201027135535.427361599@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 709ec3f7fc5773ac4aa6fb22c3f0ac8103c674db ]

In QMI new server notification we enable the NGD however during
delete server notification we do not disable the NGD.

This can lead to multiple instances of NGD being enabled, so make
sure that we disable NGD in delete server callback to fix this issue!

Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200925095520.27316-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index 743ee7b4e63f2..218aefc3531cd 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1277,9 +1277,13 @@ static void qcom_slim_ngd_qmi_del_server(struct qmi_handle *hdl,
 {
 	struct qcom_slim_ngd_qmi *qmi =
 		container_of(hdl, struct qcom_slim_ngd_qmi, svc_event_hdl);
+	struct qcom_slim_ngd_ctrl *ctrl =
+		container_of(qmi, struct qcom_slim_ngd_ctrl, qmi);
 
 	qmi->svc_info.sq_node = 0;
 	qmi->svc_info.sq_port = 0;
+
+	qcom_slim_ngd_enable(ctrl, false);
 }
 
 static struct qmi_ops qcom_slim_ngd_qmi_svc_event_ops = {
-- 
2.25.1



