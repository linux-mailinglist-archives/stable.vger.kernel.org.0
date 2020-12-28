Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277C82E3F54
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392308AbgL1Oip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:38:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:39652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390383AbgL1Obn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B02702063A;
        Mon, 28 Dec 2020 14:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165888;
        bh=mHnbGPAl7oQQAM2WMBXqXFUVy/YH317CVojGgq9XwiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tHR+4R4A6h8btQcrogw2eg2EIy/GJfymPidMIlQWtrMbtXIean8Nkr9+KXvkxy3y7
         p/olKh1wYbeqVcP5OspQrwkEQfKeW3LywxNbUVn2DIB+8AYbYYvgAhVPmZTusOcaWl
         qe1jmSKrtfuTFroEYFoxp3CMxjFMR+36hkKhbaUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Kamel Bouhara <kamel.bouhara@bootlin.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 691/717] counter: microchip-tcb-capture: Fix CMR value check
Date:   Mon, 28 Dec 2020 13:51:29 +0100
Message-Id: <20201228125054.081521313@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Breathitt Gray <vilhelm.gray@gmail.com>

commit 3418bd7cfce0bd8ef1ccedc4655f9f86f6c3b0ca upstream.

The ATMEL_TC_ETRGEDG_* defines are not masks but rather possible values
for CMR. This patch fixes the action_get() callback to properly check
for these values rather than mask them.

Fixes: 106b104137fd ("counter: Add microchip TCB capture counter")
Signed-off-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Acked-by: Kamel Bouhara <kamel.bouhara@bootlin.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201114232805.253108-1-vilhelm.gray@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/counter/microchip-tcb-capture.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/counter/microchip-tcb-capture.c
+++ b/drivers/counter/microchip-tcb-capture.c
@@ -183,16 +183,20 @@ static int mchp_tc_count_action_get(stru
 
 	regmap_read(priv->regmap, ATMEL_TC_REG(priv->channel[0], CMR), &cmr);
 
-	*action = MCHP_TC_SYNAPSE_ACTION_NONE;
-
-	if (cmr & ATMEL_TC_ETRGEDG_NONE)
+	switch (cmr & ATMEL_TC_ETRGEDG) {
+	default:
 		*action = MCHP_TC_SYNAPSE_ACTION_NONE;
-	else if (cmr & ATMEL_TC_ETRGEDG_RISING)
+		break;
+	case ATMEL_TC_ETRGEDG_RISING:
 		*action = MCHP_TC_SYNAPSE_ACTION_RISING_EDGE;
-	else if (cmr & ATMEL_TC_ETRGEDG_FALLING)
+		break;
+	case ATMEL_TC_ETRGEDG_FALLING:
 		*action = MCHP_TC_SYNAPSE_ACTION_FALLING_EDGE;
-	else if (cmr & ATMEL_TC_ETRGEDG_BOTH)
+		break;
+	case ATMEL_TC_ETRGEDG_BOTH:
 		*action = MCHP_TC_SYNAPSE_ACTION_BOTH_EDGE;
+		break;
+	}
 
 	return 0;
 }


