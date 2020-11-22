Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14182BC3F3
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 06:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbgKVFlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 00:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727267AbgKVFle (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 00:41:34 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF78BC0613CF
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 21:41:34 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id v202so12677697oia.9
        for <stable@vger.kernel.org>; Sat, 21 Nov 2020 21:41:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yQvyFDM0JjV69fRQJvQbh4EUUpGYP88ib4fx5c7S58s=;
        b=mJBunxM5mgkzBeH2Zqtr83SqxLzRQSI7jClSU564b/d8b94UJKf0ItjyaU8DOysg9q
         c2qrBo8aHMdfR9hFXUBrTuIndVRUWnODvuOoejC55fXbmlNn/YwzSESZOD/40gvxinXC
         Wvd3n8E82XsOpQlCJclCsN+Tbf5AAzNUhsp9Qpc9dTYWz9oLvdK+BPp2+S8sI+8Fj4xT
         AkZJ/sAcKBw4adkSr0cQMyyDeMTuuwYzOes78AZLUJ9otLcg12Rx5f4U8Xs7wNSSENWN
         ppDjxUS4l2njr6Cm53FAz6F95SPpOhxtr95nOCHLdfngcggTtw3lm2iBNOTZmutjWhDE
         vTLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yQvyFDM0JjV69fRQJvQbh4EUUpGYP88ib4fx5c7S58s=;
        b=SMVSmFbYGrfQGNnfMtBXyzoLpFtuObFwmOyORM35XnVJ4hihV3HYdPkNxDsxejWoN+
         FMFourv+vrqYqg0WEaesB/ez6ES24blG91NI9/MIsRwcD+kQqF69v2O9mLXHIz/n3Co7
         XElo3EpwaytO7qtuR/G3dJPIZpoScOiyjX34drJTV5XedHhitFrf47qo4bF1s6GXnRDo
         LCNGvdDCDceNdMEEIGjUsUsVJHAYATMpFeBi8F3Yc05jeLm/K1NRB6vvjpgZnamj0/er
         skXz0JzrJLfe47AXaAf6oBsILxUf8/pMmslaIsmNpoyLG/xOPH64XSh79XAtZJE8yf2K
         R43w==
X-Gm-Message-State: AOAM531SgFATcATLKxAjeF4wWJM4DMAbOT8xEzek8+jKvtBf1Xjg3U4S
        f1P6BLzKzmMzkkq63f1fSmGRkQ==
X-Google-Smtp-Source: ABdhPJyqx4jrmkRkFOuiZci8CzeEUgW29mdcrfQBlpoCszNp00F3WQtf7ygPl9u4zmcUvbfO92rU8g==
X-Received: by 2002:a54:4608:: with SMTP id p8mr11536251oip.5.1606023694131;
        Sat, 21 Nov 2020 21:41:34 -0800 (PST)
Received: from localhost.localdomain (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id s28sm4303132otr.4.2020.11.21.21.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2020 21:41:33 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Siddharth Gupta <sidgup@codeaurora.org>
Cc:     Mathieu Poirier <mathieu.poirier@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v3 1/4] remoteproc: sysmon: Ensure remote notification ordering
Date:   Sat, 21 Nov 2020 21:41:32 -0800
Message-Id: <20201122054135.802935-2-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201122054135.802935-1-bjorn.andersson@linaro.org>
References: <20201122054135.802935-1-bjorn.andersson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The reliance on the remoteproc's state for determining when to send
sysmon notifications to a remote processor is racy with regard to
concurrent remoteproc operations.

Further more the advertisement of the state of other remote processor to
a newly started remote processor might not only send the wrong state,
but might result in a stream of state changes that are out of order.

Address this by introducing state tracking within the sysmon instances
themselves and extend the locking to ensure that the notifications are
consistent with this state.

Fixes: 1f36ab3f6e3b ("remoteproc: sysmon: Inform current rproc about all active rprocs")
Fixes: 1877f54f75ad ("remoteproc: sysmon: Add notifications for events")
Fixes: 1fb82ee806d1 ("remoteproc: qcom: Introduce sysmon")
Cc: stable@vger.kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v2:
- Hold sysmon_lock during traversal of sysmons in sysmon_start()

 drivers/remoteproc/qcom_sysmon.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/remoteproc/qcom_sysmon.c b/drivers/remoteproc/qcom_sysmon.c
index 9eb2f6bccea6..b37b111b15b3 100644
--- a/drivers/remoteproc/qcom_sysmon.c
+++ b/drivers/remoteproc/qcom_sysmon.c
@@ -22,6 +22,9 @@ struct qcom_sysmon {
 	struct rproc_subdev subdev;
 	struct rproc *rproc;
 
+	int state;
+	struct mutex state_lock;
+
 	struct list_head node;
 
 	const char *name;
@@ -448,7 +451,10 @@ static int sysmon_prepare(struct rproc_subdev *subdev)
 		.ssr_event = SSCTL_SSR_EVENT_BEFORE_POWERUP
 	};
 
+	mutex_lock(&sysmon->state_lock);
+	sysmon->state = SSCTL_SSR_EVENT_BEFORE_POWERUP;
 	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
+	mutex_unlock(&sysmon->state_lock);
 
 	return 0;
 }
