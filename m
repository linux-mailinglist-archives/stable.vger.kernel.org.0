Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94B9472213
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 09:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbhLMIGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 03:06:35 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:44500 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232707AbhLMIGf (ORCPT
        <rfc822;Stable@vger.kernel.org>); Mon, 13 Dec 2021 03:06:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9EA79CE0B59
        for <Stable@vger.kernel.org>; Mon, 13 Dec 2021 08:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E69C00446;
        Mon, 13 Dec 2021 08:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639382791;
        bh=EGUlzSM+A251HJ7DkuOEKL1yO/5nYsNAzztkt0/vpCU=;
        h=Subject:To:Cc:From:Date:From;
        b=X8AsqJU1sNBPrBUp/82iY2eBxNamhUcg+ue4buj7+G44BVoNIR1RnhNF87lHSiTMM
         SQV8yfNLMkNYCdsttub7mouORruwrxjSdc10gsGmrZPugP9G2dqzdH4UFQXTsZuPMd
         C303Y7l6LZH0uRVCPjZ5i+T1QtEMVtSTojpNwx6g=
Subject: FAILED: patch "[PATCH] iio: trigger: Fix reference counting" failed to apply to 4.4-stable tree
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, nuno.sa@analog.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Dec 2021 09:06:29 +0100
Message-ID: <163938278945249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a827a4984664308f13599a0b26c77018176d0c7c Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Sun, 24 Oct 2021 11:27:00 +0200
Subject: [PATCH] iio: trigger: Fix reference counting
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/iio/industrialio-trigger.c b/drivers/iio/industrialio-trigger.c
index b23caa2f2aa1..93990ff1dfe3 100644
--- a/drivers/iio/industrialio-trigger.c
+++ b/drivers/iio/industrialio-trigger.c
@@ -556,7 +556,6 @@ struct iio_trigger *viio_trigger_alloc(struct device *parent,
 		irq_modify_status(trig->subirq_base + i,
 				  IRQ_NOREQUEST | IRQ_NOAUTOEN, IRQ_NOPROBE);
 	}
-	get_device(&trig->dev);
 
 	return trig;
 

