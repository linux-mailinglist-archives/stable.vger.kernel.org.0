Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C232268BE
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387464AbgGTQLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733100AbgGTQLQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:11:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2625F2065E;
        Mon, 20 Jul 2020 16:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261475;
        bh=PORYz7Wbze4EhD0RcXJzdnktzYcKspJ3cuEg6I8qGx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LFVyZRmINIpI53TF1UrxRNdI1Fj1R6fYeGOaWBh1GSuf6lZYcaLMTJTwZCHmQ8Ccn
         L4Om5KnMQuAtk/8eiOrF3mwOCsDZCkaVeq0VtMLClvE26b0kA0qLaOD0Cr6iNoT786
         yNdGpmsP6khGD06m/jV1LY8IpmBJm3SaQUmzSp5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maulik Shah <mkshah@codeaurora.org>,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.7 129/244] soc: qcom: rpmh-rsc: Allow using free WAKE TCS for active request
Date:   Mon, 20 Jul 2020 17:36:40 +0200
Message-Id: <20200720152831.975115957@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maulik Shah <mkshah@codeaurora.org>

commit 38427e5a47bf83299da930bd474c6cb2632ad810 upstream.

When there are more than one WAKE TCS available and there is no dedicated
ACTIVE TCS available, invalidating all WAKE TCSes and waiting for current
transfer to complete in first WAKE TCS blocks using another free WAKE TCS
to complete current request.

Remove rpmh_rsc_invalidate() to happen from tcs_write() when WAKE TCSes
is re-purposed to be used for Active mode. Clear only currently used
WAKE TCS's register configuration.

Fixes: 2de4b8d33eab (drivers: qcom: rpmh-rsc: allow active requests from wake TCS)
Signed-off-by: Maulik Shah <mkshah@codeaurora.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/1586703004-13674-7-git-send-email-mkshah@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/soc/qcom/rpmh-rsc.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/soc/qcom/rpmh-rsc.c
+++ b/drivers/soc/qcom/rpmh-rsc.c
@@ -148,7 +148,7 @@ int rpmh_rsc_invalidate(struct rsc_drv *
 static struct tcs_group *get_tcs_for_msg(struct rsc_drv *drv,
 					 const struct tcs_request *msg)
 {
-	int type, ret;
+	int type;
 	struct tcs_group *tcs;
 
 	switch (msg->state) {
@@ -169,19 +169,10 @@ static struct tcs_group *get_tcs_for_msg
 	 * If we are making an active request on a RSC that does not have a
 	 * dedicated TCS for active state use, then re-purpose a wake TCS to
 	 * send active votes.
-	 * NOTE: The driver must be aware that this RSC does not have a
-	 * dedicated AMC, and therefore would invalidate the sleep and wake
-	 * TCSes before making an active state request.
 	 */
 	tcs = get_tcs_of_type(drv, type);
-	if (msg->state == RPMH_ACTIVE_ONLY_STATE && !tcs->num_tcs) {
+	if (msg->state == RPMH_ACTIVE_ONLY_STATE && !tcs->num_tcs)
 		tcs = get_tcs_of_type(drv, WAKE_TCS);
-		if (tcs->num_tcs) {
-			ret = rpmh_rsc_invalidate(drv);
-			if (ret)
-				return ERR_PTR(ret);
-		}
-	}
 
 	return tcs;
 }
@@ -406,8 +397,16 @@ static int tcs_write(struct rsc_drv *drv
 
 	tcs->req[tcs_id - tcs->offset] = msg;
 	set_bit(tcs_id, drv->tcs_in_use);
-	if (msg->state == RPMH_ACTIVE_ONLY_STATE && tcs->type != ACTIVE_TCS)
+	if (msg->state == RPMH_ACTIVE_ONLY_STATE && tcs->type != ACTIVE_TCS) {
+		/*
+		 * Clear previously programmed WAKE commands in selected
+		 * repurposed TCS to avoid triggering them. tcs->slots will be
+		 * cleaned from rpmh_flush() by invoking rpmh_rsc_invalidate()
+		 */
+		write_tcs_reg_sync(drv, RSC_DRV_CMD_ENABLE, tcs_id, 0);
+		write_tcs_reg_sync(drv, RSC_DRV_CMD_WAIT_FOR_CMPL, tcs_id, 0);
 		enable_tcs_irq(drv, tcs_id, true);
+	}
 	spin_unlock(&drv->lock);
 
 	__tcs_buffer_write(drv, tcs_id, 0, msg);


