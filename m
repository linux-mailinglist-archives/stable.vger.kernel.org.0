Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC893C48F6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbhGLGlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:41:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237996AbhGLGjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52BA361209;
        Mon, 12 Jul 2021 06:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071765;
        bh=+SFMheMNdCsFbXadFTYR3GwVrCHK8sjTK+IBbtA96hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMoarjvsXda7NRKuhClEaKNyeMq+7WfjfpKIwIiS9Jfa/NawKAqpjJQ5BEXZzQbDV
         QnkxSgNT6v9httqgtK9QRIsOqfgcthDNF39zd5bmpDPtOjeYfvpNOuleuTCm0k3K3+
         pybrxiRgMRUG9LOLYfkFqNVG5lL0i9OQzUpuXf0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 211/593] media: venus: Rework error fail recover logic
Date:   Mon, 12 Jul 2021 08:06:11 +0200
Message-Id: <20210712060906.140829688@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 4cba5473c5ce0f1389d316c5dc6f83a0259df5eb ]

The Venus code has a sort of watchdog that attempts to recover
from IP errors, implemented as a delayed work job, which
calls venus_sys_error_handler().

Right now, it has several issues:

1. It assumes that PM runtime resume never fails

2. It internally runs two while() loops that also assume that
   PM runtime will never fail to go idle:

	while (pm_runtime_active(core->dev_dec) || pm_runtime_active(core->dev_enc))
		msleep(10);

...

	while (core->pmdomains[0] && pm_runtime_active(core->pmdomains[0]))
		usleep_range(1000, 1500);

3. It uses an OR to merge all return codes and then report to the user

4. If the hardware never recovers, it keeps running on every 10ms,
   flooding the syslog with 2 messages (so, up to 200 messages
   per second).

Rework the code, in order to prevent that, by:

1. check the return code from PM runtime resume;
2. don't let the while() loops run forever;
3. store the failed event;
4. use warn ratelimited when it fails to recover.

Fixes: af2c3834c8ca ("[media] media: venus: adding core part and helper functions")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 60 +++++++++++++++++++-----
 1 file changed, 47 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index fd5993b3e674..58ddebbb8446 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -48,52 +48,86 @@ static const struct hfi_core_ops venus_core_ops = {
 	.event_notify = venus_event_notify,
 };
 
+#define RPM_WAIT_FOR_IDLE_MAX_ATTEMPTS 10
+
 static void venus_sys_error_handler(struct work_struct *work)
 {
 	struct venus_core *core =
 			container_of(work, struct venus_core, work.work);
-	int ret = 0;
-
-	pm_runtime_get_sync(core->dev);
+	int ret, i, max_attempts = RPM_WAIT_FOR_IDLE_MAX_ATTEMPTS;
+	const char *err_msg = "";
+	bool failed = false;
+
+	ret = pm_runtime_get_sync(core->dev);
+	if (ret < 0) {
+		err_msg = "resume runtime PM";
+		max_attempts = 0;
+		failed = true;
+	}
 
 	hfi_core_deinit(core, true);
 
-	dev_warn(core->dev, "system error has occurred, starting recovery!\n");
-
 	mutex_lock(&core->lock);
 
-	while (pm_runtime_active(core->dev_dec) || pm_runtime_active(core->dev_enc))
+	for (i = 0; i < max_attempts; i++) {
+		if (!pm_runtime_active(core->dev_dec) && !pm_runtime_active(core->dev_enc))
+			break;
 		msleep(10);
+	}
 
 	venus_shutdown(core);
 
 	pm_runtime_put_sync(core->dev);
 
-	while (core->pmdomains[0] && pm_runtime_active(core->pmdomains[0]))
+	for (i = 0; i < max_attempts; i++) {
+		if (!core->pmdomains[0] || !pm_runtime_active(core->pmdomains[0]))
+			break;
 		usleep_range(1000, 1500);
+	}
 
 	hfi_reinit(core);
 
-	pm_runtime_get_sync(core->dev);
+	ret = pm_runtime_get_sync(core->dev);
+	if (ret < 0) {
+		err_msg = "resume runtime PM";
+		failed = true;
+	}
+
+	ret = venus_boot(core);
+	if (ret && !failed) {
+		err_msg = "boot Venus";
+		failed = true;
+	}
 
-	ret |= venus_boot(core);
-	ret |= hfi_core_resume(core, true);
+	ret = hfi_core_resume(core, true);
+	if (ret && !failed) {
+		err_msg = "resume HFI";
+		failed = true;
+	}
 
 	enable_irq(core->irq);
 
 	mutex_unlock(&core->lock);
 
-	ret |= hfi_core_init(core);
+	ret = hfi_core_init(core);
+	if (ret && !failed) {
+		err_msg = "init HFI";
+		failed = true;
+	}
 
 	pm_runtime_put_sync(core->dev);
 
-	if (ret) {
+	if (failed) {
 		disable_irq_nosync(core->irq);
-		dev_warn(core->dev, "recovery failed (%d)\n", ret);
+		dev_warn_ratelimited(core->dev,
+				     "System error has occurred, recovery failed to %s\n",
+				     err_msg);
 		schedule_delayed_work(&core->work, msecs_to_jiffies(10));
 		return;
 	}
 
+	dev_warn(core->dev, "system error has occurred (recovered)\n");
+
 	mutex_lock(&core->lock);
 	core->sys_error = false;
 	mutex_unlock(&core->lock);
-- 
2.30.2



