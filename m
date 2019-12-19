Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE00126CF3
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbfLSSnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:43:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:34590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728789AbfLSSnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:43:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5593424672;
        Thu, 19 Dec 2019 18:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780984;
        bh=YitMJak+QJ5u7f/nA4YofkormATrSvmkfaTtgbRZJzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFlLftY5L4Zu1kmeTat91RME+tx5kkJrs+HfsITJu++qm6LedavhbimGex6CSUsdk
         FpDilJOc2dmSvWpagTNoey+Qi1DRKEi1jwRAX5UGu4MNZYeyipGV/ru3KHdgWMmCo8
         JC1Qha9Nl2XYuVtVAmHfhBz4cZsC1yezFYJKMm98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 034/199] rtc: max8997: Fix the returned value in case of error in max8997_rtc_read_alarm()
Date:   Thu, 19 Dec 2019 19:31:56 +0100
Message-Id: <20191219183216.791262015@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 41ef3878203cd9218d92eaa07df4b85a2cb128fb ]

In case of error, we return 0.
This is spurious and not consistent with the other functions of the driver.
Propagate the error code instead.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-max8997.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
index db984d4bf9526..4cce5bd448f65 100644
--- a/drivers/rtc/rtc-max8997.c
+++ b/drivers/rtc/rtc-max8997.c
@@ -221,7 +221,7 @@ static int max8997_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 out:
 	mutex_unlock(&info->lock);
-	return 0;
+	return ret;
 }
 
 static int max8997_rtc_stop_alarm(struct max8997_rtc_info *info)
-- 
2.20.1



