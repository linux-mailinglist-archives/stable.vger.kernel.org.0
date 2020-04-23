Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E132D1B67F8
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgDWXLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:11:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50270 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728575AbgDWXGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvZ-0004nR-IX; Fri, 24 Apr 2020 00:06:41 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvV-00E6vx-Ln; Fri, 24 Apr 2020 00:06:37 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jonathan Cameron" <Jonathan.Cameron@huawei.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        "=?UTF-8?q?Lars=20M=C3=B6llendorf?=" <lars.moellendorf@plating.de>
Date:   Fri, 24 Apr 2020 00:06:43 +0100
Message-ID: <lsq.1587683028.253626517@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 176/245] iio: buffer: align the size of scan bytes to
 size of the largest element
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lars Möllendorf <lars.moellendorf@plating.de>

commit 883f616530692d81cb70f8a32d85c0d2afc05f69 upstream.

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
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/iio/industrialio-buffer.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -478,7 +478,7 @@ static int iio_compute_scan_bytes(struct
 {
 	const struct iio_chan_spec *ch;
 	unsigned bytes = 0;
-	int length, i;
+	int length, i, largest = 0;
 
 	/* How much space will the demuxed element take? */
 	for_each_set_bit(i, mask,
@@ -491,6 +491,7 @@ static int iio_compute_scan_bytes(struct
 			length = ch->scan_type.storagebits / 8;
 		bytes = ALIGN(bytes, length);
 		bytes += length;
+		largest = max(largest, length);
 	}
 	if (timestamp) {
 		ch = iio_find_channel_from_si(indio_dev,
@@ -502,7 +503,10 @@ static int iio_compute_scan_bytes(struct
 			length = ch->scan_type.storagebits / 8;
 		bytes = ALIGN(bytes, length);
 		bytes += length;
+		largest = max(largest, length);
 	}
+
+	bytes = ALIGN(bytes, largest);
 	return bytes;
 }
 

