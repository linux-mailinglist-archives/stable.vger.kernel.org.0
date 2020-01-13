Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1572E138FCC
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 12:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgAMLJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 06:09:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:52040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgAMLJE (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 13 Jan 2020 06:09:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5A862081E;
        Mon, 13 Jan 2020 11:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578913743;
        bh=/vtNhFGFC7gcksJ7h3twl4HzL1C5CCDVhYHkxUB8l2I=;
        h=Subject:To:From:Date:From;
        b=upENQuRV8vLNlDlOnamlCDB2UF9sPx1UNkFJmeUdqhh6Sx3vvIna9f0Qup8huZzR6
         i9L72ev1mhPs8BlaH85HhxiMIVVHpsUsbL/ZO3RbPAB5eBHUKDPbx1SHzJDlesc5UT
         SXaQPxE9TAL33RlFq4Zq8Kd40kCzaY1og4937Zps=
Subject: patch "iio: buffer: align the size of scan bytes to size of the largest" added to staging-linus
To:     lars.moellendorf@plating.de, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org, gregkh@linuxfoundation.org, lars@metafoo.de
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jan 2020 12:08:53 +0100
Message-ID: <157891373336141@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: buffer: align the size of scan bytes to size of the largest

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 883f616530692d81cb70f8a32d85c0d2afc05f69 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Lars=20M=C3=B6llendorf?= <lars.moellendorf@plating.de>
Date: Fri, 13 Dec 2019 14:50:55 +0100
Subject: iio: buffer: align the size of scan bytes to size of the largest
 element
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Previous versions of `iio_compute_scan_bytes` only aligned each element
to its own length (i.e. its own natural alignment). Because multiple
consecutive sets of scan elements are buffered this does not work in
case the computed scan bytes do not align with the natural alignment of
the first scan element in the set.

This commit fixes this by aligning the scan bytes to the natural
alignment of the largest scan element in the set.

Fixes: 959d2952d124 ("staging:iio: make iio_sw_buffer_preenable much more general.")
Signed-off-by: Lars Möllendorf <lars.moellendorf@plating.de>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index c193d64e5217..112225c0e486 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -566,7 +566,7 @@ static int iio_compute_scan_bytes(struct iio_dev *indio_dev,
 				const unsigned long *mask, bool timestamp)
 {
 	unsigned bytes = 0;
-	int length, i;
+	int length, i, largest = 0;
 
 	/* How much space will the demuxed element take? */
 	for_each_set_bit(i, mask,
@@ -574,13 +574,17 @@ static int iio_compute_scan_bytes(struct iio_dev *indio_dev,
 		length = iio_storage_bytes_for_si(indio_dev, i);
 		bytes = ALIGN(bytes, length);
 		bytes += length;
+		largest = max(largest, length);
 	}
 
 	if (timestamp) {
 		length = iio_storage_bytes_for_timestamp(indio_dev);
 		bytes = ALIGN(bytes, length);
 		bytes += length;
+		largest = max(largest, length);
 	}
+
+	bytes = ALIGN(bytes, largest);
 	return bytes;
 }
 
-- 
2.24.1


