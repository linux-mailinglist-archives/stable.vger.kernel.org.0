Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3268FB68F0
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 19:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732141AbfIRRTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 13:19:45 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32942 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732113AbfIRRT1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 13:19:27 -0400
Received: by mail-pl1-f193.google.com with SMTP id t11so283550plo.0
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 10:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Zted6byoUjfvi72VSDIhM8pesVU1cPbkC92rYkmfs6k=;
        b=rYhSObq4evGVg356bza5zIWCf7uvuBbpf4HCEDLaZ/lBqNwdVQZDZZoJiUCg5d1A6b
         cmF677BmCdEDLLgmJKuII4SBexOEnJwmuqvItJo7DaeE8IDlhRrFU1xI9PNu54Am5Nsq
         8O0JANibva5B7rlPn5iBN4STl/6PWnmXYTPwCkim8kiqhcs1bBXjWFga1BqcQvhJ+3jx
         6H3jIg+C1VUq53LrNHDo9jwI4WZQH3nT2sDwFIIyNQGKmh9nDz2jmGUAUZmF6LsTpOp4
         0UBsPBSdsE1TcqagQJhKslYjT7t1M6t8FJAsbCKRKUeRT04AaniPiAI5g229tX0I+wvt
         tjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Zted6byoUjfvi72VSDIhM8pesVU1cPbkC92rYkmfs6k=;
        b=iO/VmpWYtYUaafFpWgif77NB2ToOm5GvVpf7i9W4YvRRqs6LmlpJX7Ucxv1OG/1zK9
         zB4SyVJOAeeOwV/1p3PWpwBkczakpKcatc0hZfnIetjCf+g5cyNUuJsPWAAW0XLE9i0R
         QK68azZkoCZ2IPHj2F5Th0pnBfRuCnvtUmFCqP9OS3SeeyOSJiNam9M9bwbUn15pyOo4
         CCTpWS/gsq/0hj9CVXFw+baDmfbGlp7UegoR6T0zvf2ouppyXLv5zEWHEYmBg4OlMRSE
         Sh7aF5fw8xIrWeNBYQqeC+38ev6+av+vTFjPGukqgoa+XzfZcWVITawstBuTDVh6lubN
         q8ng==
X-Gm-Message-State: APjAAAWBmjOtJYHs5KUE/XZUkU+TVtLyTwYXy4KJ4sk8qyLra1i39l/E
        Ng8Ckdq6YNXHYgS2vajgrFw27A==
X-Google-Smtp-Source: APXvYqw0iFqROo2OVRy0jIHEtn/M2cMt17ahjJ12kB01MygdAcnt0iw88YZq2uoIDfL3USxZjvrq+w==
X-Received: by 2002:a17:902:b497:: with SMTP id y23mr5286203plr.201.1568827166359;
        Wed, 18 Sep 2019 10:19:26 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id y4sm2614981pjn.19.2019.09.18.10.19.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 10:19:25 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jorge Ramirez <jorge.ramirez-ortiz@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 5/6] rpmsg: glink: Don't send pending rx_done during remove
Date:   Wed, 18 Sep 2019 10:19:15 -0700
Message-Id: <20190918171916.4039-6-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190918171916.4039-1-bjorn.andersson@linaro.org>
References: <20190918171916.4039-1-bjorn.andersson@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Attempting to transmit rx_done messages after the GLINK instance is
being torn down will cause use after free and memory leaks. So cancel
the intent_work and free up the pending intents.

Fixes: 1d2ea36eead9 ("rpmsg: glink: Add rx done command")
Cc: stable@vger.kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 drivers/rpmsg/qcom_glink_native.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 89e02baea2d0..0d7518a6ebf0 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -241,11 +241,23 @@ static void qcom_glink_channel_release(struct kref *ref)
 {
 	struct glink_channel *channel = container_of(ref, struct glink_channel,
 						     refcount);
+	struct glink_core_rx_intent *intent;
 	struct glink_core_rx_intent *tmp;
 	unsigned long flags;
 	int iid;
 
+	/* cancel pending rx_done work */
+	cancel_work_sync(&channel->intent_work);
+
 	spin_lock_irqsave(&channel->intent_lock, flags);
+	/* Free all non-reuse intents pending rx_done work */
+	list_for_each_entry_safe(intent, tmp, &channel->done_intents, node) {
+		if (!intent->reuse) {
+			kfree(intent->data);
+			kfree(intent);
+		}
+	}
+
 	idr_for_each_entry(&channel->liids, tmp, iid) {
 		kfree(tmp->data);
 		kfree(tmp);
-- 
2.18.0

