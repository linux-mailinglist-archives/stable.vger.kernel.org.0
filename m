Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B909115C1A1
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgBMPY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:24:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728861AbgBMPY4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:56 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBEED246B3;
        Thu, 13 Feb 2020 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607496;
        bh=FYWV3E0itvXOBUSA3WBPSQUl2JEx0E9gY563Ml6bPOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bzq3jSX1DuaBQUUTNt5apoUCeDiwAVVLJhVDeB4PjQ07hphZEDuiCZMoiROC0vsqr
         xUATLNtBsAPW3KvbP5ESRj6LXcowJUlpVv4JpAiuy3YOzlv2WEGoy2k43vYX9O9B3C
         YMGcTp4h55nKx6QYaiZ8UoQYfuebIplriMFxXBrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Van Asbroeck <TheSven73@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.14 048/173] power: supply: ltc2941-battery-gauge: fix use-after-free
Date:   Thu, 13 Feb 2020 07:19:11 -0800
Message-Id: <20200213151946.117730255@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

commit a60ec78d306c6548d4adbc7918b587a723c555cc upstream.

This driver's remove path calls cancel_delayed_work().
However, that function does not wait until the work function
finishes. This could mean that the work function is still
running after the driver's remove function has finished,
which would result in a use-after-free.

Fix by calling cancel_delayed_work_sync(), which ensures that
that the work is properly cancelled, no longer running, and
unable to re-schedule itself.

This issue was detected with the help of Coccinelle.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Sven Van Asbroeck <TheSven73@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/supply/ltc2941-battery-gauge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/ltc2941-battery-gauge.c
+++ b/drivers/power/supply/ltc2941-battery-gauge.c
@@ -406,7 +406,7 @@ static int ltc294x_i2c_remove(struct i2c
 {
 	struct ltc294x_info *info = i2c_get_clientdata(client);
 
-	cancel_delayed_work(&info->work);
+	cancel_delayed_work_sync(&info->work);
 	power_supply_unregister(info->supply);
 	return 0;
 }


