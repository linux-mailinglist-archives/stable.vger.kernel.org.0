Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E66C472730
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239986AbhLMJ7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238693AbhLMJyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:54:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8EEC08E883;
        Mon, 13 Dec 2021 01:45:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5AAEECE0E86;
        Mon, 13 Dec 2021 09:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AD9C341C8;
        Mon, 13 Dec 2021 09:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388732;
        bh=1ZmzGHdhLAlmdAbVcPqlEkgFwqiJSzpMrF9HdQ2/Cf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hQyeMFbxRvEoMSgUPW4cOnWgS6mp7K3ijB7eMQybLFcY9gm5Do2AnK8giMy8ZgqeM
         gOvDz2s2oWVAjKBxUuwXtx/MPmpZDRU3kjpShYl8YFZh8ES73hhqWgxd/ASCUt6jsN
         LcH1kVBUL/gpxJ1C5eyPIBakH/x85UJkoFdZktJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 78/88] iio: dln2: Check return value of devm_iio_trigger_register()
Date:   Mon, 13 Dec 2021 10:30:48 +0100
Message-Id: <20211213092935.919392161@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
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
@@ -665,7 +665,11 @@ static int dln2_adc_probe(struct platfor
 		return -ENOMEM;
 	}
 	iio_trigger_set_drvdata(dln2->trig, dln2);
-	devm_iio_trigger_register(dev, dln2->trig);
+	ret = devm_iio_trigger_register(dev, dln2->trig);
+	if (ret) {
+		dev_err(dev, "failed to register trigger: %d\n", ret);
+		return ret;
+	}
 	iio_trigger_set_immutable(indio_dev, dln2->trig);
 
 	ret = devm_iio_triggered_buffer_setup(dev, indio_dev, NULL,


