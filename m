Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B3547246C
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbhLMJgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbhLMJfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:35:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E24C061D60;
        Mon, 13 Dec 2021 01:35:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BC87B80DE8;
        Mon, 13 Dec 2021 09:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA54C00446;
        Mon, 13 Dec 2021 09:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388115;
        bh=yTL7CmjZG6xz30O8PoMmheZN4yNRL66a0A+PaZ50ITo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZddOJxv/ynh5rCE8DLS3jGAxJduWKDoetrPTTjKNZvcmczQ2mygcTcOaHnTu1PJI
         1V/CAZiFZ+eQlv6EAdpmPQOyhBZkHRUMIsFV/fLPnN0CBNaSm9BWAhJMvMnoz6PXmt
         wpDGU9w8nEj7c6cput/OhAJoHy7EntGsOm+6JhfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.9 34/42] iio: mma8452: Fix trigger reference couting
Date:   Mon, 13 Dec 2021 10:30:16 +0100
Message-Id: <20211213092927.668087324@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092926.578829548@linuxfoundation.org>
References: <20211213092926.578829548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

commit cd0082235783f814241a1c9483fb89e405f4f892 upstream.

The mma8452 driver directly assigns a trigger to the struct iio_dev. The
IIO core when done using this trigger will call `iio_trigger_put()` to drop
the reference count by 1.

Without the matching `iio_trigger_get()` in the driver the reference count
can reach 0 too early, the trigger gets freed while still in use and a
use-after-free occurs.

Fix this by getting a reference to the trigger before assigning it to the
IIO device.

Fixes: ae6d9ce05691 ("iio: mma8452: Add support for interrupt driven triggers.")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20211024092700.6844-1-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/mma8452.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1389,7 +1389,7 @@ static int mma8452_trigger_setup(struct
 	if (ret)
 		return ret;
 
-	indio_dev->trig = trig;
+	indio_dev->trig = iio_trigger_get(trig);
 
 	return 0;
 }


