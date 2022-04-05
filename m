Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB9A4F2CE2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbiDEJCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239020AbiDEIoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:44:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDC6201A7;
        Tue,  5 Apr 2022 01:36:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DE22B81A32;
        Tue,  5 Apr 2022 08:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FB6C385A2;
        Tue,  5 Apr 2022 08:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147758;
        bh=fHq6yezaEyDiwaMdcaDnIeQNeAFcl0kVKFCgE+Qc/VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fy3bGpCSwjxHbX9FwFlqyqXgdEGAaARkzXAzDKPCNG+vIV7dMQk8RjhgFrmZWuPlz
         Oyh/c1+i1+IOxojFm6uHtc8WF2HwrDmH6VVFumsr8KtJxEQ/jOTW5jIwVKE91+3U4n
         H0tLMQeFa9GhT8i9DOmpKcb2Cc6909lzMpZ1FpQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ali Pouladi <quic_apouladi@quicinc.com>,
        Elliot Berman <quic_eberman@quicinc.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.16 0109/1017] rtc: pl031: fix rtc features null pointer dereference
Date:   Tue,  5 Apr 2022 09:17:02 +0200
Message-Id: <20220405070357.432300746@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ali Pouladi <quic_apouladi@quicinc.com>

commit ea6af39f3da50c86367a71eb3cc674ade3ed244c upstream.

When there is no interrupt line, rtc alarm feature is disabled.

The clearing of the alarm feature bit was being done prior to allocations
of ldata->rtc device, resulting in a null pointer dereference.

Clear RTC_FEATURE_ALARM after the rtc device is allocated.

Fixes: d9b0dd54a194 ("rtc: pl031: use RTC_FEATURE_ALARM")
Cc: stable@vger.kernel.org
Signed-off-by: Ali Pouladi <quic_apouladi@quicinc.com>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20220225161924.274141-1-quic_eberman@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-pl031.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -350,9 +350,6 @@ static int pl031_probe(struct amba_devic
 		}
 	}
 
-	if (!adev->irq[0])
-		clear_bit(RTC_FEATURE_ALARM, ldata->rtc->features);
-
 	device_init_wakeup(&adev->dev, true);
 	ldata->rtc = devm_rtc_allocate_device(&adev->dev);
 	if (IS_ERR(ldata->rtc)) {
@@ -360,6 +357,9 @@ static int pl031_probe(struct amba_devic
 		goto out;
 	}
 
+	if (!adev->irq[0])
+		clear_bit(RTC_FEATURE_ALARM, ldata->rtc->features);
+
 	ldata->rtc->ops = ops;
 	ldata->rtc->range_min = vendor->range_min;
 	ldata->rtc->range_max = vendor->range_max;


