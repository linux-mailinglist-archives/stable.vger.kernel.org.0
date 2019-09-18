Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98448B68DB
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 19:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732100AbfIRRTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 13:19:23 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39131 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732099AbfIRRTX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 13:19:23 -0400
Received: by mail-pg1-f195.google.com with SMTP id u17so219208pgi.6
        for <stable@vger.kernel.org>; Wed, 18 Sep 2019 10:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j0roT+o44pSB3MM7mlqj6crjaHtjbvUFCdPy0FOZOMU=;
        b=O4JEUjWNfJnoTHf3Kz89DjXTVO8W5+rzHM+ls2mRU28W2FV8b8nZpi6L4cqrkJ3F9M
         YNXjD36ZsIeuhFahMECAXywua8oqYrxpt1YatcxAwxFJK9o8yNXSuTbqI2vXKYbh9p6N
         m6cO55tIKUoEWfQv6zUtFnHHhSEaHEkcJ9GU5jj8LdOugJZpZqqSyw4shaBwj57pe2vE
         d4kyc4biEk89OMh2r0LCFn+HzKVVH0MLLffXz+uCuT8rhq7ATBdYujE5awZYqY1PKdfZ
         ZdaThZ6464sjkSOeHGmwdi2hbFJGRoV9AsQs0ByhiPZzcpKm6rrL7HIXmoiFAxGyDUqs
         bklQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j0roT+o44pSB3MM7mlqj6crjaHtjbvUFCdPy0FOZOMU=;
        b=jJMkOefPGwNBMakgSBT06K4BJuWVcRJ1jdKNeyWmm0e5dx+1nhTjXUn1jloyPkg6yU
         Op+NXUZjFqkHL15aGQdu/TWMXbCvY995wqpbFDU7MoSms6hlZhOKtcMH0y5Vodb0RJGa
         zdTvSA74PgcXH730pMF+WiM3xIPvbcteIyZX3vShd6UjWxPNsgtd83wod8O5VH3OnjQu
         G/LB5jLUM1qQRwbFJTLIBmpDXVsYpOxEgAlCHpNxAsEHYxmEYjsIoP3Hp0M9BDz4KWeX
         Ggb2+/ioDUv0FSR0KQS4j6wrmsW6Di5HzperWq2xj+GLuGqc/f84KLcjLD0mcZimnkbB
         i2/Q==
X-Gm-Message-State: APjAAAUyKzH1LsW+wF3I3/XviuTQTtqiIT7F4DcOq9saHUyGig8iSU+M
        mHTWG59ruaJYo3Hk/JB7xqzGKQ==
X-Google-Smtp-Source: APXvYqwVomWFERAJsR0i2p38N1YgsQl9AebCgv0yamF8m+dfqfnKfuGtvgkfx1j4kW4Dvf22Wl7mrQ==
X-Received: by 2002:aa7:9216:: with SMTP id 22mr5574508pfo.214.1568827162439;
        Wed, 18 Sep 2019 10:19:22 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id y4sm2614981pjn.19.2019.09.18.10.19.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Sep 2019 10:19:21 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Jorge Ramirez <jorge.ramirez-ortiz@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 2/6] rpmsg: glink: Fix use after free in open_ack TIMEOUT case
Date:   Wed, 18 Sep 2019 10:19:12 -0700
Message-Id: <20190918171916.4039-3-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190918171916.4039-1-bjorn.andersson@linaro.org>
References: <20190918171916.4039-1-bjorn.andersson@linaro.org>
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
Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
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

