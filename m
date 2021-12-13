Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF70A4728C2
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239481AbhLMKOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239687AbhLMKIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:08:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3539DC08EA4F;
        Mon, 13 Dec 2021 01:52:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00DFAB80E0C;
        Mon, 13 Dec 2021 09:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF58C00446;
        Mon, 13 Dec 2021 09:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389150;
        bh=zWmqOYxi/kJpM+Z28vAO7bfbX3GIBMi3um/GqAy5ml4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yir1P5oG9zQPHVR7od7gj1TSr87rvICuMb6drQ9iPpVZJt2GJK+9Z0cfRjUmS7DLt
         wkfaEnvZdbTlSInjs8L7XMTQX3RuRCLonTWbw8jX17DT6gLbuM0kkffwUyZ/CEmJ6W
         86d9YPOkUJJ1ySvAc2OlkurjEFctGYqdwO26R0+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 120/132] iio: accel: kxcjk-1013: Fix possible memory leak in probe and remove
Date:   Mon, 13 Dec 2021 10:31:01 +0100
Message-Id: <20211213092943.214836280@linuxfoundation.org>
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
@@ -1435,8 +1435,7 @@ static int kxcjk1013_probe(struct i2c_cl
 	return 0;
 
 err_buffer_cleanup:
-	if (data->dready_trig)
-		iio_triggered_buffer_cleanup(indio_dev);
+	iio_triggered_buffer_cleanup(indio_dev);
 err_trigger_unregister:
 	if (data->dready_trig)
 		iio_trigger_unregister(data->dready_trig);
@@ -1459,8 +1458,8 @@ static int kxcjk1013_remove(struct i2c_c
 	pm_runtime_set_suspended(&client->dev);
 	pm_runtime_put_noidle(&client->dev);
 
+	iio_triggered_buffer_cleanup(indio_dev);
 	if (data->dready_trig) {
-		iio_triggered_buffer_cleanup(indio_dev);
 		iio_trigger_unregister(data->dready_trig);
 		iio_trigger_unregister(data->motion_trig);
 	}


