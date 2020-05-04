Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED0F1C4462
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732039AbgEDSGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731519AbgEDSGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:06:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 962482073B;
        Mon,  4 May 2020 18:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615611;
        bh=RTv3fe9BdZNIW2EkAR6n7tLvr54BVsc+vkMbD+c/x5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIlTE51zOAKjCXX6Ny1AA5IJX/lfHGLXPoV86PySC/0uaQl2elB8ph0EtotqrfD/m
         R0gaz2zIrr4GQlOOWtuS66zMX5uiT06Ub2xFgRcf0F71sDpVpxrcRHsrz77VI6pXRt
         Hkx8NYvh1mx7v7TJEtGWHmF+BAKDDVI79bCANpBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 5.6 52/73] i2c: iproc: generate stop event for slave writes
Date:   Mon,  4 May 2020 19:57:55 +0200
Message-Id: <20200504165509.271153097@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165501.781878940@linuxfoundation.org>
References: <20200504165501.781878940@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>

commit 068143a8195fb0fdeea1f3ca430b3db0f6d04a53 upstream.

When slave status is I2C_SLAVE_RX_END, generate I2C_SLAVE_STOP
event to i2c_client.

Fixes: c245d94ed106 ("i2c: iproc: Add multi byte read-write support for slave mode")
Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-bcm-iproc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/i2c/busses/i2c-bcm-iproc.c
+++ b/drivers/i2c/busses/i2c-bcm-iproc.c
@@ -360,6 +360,9 @@ static bool bcm_iproc_i2c_slave_isr(stru
 			value = (u8)((val >> S_RX_DATA_SHIFT) & S_RX_DATA_MASK);
 			i2c_slave_event(iproc_i2c->slave,
 					I2C_SLAVE_WRITE_RECEIVED, &value);
+			if (rx_status == I2C_SLAVE_RX_END)
+				i2c_slave_event(iproc_i2c->slave,
+						I2C_SLAVE_STOP, &value);
 		}
 	} else if (status & BIT(IS_S_TX_UNDERRUN_SHIFT)) {
 		/* Master read other than start */


