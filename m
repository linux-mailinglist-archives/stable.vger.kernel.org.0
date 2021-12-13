Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EEF4724E2
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbhLMJjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:39:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51456 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbhLMJh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:37:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61A3BB80E0B;
        Mon, 13 Dec 2021 09:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D60C00446;
        Mon, 13 Dec 2021 09:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388274;
        bh=yfH/uKEIVujdxufyCOJUmbUJibeyZiZDFdBGY2SDYcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QBpDYaogA/nEeof3W8qTWhgVANk0T6d0rbD2MXcaKnNEM7hrhp19oUt0LHa/UwDsw
         gDfAzv0Jk+AZK53LaVEHIG8M9meugj6SL3+pYBz09GWlXDIQYtgRwdZqDRxol65Db4
         Qk56Fjoe2KBlDw1a6JxOecGtBdFRtcXvZoDXy/kA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 47/53] iio: dln2: Check return value of devm_iio_trigger_register()
Date:   Mon, 13 Dec 2021 10:30:26 +0100
Message-Id: <20211213092929.922602173@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092928.349556070@linuxfoundation.org>
References: <20211213092928.349556070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit 90751fb9f224e0e1555b49a8aa9e68f6537e4cec upstream.

Registering a trigger can fail and the return value of
devm_iio_trigger_register() must be checked. Otherwise undefined behavior
can occur when the trigger is used.

Fixes: 7c0299e879dd ("iio: adc: Add support for DLN2 ADC")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20211101133043.6974-1-lars@metafoo.de
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/dln2-adc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/dln2-adc.c
+++ b/drivers/iio/adc/dln2-adc.c
@@ -674,7 +674,11 @@ static int dln2_adc_probe(struct platfor
 	}
 	dln2->trig->ops = &dln2_adc_trigger_ops;
 	iio_trigger_set_drvdata(dln2->trig, dln2);
-	devm_iio_trigger_register(dev, dln2->trig);
+	ret = devm_iio_trigger_register(dev, dln2->trig);
+	if (ret) {
+		dev_err(dev, "failed to register trigger: %d\n", ret);
+		return ret;
+	}
 	iio_trigger_set_immutable(indio_dev, dln2->trig);
 
 	ret = devm_iio_triggered_buffer_setup(dev, indio_dev, NULL,


