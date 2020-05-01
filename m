Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C49E1C1350
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbgEAN2f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:28:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbgEAN2e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:28:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A677524954;
        Fri,  1 May 2020 13:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339714;
        bh=zUCiPF1saQAniHcWkEVbc4jYJQ/5z6kvlySYJdaGaC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0PETdxpnjjKI/Bryk0K2Sxb4917oc00+ypd/psSAcmlDTKp+RNhiwRYzLhWlACNp
         f5KJ5YZ8r0rHpHxHbFTj/eoSepTzJcS616/bTx6yBul3XQi8q4/Y9wVnr3QCSrFoJT
         efm6jgU7uI/l2q/1YGKowe3F1p+V1Wdvn4bpXgMQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.9 30/80] iio: xilinx-xadc: Fix ADC-B powerdown
Date:   Fri,  1 May 2020 15:21:24 +0200
Message-Id: <20200501131523.911972888@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
References: <20200501131513.810761598@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit e44ec7794d88f918805d700240211a9ec05ed89d upstream.

The check for shutting down the second ADC is inverted. This causes it to
be powered down when it should be enabled. As a result channels that are
supposed to be handled by the second ADC return invalid conversion results.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Fixes: bdc8cda1d010 ("iio:adc: Add Xilinx XADC driver")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/xilinx-xadc-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -709,13 +709,14 @@ static int xadc_power_adc_b(struct xadc
 {
 	uint16_t val;
 
+	/* Powerdown the ADC-B when it is not needed. */
 	switch (seq_mode) {
 	case XADC_CONF1_SEQ_SIMULTANEOUS:
 	case XADC_CONF1_SEQ_INDEPENDENT:
-		val = XADC_CONF2_PD_ADC_B;
+		val = 0;
 		break;
 	default:
-		val = 0;
+		val = XADC_CONF2_PD_ADC_B;
 		break;
 	}
 


