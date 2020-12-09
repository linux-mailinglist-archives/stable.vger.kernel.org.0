Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD022D3F90
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 11:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgLIKJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 05:09:05 -0500
Received: from mailout03.rmx.de ([94.199.88.101]:47382 "EHLO mailout03.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728631AbgLIKJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 05:09:05 -0500
X-Greylist: delayed 2000 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2020 05:09:04 EST
Received: from kdin01.retarus.com (kdin01.dmz1.retloc [172.19.17.48])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout03.rmx.de (Postfix) with ESMTPS id 4CrX2Y3fGvzlbGf;
        Wed,  9 Dec 2020 10:35:01 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin01.retarus.com (Postfix) with ESMTPS id 4CrX2P3z5lz2ytY;
        Wed,  9 Dec 2020 10:34:53 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.26) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 9 Dec
 2020 10:34:52 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     <gregkh@linuxfoundation.org>
CC:     <krzk@kernel.org>, <o.rempel@pengutronix.de>,
        <u.kleine-koenig@pengutronix.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>, <wsa@kernel.org>,
        <stable@vger.kernel.org>, Christian Eggers <ceggers@arri.de>
Subject: [PATCH v5.4] i2c: imx: Check for I2SR_IAL after every byte
Date:   Wed, 9 Dec 2020 10:34:31 +0100
Message-ID: <20201209093431.15561-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.26]
X-RMX-ID: 20201209-103453-KDVLhWwpmKss-0@out01.hq
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1de67a3dee7a279ebe4d892b359fe3696938ec15 upstream.

Arbitration Lost (IAL) can happen after every single byte transfer. If
arbitration is lost, the I2C hardware will autonomously switch from
master mode to slave. If a transfer is not aborted in this state,
consecutive transfers will not be executed by the hardware and will
timeout.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Tested (not extensively) on Vybrid VF500 (Toradex VF50):
Tested-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: stable@vger.kernel.org
---
Hi Greg,

here is the patch for linux-5.4. Please let me know if this doesn't apply to
older kernels.

regards
Christian

On Wednesday, 9 December 2020, 09:33:00 CET, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 1de67a3dee7a279ebe4d892b359fe3696938ec15 Mon Sep 17 00:00:00 2001

 drivers/i2c/busses/i2c-imx.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index bba612cf775d..9d3f42fd6352 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -470,6 +470,16 @@ static int i2c_imx_trx_complete(struct imx_i2c_struct *i2c_imx)
 		dev_dbg(&i2c_imx->adapter.dev, "<%s> Timeout\n", __func__);
 		return -ETIMEDOUT;
 	}
+
+	/* check for arbitration lost */
+	if (i2c_imx->i2csr & I2SR_IAL) {
+		dev_dbg(&i2c_imx->adapter.dev, "<%s> Arbitration lost\n", __func__);
+		i2c_imx_clear_irq(i2c_imx, I2SR_IAL);
+
+		i2c_imx->i2csr = 0;
+		return -EAGAIN;
+	}
+
 	dev_dbg(&i2c_imx->adapter.dev, "<%s> TRX complete\n", __func__);
 	i2c_imx->i2csr = 0;
 	return 0;
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

