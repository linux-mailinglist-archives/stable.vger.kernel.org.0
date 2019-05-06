Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43F9B14DB2
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfEFOy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729181AbfEFOqj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:46:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 634562087F;
        Mon,  6 May 2019 14:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153998;
        bh=7DB5M/yAEt62ek0olJSonmJ4G2XFT7l4b658CUTrFHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CDgtnxKRaq8h2E67cdGvZzjYWqIAXKkzqWVLp9D83rqSzqz/UN0RXyaAlSBXwqG8N
         C0hIx5GY9y2u0oxvPq2hSr45lHAukJIPna0e7nHBk/1UWM9n+FMMjeff7NWM09revi
         vUvK+bDEENnRqtuZI0DKV8CDWPwdE/Dzi/8YD+lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Le Bayon <nicolas.le.bayon@st.com>,
        Bich Hemon <bich.hemon@st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@st.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 4.14 74/75] i2c: i2c-stm32f7: Fix SDADEL minimum formula
Date:   Mon,  6 May 2019 16:33:22 +0200
Message-Id: <20190506143100.045349603@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Le Bayon <nicolas.le.bayon@st.com>

commit c86da50cfd840edf223a242580913692acddbcf6 upstream.

It conforms with Reference Manual I2C timing section.

Fixes: aeb068c57214 ("i2c: i2c-stm32f7: add driver")
Signed-off-by: Nicolas Le Bayon <nicolas.le.bayon@st.com>
Signed-off-by: Bich Hemon <bich.hemon@st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-stm32f7.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -340,7 +340,7 @@ static int stm32f7_i2c_compute_timing(st
 		 STM32F7_I2C_ANALOG_FILTER_DELAY_MAX : 0);
 	dnf_delay = setup->dnf * i2cclk;
 
-	sdadel_min = setup->fall_time - i2c_specs[setup->speed].hddat_min -
+	sdadel_min = i2c_specs[setup->speed].hddat_min + setup->fall_time -
 		af_delay_min - (setup->dnf + 3) * i2cclk;
 
 	sdadel_max = i2c_specs[setup->speed].vddat_max - setup->rise_time -


