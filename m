Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FCC226BDC
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731516AbgGTQo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:33218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729878AbgGTPlY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:41:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DDF02064B;
        Mon, 20 Jul 2020 15:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259684;
        bh=qtLQF2L4PLhu5M/VlmHYnqF+xmNBY7OKRaBtkjH+mmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MY2WwImS1NtFq+foyoQhJ0V7zOUvOSgblWYUaq95/Tc44lHA45vwHjpaTd8lY2eWW
         w30shNGr9ImatJoqRW0EDlVOPLyvaYuu5PigBR8Kvd8PtI3EkE70IBXyCMk8tEDNDV
         XlJNjK1bdDadtC1A/fOqOr6SZFNtI8PD6UP7WVK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.9 43/86] iio: mma8452: Add missed iio_device_unregister() call in mma8452_probe()
Date:   Mon, 20 Jul 2020 17:36:39 +0200
Message-Id: <20200720152755.332410679@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit d7369ae1f4d7cffa7574d15e1f787dcca184c49d upstream.

The function iio_device_register() was called in mma8452_probe().
But the function iio_device_unregister() was not called after
a call of the function mma8452_set_freefall_mode() failed.
Thus add the missed function call for one error case.

Fixes: 1a965d405fc6 ("drivers:iio:accel:mma8452: added cleanup provision in case of failure.")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/accel/mma8452.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1576,10 +1576,13 @@ static int mma8452_probe(struct i2c_clie
 
 	ret = mma8452_set_freefall_mode(data, false);
 	if (ret < 0)
-		goto buffer_cleanup;
+		goto unregister_device;
 
 	return 0;
 
+unregister_device:
+	iio_device_unregister(indio_dev);
+
 buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 


