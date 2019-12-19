Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE23F126B20
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbfLSSyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:54:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:49482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730113AbfLSSyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:54:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B6BA222C2;
        Thu, 19 Dec 2019 18:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781646;
        bh=/RNUeUREqrykBAIP7/HzWlhfDvzGVU7SOlxeDFPZBec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Htmm0SMmCegSi5jiG/4Q1TZmjKIbGLTZEv5+lmGZ/YSYE+W7fRATJGEdtyZhM95wH
         48WTOvB47fLbwGfBzUW/RqQbqaiNXJdLOY9KfMr1VVq9U6TjXX8tNAdGBC2Q8jnZJN
         KbnUc7xKygmR4r2ktLyLC+3MXDWY1mDJJlO5OVxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Lew <clew@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.4 22/80] rpmsg: glink: Fix reuse intents memory leak issue
Date:   Thu, 19 Dec 2019 19:34:14 +0100
Message-Id: <20191219183101.706269733@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
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
 


