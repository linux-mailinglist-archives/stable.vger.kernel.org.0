Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F28E1126C08
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfLSTBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:45752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728279AbfLSSva (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:51:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 703832064B;
        Thu, 19 Dec 2019 18:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781488;
        bh=gx1f6UecOc57In9eyhc/iqzYZc5hHEWeXlAOfJltopU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H+h1kYsy5P/fwKd2rNpy3pX+D4tHGL0GGTYLdblp98LowXjFwx9uanM/DePCrC8Xu
         hRJjR1aYKIEUP6kixrCjZRvJCdVo2DNGSYrom/c4qcCnm0O7z7bqhWzu6/3MgEs+pk
         0tdC0LaWCqAR3LbJNfnbwp2rG9FEgFS/FW0UQoGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 4.14 21/36] rpmsg: glink: Fix use after free in open_ack TIMEOUT case
Date:   Thu, 19 Dec 2019 19:34:38 +0100
Message-Id: <20191219182911.992885069@linuxfoundation.org>
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

From: Arun Kumar Neelakantam <aneela@codeaurora.org>

commit ac74ea01860170699fb3b6ea80c0476774c8e94f upstream.

Extra channel reference put when remote sending OPEN_ACK after timeout
causes use-after-free while handling next remote CLOSE command.

Remove extra reference put in timeout case to avoid use-after-free.

Fixes: b4f8e52b89f6 ("rpmsg: Introduce Qualcomm RPM glink driver")
Cc: stable@vger.kernel.org
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rpmsg/qcom_glink_native.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1104,13 +1104,12 @@ static int qcom_glink_create_remote(stru
 close_link:
 	/*
 	 * Send a close request to "undo" our open-ack. The close-ack will
-	 * release the last reference.
+	 * release qcom_glink_send_open_req() reference and the last reference
+	 * will be relesed after receiving remote_close or transport unregister
+	 * by calling qcom_glink_native_remove().
 	 */
 	qcom_glink_send_close_req(glink, channel);
 
-	/* Release qcom_glink_send_open_req() reference */
-	kref_put(&channel->refcount, qcom_glink_channel_release);
-
 	return ret;
 }
 


