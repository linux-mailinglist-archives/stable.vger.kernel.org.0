Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 410AD10BABC
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731136AbfK0VGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:06:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:59934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731434AbfK0VGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:06:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D497620637;
        Wed, 27 Nov 2019 21:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888761;
        bh=57A37uReFpaoVHM91/3bIBAXphIRLjuVkZlIK30VGwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yPrd/ysb9EteZ+L2F1/MCrTeBTmWSG5OC4X81U6fz7sVLkvcTGRmkEnccITM81n0t
         e8K62UeQQYrokNbwWMWS+62jB8XN0jpeVGzuycoeTyH+tldrDsPm0sBtnZBhCRGenr
         w3LsKH+GwBqqIeacgNs1300xh8FjRlypslLaq+Y8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Denis Efremov <efremov@linux.com>
Subject: [PATCH 4.19 259/306] ath9k_hw: fix uninitialized variable data
Date:   Wed, 27 Nov 2019 21:31:49 +0100
Message-Id: <20191127203133.761466019@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
@@ -4183,7 +4183,7 @@ static void ar9003_hw_thermometer_apply(
 
 static void ar9003_hw_thermo_cal_apply(struct ath_hw *ah)
 {
-	u32 data, ko, kg;
+	u32 data = 0, ko, kg;
 
 	if (!AR_SREV_9462_20_OR_LATER(ah))
 		return;


