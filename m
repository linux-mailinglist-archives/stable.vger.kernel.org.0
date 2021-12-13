Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6F34727B8
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238614AbhLMKEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:04:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46344 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240170AbhLMKAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:00:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C615B80EA2;
        Mon, 13 Dec 2021 10:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5813C34604;
        Mon, 13 Dec 2021 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389607;
        bh=YCgtwX7kgDZCOUbjeDVDI2z/mQlaIpqeWOEh5tshI2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=neyXTn6L/8Ci8noteCqyiZdqcT9Bep0htFUocxsIl7KstKToPyNwVCt7Kl1XZVFbt
         NlSNj341gYa5oMB5j2NgiClToUEZ4oIC0ZqNrRAqhlGt4kVDYWXXTw/fdaN7P63PWi
         3RWDIjIYOc9p+L72wyUAOr4KqPJoJyKNtyXWsg8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 144/171] iio: trigger: Fix reference counting
Date:   Mon, 13 Dec 2021 10:30:59 +0100
Message-Id: <20211213092949.870611061@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit a827a4984664308f13599a0b26c77018176d0c7c upstream.

In viio_trigger_alloc() device_initialize() is used to set the initial
reference count of the trigger to 1. Then another get_device() is called on
trigger. This sets the reference count to 2 before the trigger is returned.

iio_trigger_free(), which is the matching API to viio_trigger_alloc(),
calls put_device() which decreases the reference count by 1. But the second
reference count acquired in viio_trigger_alloc() is never dropped.

As a result the iio_trigger_release() function is never called and the
memory associated with the trigger is never freed.

Since there is no reason for the trigger to start its lifetime with two
reference counts just remove the extra get_device() in
viio_trigger_alloc().

Fixes: 5f9c035cae18 ("staging:iio:triggers. Add a reference get to the core for triggers.")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20211024092700.6844-2-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-trigger.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -556,7 +556,6 @@ struct iio_trigger *viio_trigger_alloc(s
 		irq_modify_status(trig->subirq_base + i,
 				  IRQ_NOREQUEST | IRQ_NOAUTOEN, IRQ_NOPROBE);
 	}
-	get_device(&trig->dev);
 
 	return trig;
 


