Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE3A46D3C9
	for <lists+stable@lfdr.de>; Wed,  8 Dec 2021 13:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhLHM5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Dec 2021 07:57:54 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48012 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232176AbhLHM5x (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 8 Dec 2021 07:57:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C1A78CE2166
        for <Stable@vger.kernel.org>; Wed,  8 Dec 2021 12:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F89C00446;
        Wed,  8 Dec 2021 12:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638968059;
        bh=7R6lhqCWCxjzxJA/usDAtuzPiPws+55VnN3ddgqHQTs=;
        h=Subject:To:From:Date:From;
        b=PkjncjBhj+E7Jil/DNYCdAxTiE91tdkFrVuYuXXWd1dxs/WJVmwsdnDf0t6mk/d/C
         rq8b6eDcl1omAkpjXlyz+pmxXPBWtjzIqnN9aGhimmvuhM4L1gC0Y/Yd/i2y0coNWZ
         UrGpv9/uh4Gx4EDOVKksqIGRRFZJtyUXWCugKN68=
Subject: patch "iio: trigger: Fix reference counting" added to char-misc-linus
To:     lars@metafoo.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, nuno.sa@analog.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 Dec 2021 13:53:55 +0100
Message-ID: <1638968035210203@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: trigger: Fix reference counting

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a827a4984664308f13599a0b26c77018176d0c7c Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Sun, 24 Oct 2021 11:27:00 +0200
Subject: iio: trigger: Fix reference counting
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
---
 drivers/iio/industrialio-trigger.c | 1 -
 1 file changed, 1 deletion(-)

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
 
-- 
2.34.1


