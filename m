Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56555378492
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhEJKxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233080AbhEJKvg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:51:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3D156196A;
        Mon, 10 May 2021 10:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643239;
        bh=hnhUQG8hywRvEAsV0Rzwy6G3+gLrcQvD1aVufN/pTm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCBnEv25W7r5hvB0DCFZ9kI60GunGvyMuGyQc+PDMf6XD92HZxcaziDLz+IstHSpb
         bZQGn1x+O8LRgqSqPeLsYulu1/z2702YfQRdqwVAny3QEEebETQ736gH9lHglLSx2X
         Wc/OwdnWuQueLiqMTPYhvUOQpA/1hcuNRAJDSLUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hubert Streidl <hubert.streidl@de.bosch.com>,
        Mark Jonas <mark.jonas@de.bosch.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/299] mfd: da9063: Support SMBus and I2C mode
Date:   Mon, 10 May 2021 12:19:57 +0200
Message-Id: <20210510102011.549828819@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hubert Streidl <hubert.streidl@de.bosch.com>

[ Upstream commit 586478bfc9f7e16504d6f64cf18bcbdf6fd0cbc9 ]

By default the PMIC DA9063 2-wire interface is SMBus compliant. This
means the PMIC will automatically reset the interface when the clock
signal ceases for more than the SMBus timeout of 35 ms.

If the I2C driver / device is not capable of creating atomic I2C
transactions, a context change can cause a ceasing of the clock signal.
This can happen if for example a real-time thread is scheduled. Then
the DA9063 in SMBus mode will reset the 2-wire interface. Subsequently
a write message could end up in the wrong register. This could cause
unpredictable system behavior.

The DA9063 PMIC also supports an I2C compliant mode for the 2-wire
interface. This mode does not reset the interface when the clock
signal ceases. Thus the problem depicted above does not occur.

This patch tests for the bus functionality "I2C_FUNC_I2C". It can
reasonably be assumed that the bus cannot obey SMBus timings if
this functionality is set. SMBus commands most probably are emulated
in this case which is prone to the latency issue described above.

This patch enables the I2C bus mode if I2C_FUNC_I2C is set or
otherwise keeps the default SMBus mode.

Signed-off-by: Hubert Streidl <hubert.streidl@de.bosch.com>
Signed-off-by: Mark Jonas <mark.jonas@de.bosch.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da9063-i2c.c             | 10 ++++++++++
 include/linux/mfd/da9063/registers.h |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/drivers/mfd/da9063-i2c.c b/drivers/mfd/da9063-i2c.c
index b8217ad303ce..3419814d016b 100644
--- a/drivers/mfd/da9063-i2c.c
+++ b/drivers/mfd/da9063-i2c.c
@@ -442,6 +442,16 @@ static int da9063_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
+	/* If SMBus is not available and only I2C is possible, enter I2C mode */
+	if (i2c_check_functionality(i2c->adapter, I2C_FUNC_I2C)) {
+		ret = regmap_clear_bits(da9063->regmap, DA9063_REG_CONFIG_J,
+					DA9063_TWOWIRE_TO);
+		if (ret < 0) {
+			dev_err(da9063->dev, "Failed to set Two-Wire Bus Mode.\n");
+			return -EIO;
+		}
+	}
+
 	return da9063_device_init(da9063, i2c->irq);
 }
 
diff --git a/include/linux/mfd/da9063/registers.h b/include/linux/mfd/da9063/registers.h
index 1dbabf1b3cb8..6e0f66a2e727 100644
--- a/include/linux/mfd/da9063/registers.h
+++ b/include/linux/mfd/da9063/registers.h
@@ -1037,6 +1037,9 @@
 #define		DA9063_NONKEY_PIN_AUTODOWN	0x02
 #define		DA9063_NONKEY_PIN_AUTOFLPRT	0x03
 
+/* DA9063_REG_CONFIG_J (addr=0x10F) */
+#define DA9063_TWOWIRE_TO			0x40
+
 /* DA9063_REG_MON_REG_5 (addr=0x116) */
 #define DA9063_MON_A8_IDX_MASK			0x07
 #define		DA9063_MON_A8_IDX_NONE		0x00
-- 
2.30.2



