Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF67FA913B
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389518AbfIDSOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390752AbfIDSOP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:14:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33793206BA;
        Wed,  4 Sep 2019 18:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620854;
        bh=sFWfSdZjLyw3QtnBRJOz2vd4Sd60c1HBghFT87T7+/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUaG/yb+LCSFFmCywJ/B59E88irXVRnqcLusKi7iAjWLEBbO3qthLPSkYHBF0wuX7
         LtmjBlftlh1z7e25pU5xi7fO/hW/ikhiQSFGdLj8aDpA9LrEh0ebV4sh6PQ23YFqgo
         i7hKxi0V5vJBKd0yy+BvcmmWrjOgS0upDSS3HjcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.2 120/143] mt76: mt76x0u: do not reset radio on resume
Date:   Wed,  4 Sep 2019 19:54:23 +0200
Message-Id: <20190904175319.092622870@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 8f2d163cb26da87e7d8e1677368b8ba1ba4d30b3 upstream.

On some machines mt76x0u firmware can hung during resume,
what result on messages like below:

[  475.480062] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  475.990066] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
[  475.990075] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  476.500003] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
[  476.500012] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  477.010046] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
[  477.010055] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  477.529997] mt76x0 1-8:1.0: Error: send MCU cmd failed:-110
[  477.530006] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  477.824907] mt76x0 1-8:1.0: Error: send MCU cmd failed:-71
[  477.824916] mt76x0 1-8:1.0: Error: MCU response pre-completed!
[  477.825029] usb 1-8: USB disconnect, device number 6

and possible whole system freeze.

This can be avoided, if we do not perform mt76x0_chip_onoff() reset.

Cc: stable@vger.kernel.org
Fixes: 134b2d0d1fcf ("mt76x0: init files")
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -136,11 +136,11 @@ static const struct ieee80211_ops mt76x0
 	.release_buffered_frames = mt76_release_buffered_frames,
 };
 
-static int mt76x0u_init_hardware(struct mt76x02_dev *dev)
+static int mt76x0u_init_hardware(struct mt76x02_dev *dev, bool reset)
 {
 	int err;
 
-	mt76x0_chip_onoff(dev, true, true);
+	mt76x0_chip_onoff(dev, true, reset);
 
 	if (!mt76x02_wait_for_mac(&dev->mt76))
 		return -ETIMEDOUT;
@@ -173,7 +173,7 @@ static int mt76x0u_register_device(struc
 	if (err < 0)
 		goto out_err;
 
-	err = mt76x0u_init_hardware(dev);
+	err = mt76x0u_init_hardware(dev, true);
 	if (err < 0)
 		goto out_err;
 
@@ -309,7 +309,7 @@ static int __maybe_unused mt76x0_resume(
 	if (ret < 0)
 		goto err;
 
-	ret = mt76x0u_init_hardware(dev);
+	ret = mt76x0u_init_hardware(dev, false);
 	if (ret)
 		goto err;
 


