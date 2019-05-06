Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E89F14EC7
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfEFPFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 11:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727669AbfEFOip (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:38:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 240F8214AF;
        Mon,  6 May 2019 14:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153524;
        bh=W5TbTrb9af3rDY6Npt3MT/GnE4ifQf79SZVKzKzGJO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+Mi31suHjVEiiEsm2Vq4S5ilXJMPuVCn6QJal+ovQ+42FnWpRvlKzMfGM1VE6LQ5
         dl6UlXqmqJAdvo7ZS+u54oBc1zkC2Mbd8tRNVMjHUC+bvyKCNccMWYrFDKWW3Ct7gC
         wzO+hR2p4rmsZRmQFV7a/4v71SPodKTLIsPsZ6ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Le Bayon <nicolas.le.bayon@st.com>,
        Bich Hemon <bich.hemon@st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@st.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.0 121/122] i2c: i2c-stm32f7: Fix SDADEL minimum formula
Date:   Mon,  6 May 2019 16:32:59 +0200
Message-Id: <20190506143105.168874070@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
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
@@ -432,7 +432,7 @@ static int stm32f7_i2c_compute_timing(st
 		 STM32F7_I2C_ANALOG_FILTER_DELAY_MAX : 0);
 	dnf_delay = setup->dnf * i2cclk;
 
-	sdadel_min = setup->fall_time - i2c_specs[setup->speed].hddat_min -
+	sdadel_min = i2c_specs[setup->speed].hddat_min + setup->fall_time -
 		af_delay_min - (setup->dnf + 3) * i2cclk;
 
 	sdadel_max = i2c_specs[setup->speed].vddat_max - setup->rise_time -


