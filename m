Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 156EF126AED
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbfLSSwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:52:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729852AbfLSSwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:52:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E329D20674;
        Thu, 19 Dec 2019 18:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781537;
        bh=/RNUeUREqrykBAIP7/HzWlhfDvzGVU7SOlxeDFPZBec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GnqD49fw4i3ZB4kpQJt5hpZkjNZctVuycjDXWZKqx2Cyolm+RK4FpyRw72g50wOhG
         Gp6eGzNcv3trt9newfudbXBF/JmirapgE5NeWqRaqJBrBdcAfs01JDlHDayZGMaD0X
         D09xUIepSIqr9SJqfAMWqXJBiZ3nX3YJ9MgHNBoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Lew <clew@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 4.19 25/47] rpmsg: glink: Fix reuse intents memory leak issue
Date:   Thu, 19 Dec 2019 19:34:39 +0100
Message-Id: <20191219182931.246199295@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
References: <20191219182857.659088743@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Kumar Neelakantam <aneela@codeaurora.org>

commit b85f6b601407347f5425c4c058d1b7871f5bf4f0 upstream.

Memory allocated for re-usable intents are not freed during channel
cleanup which causes memory leak in system.

Check and free all re-usable memory to avoid memory leak.

Fixes: 933b45da5d1d ("rpmsg: glink: Add support for TX intents")
Cc: stable@vger.kernel.org
Acked-By: Chris Lew <clew@codeaurora.org>
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
Reported-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rpmsg/qcom_glink_native.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -241,10 +241,19 @@ static void qcom_glink_channel_release(s
 {
 	struct glink_channel *channel = container_of(ref, struct glink_channel,
 						     refcount);
+	struct glink_core_rx_intent *tmp;
 	unsigned long flags;
+	int iid;
 
 	spin_lock_irqsave(&channel->intent_lock, flags);
+	idr_for_each_entry(&channel->liids, tmp, iid) {
+		kfree(tmp->data);
+		kfree(tmp);
+	}
 	idr_destroy(&channel->liids);
+
+	idr_for_each_entry(&channel->riids, tmp, iid)
+		kfree(tmp);
 	idr_destroy(&channel->riids);
 	spin_unlock_irqrestore(&channel->intent_lock, flags);
 