@@ -472,20 +478,25 @@ static int sysmon_start(struct rproc_subdev *subdev)
 		.ssr_event = SSCTL_SSR_EVENT_AFTER_POWERUP
 	};
 
+	mutex_lock(&sysmon->state_lock);
+	sysmon->state = SSCTL_SSR_EVENT_AFTER_POWERUP;
 	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
+	mutex_unlock(&sysmon->state_lock);
 
 	mutex_lock(&sysmon_lock);
 	list_for_each_entry(target, &sysmon_list, node) {
-		if (target == sysmon ||
-		    target->rproc->state != RPROC_RUNNING)
+		if (target == sysmon)
 			continue;
 
+		mutex_lock(&target->state_lock);
 		event.subsys_name = target->name;
+		event.ssr_event = target->state;
 
 		if (sysmon->ssctl_version == 2)
 			ssctl_send_event(sysmon, &event);
 		else if (sysmon->ept)
 			sysmon_send_event(sysmon, &event);
+		mutex_unlock(&target->state_lock);
 	}
 	mutex_unlock(&sysmon_lock);
 
@@ -500,7 +511,10 @@ static void sysmon_stop(struct rproc_subdev *subdev, bool crashed)
 		.ssr_event = SSCTL_SSR_EVENT_BEFORE_SHUTDOWN
 	};
 
+	mutex_lock(&sysmon->state_lock);
+	sysmon->state = SSCTL_SSR_EVENT_BEFORE_SHUTDOWN;
 	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
+	mutex_unlock(&sysmon->state_lock);
 
 	/* Don't request graceful shutdown if we've crashed */
 	if (crashed)
@@ -521,7 +535,10 @@ static void sysmon_unprepare(struct rproc_subdev *subdev)
 		.ssr_event = SSCTL_SSR_EVENT_AFTER_SHUTDOWN
 	};
 
+	mutex_lock(&sysmon->state_lock);
+	sysmon->state = SSCTL_SSR_EVENT_AFTER_SHUTDOWN;
 	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
+	mutex_unlock(&sysmon->state_lock);
 }
 
 /**
@@ -534,11 +551,10 @@ static int sysmon_notify(struct notifier_block *nb, unsigned long event,
 			 void *data)
 {
 	struct qcom_sysmon *sysmon = container_of(nb, struct qcom_sysmon, nb);
-	struct rproc *rproc = sysmon->rproc;
 	struct sysmon_event *sysmon_event = data;
 
 	/* Skip non-running rprocs and the originating instance */
-	if (rproc->state != RPROC_RUNNING ||
+	if (sysmon->state != SSCTL_SSR_EVENT_AFTER_POWERUP ||
 	    !strcmp(sysmon_event->subsys_name, sysmon->name)) {
 		dev_dbg(sysmon->dev, "not notifying %s\n", sysmon->name);
 		return NOTIFY_DONE;
@@ -591,6 +607,7 @@ struct qcom_sysmon *qcom_add_sysmon_subdev(struct rproc *rproc,
 	init_completion(&sysmon->ind_comp);
 	init_completion(&sysmon->shutdown_comp);
 	mutex_init(&sysmon->lock);
+	mutex_init(&sysmon->state_lock);
 
 	sysmon->shutdown_irq = of_irq_get_byname(sysmon->dev->of_node,
 						 "shutdown-ack");
-- 
2.28.0

