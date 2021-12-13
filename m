Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407954725F4
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235268AbhLMJsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:48:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59254 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbhLMJpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:45:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 624A6B80E26;
        Mon, 13 Dec 2021 09:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367BDC00446;
        Mon, 13 Dec 2021 09:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388747;
        bh=tDk7kO9pm9Az6yNX4D6GMnhZnvV+PD+K8vjV55l1g7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lhOIm1KXT6UNpXA1+coCWydhFPZWkCHO3fVWFOBv3MqvKkVKQb8IWX2lIqHwu5sr6
         L/35swATF757T4ycDfU5gxxeMlvuMRF2AMlZ7oUZ/JbQIRD1yxawpOIhFX7SY7l513
         nzrZqvMMHQ1tkjt0uaaXb8jXOBsO82PZ4SG4jXiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 82/88] iio: accel: kxcjk-1013: Fix possible memory leak in probe and remove
Date:   Mon, 13 Dec 2021 10:30:52 +0100
Message-Id: <20211213092936.040828364@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

commit 70c9774e180d151abaab358108e3510a8e615215 upstream.

When ACPI type is ACPI_SMO8500, the data->dready_trig will not be set, the
memory allocated by iio_triggered_buffer_setup() will not be freed, and cause
memory leak as follows:

unreferenced object 0xffff888009551400 (size 512):
  comm "i2c-SMO8500-125", pid 911, jiffies 4294911787 (age 83.852s)
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 20 e2 e5 c0 ff ff ff ff  ........ .......
  backtrace:
    [<0000000041ce75ee>] kmem_cache_alloc_trace+0x16d/0x360
    [<000000000aeb17b0>] iio_kfifo_allocate+0x41/0x130 [kfifo_buf]
    [<000000004b40c1f5>] iio_triggered_buffer_setup_ext+0x2c/0x210 [industrialio_triggered_buffer]
    [<000000004375b15f>] kxcjk1013_probe+0x10c3/0x1d81 [kxcjk_1013]

Fix it by remove data->dready_trig condition in probe and remove.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: a25691c1f967 ("iio: accel: kxcjk1013: allow using an external trigger")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Cc: <Stable@vger.kernel.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20211025124159.2700301-1-yangyingliang@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/kxcjk-1013.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1415,8 +1415,7 @@ static int kxcjk1013_probe(struct i2c_cl
 	return 0;
 
 err_buffer_cleanup:
-	if (data->dready_trig)
-		iio_triggered_buffer_cleanup(indio_dev);
+	iio_triggered_buffer_cleanup(indio_dev);
 err_trigger_unregister:
 	if (data->dready_trig)
 		iio_trigger_unregister(data->dready_trig);
@@ -1439,8 +1438,8 @@ static int kxcjk1013_remove(struct i2c_c
 	pm_runtime_set_suspended(&client->dev);
 	pm_runtime_put_noidle(&client->dev);
 
+	iio_triggered_buffer_cleanup(indio_dev);
 	if (data->dready_trig) {
-		iio_triggered_buffer_cleanup(indio_dev);
 		iio_trigger_unregister(data->dready_trig);
 		iio_trigger_unregister(data->motion_trig);
 	}


