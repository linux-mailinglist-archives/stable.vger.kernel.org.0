Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 685D710B96C
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbfK0Uw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:41072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730668AbfK0Uw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:52:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 954B9218DE;
        Wed, 27 Nov 2019 20:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887978;
        bh=4jRCHwt9FzNoPULeqAk5ypyYV4J5S/YfCSXAZc9W2f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrfVGf09AiAinA4jQJhOMCu+MZIrWj3n4MtEYujK0CVLL6n9yrDD3+tiGt0a6AC6I
         2dtcPhaIamqkgHlImAD50+OselyNIIk/3RLulFIVtOqdWd027Eqnk8uPdtrvtsvw5X
         ipDDLI8BDfrwTdAV5P465sJG7cXkr0qEUY8jL/Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Denis Efremov <efremov@linux.com>
Subject: [PATCH 4.14 167/211] ath9k_hw: fix uninitialized variable data
Date:   Wed, 27 Nov 2019 21:31:40 +0100
Message-Id: <20191127203109.660466493@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
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
@@ -4116,7 +4116,7 @@ static void ar9003_hw_thermometer_apply(
 
 static void ar9003_hw_thermo_cal_apply(struct ath_hw *ah)
 {
-	u32 data, ko, kg;
+	u32 data = 0, ko, kg;
 
 	if (!AR_SREV_9462_20_OR_LATER(ah))
 		return;


