Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B4711F7E2
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 14:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfLONG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 08:06:57 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48893 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726103AbfLONG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 08:06:57 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8CE2F22359;
        Sun, 15 Dec 2019 08:06:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 08:06:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Z4Ep4m
        MOSWJ9Mi3l5Q7bOqTO8K9k5nWGBVd/mMs0/zs=; b=YFX8JJNO6GCKjhtpcZfP7p
        5RG3NOuFWE3Nh5dyoQTXWn8CIMJXT/YGB4YSHBQcug/7l4P6MuhAl2ZoNZVmogV3
        QsY3ye1KKTuvEN2jxVO6o40CLuHkV5rAWxXW6gLJmCyPLM+JA58bmKVCnX/0o/6x
        56zhPjIFP0RNHxv8Q1Ebujjm5lqffBVpLzCQPGtH6ueecnY7Qn2Dm1UYakZ4AMpD
        Z4qxvOyMFV8XBi7ADRpJm8iriEjw3qHM4Vy0bioupdXuattvQ1aYfnw0R3R4TU/L
        aSxGFOdqaWiR4oPjZO9Wv3XH7Smr0pQpPOVpa3ZcZWAa5OmiSEZcs7dcVfqcO2DQ
        ==
X-ME-Sender: <xms:7y_2XTDFncQlr_XA6ynRmFkdZoHvNUsn_id5GLT7pdaiL64U_9iufA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:7y_2XXD4g1gUCoXe7GBvRwfdIcUr33bSyLwfAKCbOypoEImbQ-vQwQ>
    <xmx:7y_2XRNbawaPbXTqbN9eX284UGRrEaQmanUXmp3FBl6R6X4VnIq9eg>
    <xmx:7y_2XbMmhGZD2T1lLutToES-64UaRfp8pac7NE7Nxh5FokYt3dmSCA>
    <xmx:8C_2XVbJHrHQceE-Z1xvtZtZd1o6hkqQGXT7aWt7aZxxB7V7xfiHkA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 680818005A;
        Sun, 15 Dec 2019 08:06:55 -0500 (EST)
Subject: FAILED: patch "[PATCH] PM / devfreq: Lock devfreq in trans_stat_show" failed to apply to 4.4-stable tree
To:     leonard.crestez@nxp.com, cw00.choi@samsung.com, mka@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 14:06:52 +0100
Message-ID: <15764152128201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2abb0d5268ae7b5ddf82099b1f8d5aa8414637d4 Mon Sep 17 00:00:00 2001
From: Leonard Crestez <leonard.crestez@nxp.com>
Date: Tue, 24 Sep 2019 10:52:23 +0300
Subject: [PATCH] PM / devfreq: Lock devfreq in trans_stat_show

There is no locking in this sysfs show function so stats printing can
race with a devfreq_update_status called as part of freq switching or
with initialization.

Also add an assert in devfreq_update_status to make it clear that lock
must be held by caller.

Fixes: 39688ce6facd ("PM / devfreq: account suspend/resume for stats")
Cc: stable@vger.kernel.org
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 60859a2400bc..d6c3dce9e9d5 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -160,6 +160,7 @@ int devfreq_update_status(struct devfreq *devfreq, unsigned long freq)
 	int lev, prev_lev, ret = 0;
 	unsigned long cur_time;
 
+	lockdep_assert_held(&devfreq->lock);
 	cur_time = jiffies;
 
 	/* Immediately exit if previous_freq is not initialized yet. */
@@ -1397,12 +1398,17 @@ static ssize_t trans_stat_show(struct device *dev,
 	int i, j;
 	unsigned int max_state = devfreq->profile->max_state;
 
-	if (!devfreq->stop_polling &&
-			devfreq_update_status(devfreq, devfreq->previous_freq))
-		return 0;
 	if (max_state == 0)
 		return sprintf(buf, "Not Supported.\n");
 
+	mutex_lock(&devfreq->lock);
+	if (!devfreq->stop_polling &&
+			devfreq_update_status(devfreq, devfreq->previous_freq)) {
+		mutex_unlock(&devfreq->lock);
+		return 0;
+	}
+	mutex_unlock(&devfreq->lock);
+
 	len = sprintf(buf, "     From  :   To\n");
 	len += sprintf(buf + len, "           :");
 	for (i = 0; i < max_state; i++)

