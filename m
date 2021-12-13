Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9994547254D
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhLMJnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55494 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbhLMJlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:41:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECF4EB80E2A;
        Mon, 13 Dec 2021 09:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136AEC00446;
        Mon, 13 Dec 2021 09:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388488;
        bh=IZp7M0GCPlkcazySjNI+e9di3CnE5zDbc8DLXEjeq9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qpx/vCuNZbUiHw7luY2EdoX7NBm8d0OCbYn7CN5w41lXOBl8sIJyDkuv0TWNVE/pm
         U4kPUp31A50GRtM9hMydOyPY8FffEzWxT+jx2X466JQN1Uu2L6J8jnZEPuYWRXazM4
         hChjEmHdk7S0HdHeKIjOF++jOBwVcagtddXiGpms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 60/74] iio: mma8452: Fix trigger reference couting
Date:   Mon, 13 Dec 2021 10:30:31 +0100
Message-Id: <20211213092932.807795193@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
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
@@ -1470,7 +1470,7 @@ static int mma8452_trigger_setup(struct
 	if (ret)
 		return ret;
 
-	indio_dev->trig = trig;
+	indio_dev->trig = iio_trigger_get(trig);
 
 	return 0;
 }


