Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0924F2541
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiDEHsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiDEHr4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79DA9157F;
        Tue,  5 Apr 2022 00:45:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75D24616BF;
        Tue,  5 Apr 2022 07:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9A5C3410F;
        Tue,  5 Apr 2022 07:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144702;
        bh=fHq6yezaEyDiwaMdcaDnIeQNeAFcl0kVKFCgE+Qc/VU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbGliJVy/kl3SLR/mq0y0GJB2oS4MwN0ZWElHtbAKz0Vg/ezAsERI+b47RqK481O9
         wpO77pq+J/sfLQwHJAGyg/KyRXWeAj6gUCXzjvbTnNovHTrn7/Pd3ZLiWr3TWxDIap
         cJMMFbubFzjsjw2sHYHjcROgOwDevZjYjo2WOCBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ali Pouladi <quic_apouladi@quicinc.com>,
        Elliot Berman <quic_eberman@quicinc.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.17 0101/1126] rtc: pl031: fix rtc features null pointer dereference
Date:   Tue,  5 Apr 2022 09:14:08 +0200
Message-Id: <20220405070410.533878006@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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


