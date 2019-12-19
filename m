Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B898D126AC4
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbfLSSup (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:50:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbfLSSul (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:50:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4BD924679;
        Thu, 19 Dec 2019 18:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781440;
        bh=6MqNxT771e5iNqvtYepu1DYQ5t3AO30nbKy/IdKyuVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akfw13M4GvimURxnmBD0Z4KwZYcU9tLn2fQn5WhBgRckbkiPEgG5A0WML6a5iT92K
         Q5B8YB6MjwVL0vE4fkn4yxnIA9on/ZmOJnpIYidxX+ez8P14bzO/Gd7MirbvUuQ/i1
         kPRsNexJ8IWqNpJC0olUr9jbj4PCtBQQ5HjJIRXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Chris Lew <clew@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 4.14 23/36] rpmsg: glink: Fix rpmsg_register_device err handling
Date:   Thu, 19 Dec 2019 19:34:40 +0100
Message-Id: <20191219182913.664143063@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219182848.708141124@linuxfoundation.org>
References: <20191219182848.708141124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Lew <clew@codeaurora.org>

commit f7e714988edaffe6ac578318e99501149b067ba0 upstream.

The device release function is set before registering with rpmsg. If
rpmsg registration fails, the framework will call device_put(), which
invokes the release function. The channel create logic does not need to
free rpdev if rpmsg_register_device() fails and release is called.

Fixes: b4f8e52b89f6 ("rpmsg: Introduce Qualcomm RPM glink driver")
Cc: stable@vger.kernel.org
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Chris Lew <clew@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rpmsg/qcom_glink_native.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1400,15 +1400,13 @@ static int qcom_glink_rx_open(struct qco
 
 		ret = rpmsg_register_device(rpdev);
 		if (ret)
-			goto free_rpdev;
+			goto rcid_remove;
 
 		channel->rpdev = rpdev;
 	}
 
 	return 0;
 
-free_rpdev:
-	kfree(rpdev);
 rcid_remove:
 	spin_lock_irqsave(&glink->idr_lock, flags);
 	idr_remove(&glink->rcids, channel->rcid);


