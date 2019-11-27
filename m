Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D2010BEBB
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbfK0Uph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:45:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729760AbfK0Upg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:45:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 696D721741;
        Wed, 27 Nov 2019 20:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887535;
        bh=qt2ZaBJBkqKDo6O0kCiyXnG1cMLezHLkJkx66ql/bfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ge01y1Q+6ZkgB+AfVwvuwJXuHC7Mhy7GPqJL+o2J94niNCOwij27DtVc6Wag7auYZ
         c8RpIo287r2d/rUzkHPkPfiKCGkLwLXTNHNb9R/K3ZDkjXgAs9f1yqT3YxagLUgbTO
         OHlFJLplPd1nsPXx9Gl1mcMblH8+ZX2GCYBm907o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Denis Efremov <efremov@linux.com>
Subject: [PATCH 4.9 112/151] ath9k_hw: fix uninitialized variable data
Date:   Wed, 27 Nov 2019 21:31:35 +0100
Message-Id: <20191127203043.201695755@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

commit 80e84f36412e0c5172447b6947068dca0d04ee82 upstream.

Currently, data variable in ar9003_hw_thermo_cal_apply() could be
uninitialized if ar9300_otp_read_word() will fail to read the value.
Initialize data variable with 0 to prevent an undefined behavior. This
will be enough to handle error case when ar9300_otp_read_word() fails.

Fixes: 80fe43f2bbd5 ("ath9k_hw: Read and configure thermocal for AR9462")
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -4115,7 +4115,7 @@ static void ar9003_hw_thermometer_apply(
 
 static void ar9003_hw_thermo_cal_apply(struct ath_hw *ah)
 {
-	u32 data, ko, kg;
+	u32 data = 0, ko, kg;
 
 	if (!AR_SREV_9462_20_OR_LATER(ah))
 		return;


