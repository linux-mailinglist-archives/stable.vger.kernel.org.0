Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DC0472513
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbhLMJkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234717AbhLMJjO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:39:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404A9C061D5F;
        Mon, 13 Dec 2021 01:37:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8D205CE0E7F;
        Mon, 13 Dec 2021 09:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9E3C341CA;
        Mon, 13 Dec 2021 09:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388265;
        bh=2qt4EuuFyqq2CR+XlV4DHHNK6qcXhmaQWS/jTj5v4sI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I2PkJ58oBUJDwhslg3SvszvT6g4a7PboIAUwLuz1YoQPFpZyGAsAJIzuzRywAyIpi
         Iu1I0HSKVra+evi9al8mR1oFbPkLV+PadRncFsJtZuSls+btIBcP+XNx58f83aU6/V
         inXn8pRJT3Xp5mhpiTXv9fksYFjreeqS4FfQvf8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.14 44/53] iio: kxsd9: Dont return error code in trigger handler
Date:   Mon, 13 Dec 2021 10:30:23 +0100
Message-Id: <20211213092929.830833221@linuxfoundation.org>
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

commit 45febe0d63917ee908198c5be08511c64ee1790a upstream.

IIO trigger handlers need to return one of the irqreturn_t values.
Returning an error code is not supported.

The kxsd9 interrupt handler returns an error code if reading the data
registers fails. In addition when exiting due to an error the trigger
handler does not call `iio_trigger_notify_done()`. Which when not done
keeps the triggered disabled forever.

Modify the code so that the function returns a valid irqreturn_t value as
well as calling `iio_trigger_notify_done()` on all exit paths.

Since we can't return the error code make sure to at least log it as part
of the error message.

Fixes: 0427a106a98a ("iio: accel: kxsd9: Add triggered buffer handling")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20211024171251.22896-2-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kxsd9.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/accel/kxsd9.c
+++ b/drivers/iio/accel/kxsd9.c
@@ -227,14 +227,14 @@ static irqreturn_t kxsd9_trigger_handler
 			       hw_values.chan,
 			       sizeof(hw_values.chan));
 	if (ret) {
-		dev_err(st->dev,
-			"error reading data\n");
-		return ret;
+		dev_err(st->dev, "error reading data: %d\n", ret);
+		goto out;
 	}
 
 	iio_push_to_buffers_with_timestamp(indio_dev,
 					   &hw_values,
 					   iio_get_time_ns(indio_dev));
+out:
 	iio_trigger_notify_done(indio_dev->trig);
 
 	return IRQ_HANDLED;


