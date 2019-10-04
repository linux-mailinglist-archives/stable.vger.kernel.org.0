Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B4ACC5CF
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 00:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388148AbfJDW1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 18:27:13 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43716 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388037AbfJDW1M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 18:27:12 -0400
Received: by mail-pg1-f193.google.com with SMTP id v27so4511969pgk.10
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 15:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QoZQF1YbSGqv09dK0KDHECoZ26zQGdAXMaDDkqK/sak=;
        b=N1pFmJEh2KW227rJpCbD4242buzzbOIiY6ERrMQ9gsicebzcXfJT8NECywRZ0N5/si
         Tgj4n3z6k0mSjwaGIY0Sb9m/zLKF/BcICGuTagr4Zg+Au/njphRbjvNov33jKsA/Vf7Q
         WJF7/x1LoGppiW4Sq9F1hFhlPoIgmJwkPdEhKkhquJh7jCC02RvlcZ/+T+2suX+sWsQ8
         0Q8AeMHZ0ScKasmjlFy/MbZh+z5Sjc/tD3uKcmfU+yPdrkHQHmMgRhn7Z+AutgO8kms7
         M657x4K//+keOT+lxrB83va5DmkQtIz+fN8gUJr1lTqf+wsnRlzemkuwmS866ClQ9M6O
         2XDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QoZQF1YbSGqv09dK0KDHECoZ26zQGdAXMaDDkqK/sak=;
        b=NneLkDR+rBs9icb20247HYjlEMttyuaNkkIeXiwymM5tiuirQx5VyLf4fvPp+5jiv1
         D5eIJ7XmGq2fG6YNAmvxngOyFHTpwXgiWAFzziyk7sRrUZifXxqXm1ackvRb4bNNKsXQ
         jPHQGa6ac0ZWgBZ2ltRKgWbj1TUtK9PPB4hKZF1QSwveK0iiNdeUNMjLkZvMIEuB2ErQ
         KtjxRiAQQpmF/GmGnpnkozpjf4cQigIjqGcegwL3Xk8w2Omdnzfm24iiKsKVDPcRDic/
         NXgZLsY7c4WvG7Wfpgp8JjytzgIVcQW191nMZLzpMCV1CkuQCJXCmHX5pjme+lXzA/ij
         jy8A==
X-Gm-Message-State: APjAAAXyMxn2/amSvyL5IylwhRECnr/zAghghA2YxjAjU5uCztIJwTy6
        dw7OTvHH+3ur+S3nyTuCO0Y+7g==
X-Google-Smtp-Source: APXvYqx4xJ8Wtupkhwv6dK4c8+ZLjIxa9GbmQKmw3sJuGnsohr/0eA2ZNw37OxsBRy7204cKjdQ11w==
X-Received: by 2002:a63:1420:: with SMTP id u32mr2589745pgl.62.1570228031137;
        Fri, 04 Oct 2019 15:27:11 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id x37sm6328136pgl.18.2019.10.04.15.27.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 15:27:10 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 2/6] rpmsg: glink: Fix use after free in open_ack TIMEOUT case
Date:   Fri,  4 Oct 2019 15:26:58 -0700
Message-Id: <20191004222702.8632-3-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191004222702.8632-1-bjorn.andersson@linaro.org>
References: <20191004222702.8632-1-bjorn.andersson@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arun Kumar Neelakantam <aneela@codeaurora.org>

Extra channel reference put when remote sending OPEN_ACK after timeout
causes use-after-free while handling next remote CLOSE command.

Remove extra reference put in timeout case to avoid use-after-free.

Fixes: b4f8e52b89f6 ("rpmsg: Introduce Qualcomm RPM glink driver")
Cc: stable@vger.kernel.org
Tested-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v1:
- None

 drivers/rpmsg/qcom_glink_native.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 9355ce26fd98..72ed671f5dcd 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1103,13 +1103,12 @@ static int qcom_glink_create_remote(struct qcom_glink *glink,
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
 
-- 
2.18.0

