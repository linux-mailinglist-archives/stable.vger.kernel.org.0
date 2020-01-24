Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 791F0147AC6
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbgAXJho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:37:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:35076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729719AbgAXJhn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:37:43 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A575120838;
        Fri, 24 Jan 2020 09:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858663;
        bh=X0f4cxM6Ak9BE9aW1xSwdIbJRjIDPBgKED8Hw+uIT5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdOFheO93hnlSfxf2frDzRchIrscjm2w3D2pI2QSfCmiAq7xyGbvc17uw4AH0vUJT
         y0KZC+VcC5QVk+ttzOAY7TsxzWNt+hbL0EkGyKZ2kiVyuFG0VvE5oz6OklGdEiTuXT
         NWR+BCIoHtGNwVZDH1g7TrpbzWQBUEhmIg/PTVHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alain Volmat <alain.volmat@st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@st.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 4.19 004/639] i2c: i2c-stm32f7: fix 10-bits check in slave free id search loop
Date:   Fri, 24 Jan 2020 10:22:54 +0100
Message-Id: <20200124093047.633397596@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alain Volmat <alain.volmat@st.com>

commit 7787657d7ee55a9ecf4aea4907b46b87a44eda67 upstream.

Fix a typo in the free slave id search loop. Instead of I2C_CLIENT_PEC,
it should have been I2C_CLIENT_TEN. The slave id 1 can only handle 7-bit
addresses and thus is not eligible in case of 10-bit addresses.
As a matter of fact none of the slave id support I2C_CLIENT_PEC, overall
check is performed at the beginning of the stm32f7_i2c_reg_slave function.

Fixes: 60d609f30de2 ("i2c: i2c-stm32f7: Add slave support")
Signed-off-by: Alain Volmat <alain.volmat@st.com>
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-stm32f7.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -1253,7 +1253,7 @@ static int stm32f7_i2c_get_free_slave_id
 	 * slave[1] supports 7-bit slave address only
 	 */
 	for (i = STM32F7_I2C_MAX_SLAVE - 1; i >= 0; i--) {
-		if (i == 1 && (slave->flags & I2C_CLIENT_PEC))
+		if (i == 1 && (slave->flags & I2C_CLIENT_TEN))
 			continue;
 		if (!i2c_dev->slave[i]) {
 			*id = i;


