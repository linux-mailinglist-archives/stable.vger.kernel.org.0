Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651102E3F2A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504901AbgL1Og4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:36:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504885AbgL1OdF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:33:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C7A0206D4;
        Mon, 28 Dec 2020 14:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165969;
        bh=hfGAzxgubNtqS1g0AHEjQw1M9/OnoKR1dMbvtwg37SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V8GtOM+sad8eMqIrxrQdYW+vxJtke9yKZi25Eph/GXTWmFaGc94v+43vTXJ1oavj/
         R1taaVcbPI52Z9i0g9cg/kH7B7M+H94yxTtmgT0Qy9bof/TuqQPFxT/Azw2o4+ZKCL
         Sy43aX0ZPVqoDxz4ag8erGiklw6eJ19Q0+IZCW2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rishabh Bhatnagar <rishabhb@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.10 712/717] remoteproc: sysmon: Ensure remote notification ordering
Date:   Mon, 28 Dec 2020 13:51:50 +0100
Message-Id: <20201228125055.112425273@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

commit 138a6428ba9023ae29e103e87a223575fbc3d2b7 upstream.

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
Reviewed-by: Rishabh Bhatnagar <rishabhb@codeaurora.org>
Link: https://lore.kernel.org/r/20201122054135.802935-2-bjorn.andersson@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/remoteproc/qcom_sysmon.c |   25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

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
@@ -448,7 +451,10 @@ static int sysmon_prepare(struct rproc_s
 		.ssr_event = SSCTL_SSR_EVENT_BEFORE_POWERUP
 	};
 
+	mutex_lock(&sysmon->state_lock);
+	sysmon->state = SSCTL_SSR_EVENT_BEFORE_POWERUP;
 	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
+	mutex_unlock(&sysmon->state_lock);
 
 	return 0;
 }
@@ -472,20 +478,25 @@ static int sysmon_start(struct rproc_sub
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
 
@@ -500,7 +511,10 @@ static void sysmon_stop(struct rproc_sub
 		.ssr_event = SSCTL_SSR_EVENT_BEFORE_SHUTDOWN
 	};
 
+	mutex_lock(&sysmon->state_lock);
+	sysmon->state = SSCTL_SSR_EVENT_BEFORE_SHUTDOWN;
 	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
+	mutex_unlock(&sysmon->state_lock);
 
 	/* Don't request graceful shutdown if we've crashed */
 	if (crashed)
@@ -521,7 +535,10 @@ static void sysmon_unprepare(struct rpro
 		.ssr_event = SSCTL_SSR_EVENT_AFTER_SHUTDOWN
 	};
 
+	mutex_lock(&sysmon->state_lock);
+	sysmon->state = SSCTL_SSR_EVENT_AFTER_SHUTDOWN;
 	blocking_notifier_call_chain(&sysmon_notifiers, 0, (void *)&event);
+	mutex_unlock(&sysmon->state_lock);
 }
 
 /**
@@ -534,11 +551,10 @@ static int sysmon_notify(struct notifier
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
@@ -591,6 +607,7 @@ struct qcom_sysmon *qcom_add_sysmon_subd
 	init_completion(&sysmon->ind_comp);
 	init_completion(&sysmon->shutdown_comp);
 	mutex_init(&sysmon->lock);
+	mutex_init(&sysmon->state_lock);
 
 	sysmon->shutdown_irq = of_irq_get_byname(sysmon->dev->of_node,
 						 "shutdown-ack");


