Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B34472854
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238710AbhLMKKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241903AbhLMKGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:06:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D18C0A8897;
        Mon, 13 Dec 2021 01:51:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8F7BB80E1C;
        Mon, 13 Dec 2021 09:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE72C00446;
        Mon, 13 Dec 2021 09:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389070;
        bh=c4PyAvgauIE/r1W3fXe8JPNA4wDziqxWatb/PabbAA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWfbcwrv9EDa+lX5Z6f5O12IH2BOxObD85ColmaHBMc7ASDgaYXMnbqM6GRYUzkas
         VFhYoSyqMIEB/wGo5rMgdGnVjU/Ak7LlUz9tA0mThHF73mqlwd/APxY4cofQsErwOo
         C7dX5RInxBoxsUHhJL8FKuoLDGqd4yG0zPwPNoLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 107/132] iio: trigger: Fix reference counting
Date:   Mon, 13 Dec 2021 10:30:48 +0100
Message-Id: <20211213092942.772638037@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
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
@@ -550,7 +550,6 @@ struct iio_trigger *viio_trigger_alloc(c
 		irq_modify_status(trig->subirq_base + i,
 				  IRQ_NOREQUEST | IRQ_NOAUTOEN, IRQ_NOPROBE);
 	}
-	get_device(&trig->dev);
 
 	return trig;
 


