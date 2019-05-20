Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31FEA22CC2
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 09:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730011AbfETHQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 03:16:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbfETHQf (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 20 May 2019 03:16:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87B0E2081C;
        Mon, 20 May 2019 07:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558336595;
        bh=TQYuv2mOoGZi6lNS9qpUxaaYW3EjKxqwMoq4xY1V7gU=;
        h=Subject:To:From:Date:From;
        b=dP846MOHaRpXcQ2Mq56O4u8WFwC9wc/BmQnHaK/vkcrc4dc3Jzkmd8Eg2ZGF4GGzf
         wAzsQjVFv+cDiK9xoguw4M3knxyKZ3F9/hsNOIcn/OZw8iqhGVGyUGn9iq0REOjv7V
         Y/y9B+7b35M34CLHBJvHeVrdpMj2xJFMUrIBwo/A=
Subject: patch "iio: adc: modify NPCM ADC read reference voltage" added to staging-linus
To:     tmaimon77@gmail.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 May 2019 09:16:32 +0200
Message-ID: <155833659215158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: adc: modify NPCM ADC read reference voltage

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4e63ed6b90803eeb400c392e9ff493200d926b06 Mon Sep 17 00:00:00 2001
From: Tomer Maimon <tmaimon77@gmail.com>
Date: Sun, 7 Apr 2019 11:19:28 +0300
Subject: iio: adc: modify NPCM ADC read reference voltage

Checking if regulator is valid before reading
NPCM ADC regulator voltage to avoid system crash
in a case the regulator is not valid.

Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/adc/npcm_adc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/npcm_adc.c b/drivers/iio/adc/npcm_adc.c
index 9e25bbec9c70..193b3b81de4d 100644
--- a/drivers/iio/adc/npcm_adc.c
+++ b/drivers/iio/adc/npcm_adc.c
@@ -149,7 +149,7 @@ static int npcm_adc_read_raw(struct iio_dev *indio_dev,
 		}
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:
-		if (info->vref) {
+		if (!IS_ERR(info->vref)) {
 			vref_uv = regulator_get_voltage(info->vref);
 			*val = vref_uv / 1000;
 		} else {
-- 
2.21.0


