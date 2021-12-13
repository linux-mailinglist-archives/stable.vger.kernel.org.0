Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4F647261D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbhLMJtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:08 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37168 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236026AbhLMJpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:45:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BA09DCE0E96;
        Mon, 13 Dec 2021 09:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60297C00446;
        Mon, 13 Dec 2021 09:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388744;
        bh=UwSDO8IZxWRsMCp0xnXpmJ0UXGnrmXOhCVIXuoXYIhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzeKlgzTFIwVRe9wCRDQ6Jcoay7ewfWk/4OH+VvCaz/06aS4u7lDSkAPwTGsP4b2t
         ZxMivVYRC62aJLL9Y6gGm8r/yvu47Vgyke1YXxq7W2GGKYZCNdGzE76RcXqrhl2ISl
         y38L4vJ+DtlWq6k9kqleb9Z4txWWnBdUq5fsqhfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 81/88] iio: ad7768-1: Call iio_trigger_notify_done() on error
Date:   Mon, 13 Dec 2021 10:30:51 +0100
Message-Id: <20211213092936.009854762@linuxfoundation.org>
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

commit 6661146427cbbce6d1fe3dbb11ff1c487f55799a upstream.

IIO trigger handlers must call iio_trigger_notify_done() when done. This
must be done even when an error occurred. Otherwise the trigger will be
seen as busy indefinitely and the trigger handler will never be called
again.

The ad7768-1 driver neglects to call iio_trigger_notify_done() when there
is an error reading the converter data. Fix this by making sure that
iio_trigger_notify_done() is included in the error exit path.

Fixes: a5f8c7da3dbe ("iio: adc: Add AD7768-1 ADC basic support")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20211101144055.13858-2-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7768-1.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -470,8 +470,8 @@ static irqreturn_t ad7768_trigger_handle
 	iio_push_to_buffers_with_timestamp(indio_dev, &st->data.scan,
 					   iio_get_time_ns(indio_dev));
 
-	iio_trigger_notify_done(indio_dev->trig);
 err_unlock:
+	iio_trigger_notify_done(indio_dev->trig);
 	mutex_unlock(&st->lock);
 
 	return IRQ_HANDLED;


