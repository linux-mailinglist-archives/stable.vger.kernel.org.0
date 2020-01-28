Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B5814BAC4
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbgA1OOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:14:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729864AbgA1OOX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:14:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D07FF24694;
        Tue, 28 Jan 2020 14:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220863;
        bh=jV/dth03refcE4X+CD8qRfFQaEXuob2S/bnzO3uo3Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKbtprDHSUjl+teUz5iZyswqMAbB+SfEmR4W73inwAxiUrrphcfd2rDCPMoeKFyXd
         9/4CvN36FrcOGy2ZDBwhxCnSMg5QDHTwPUdbs7x7K7g3Dlg7GdeCf+ZKcroiOiGXi0
         7vK4YWECTNetIRFQqb/55lj2OD+Pg+iJpXqQZgg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Lars=20M=C3=B6llendorf?= <lars.moellendorf@plating.de>,
        Lars-Peter Clausen <lars@metafoo.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.4 177/183] iio: buffer: align the size of scan bytes to size of the largest element
Date:   Tue, 28 Jan 2020 15:06:36 +0100
Message-Id: <20200128135847.434432262@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/iio/industrialio-buffer.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -527,7 +527,7 @@ static int iio_compute_scan_bytes(struct
 {
 	const struct iio_chan_spec *ch;
 	unsigned bytes = 0;
-	int length, i;
+	int length, i, largest = 0;
 
 	/* How much space will the demuxed element take? */
 	for_each_set_bit(i, mask,
@@ -540,6 +540,7 @@ static int iio_compute_scan_bytes(struct
 			length = ch->scan_type.storagebits / 8;
 		bytes = ALIGN(bytes, length);
 		bytes += length;
+		largest = max(largest, length);
 	}
 	if (timestamp) {
 		ch = iio_find_channel_from_si(indio_dev,
@@ -551,7 +552,10 @@ static int iio_compute_scan_bytes(struct
 			length = ch->scan_type.storagebits / 8;
 		bytes = ALIGN(bytes, length);
 		bytes += length;
+		largest = max(largest, length);
 	}
+
+	bytes = ALIGN(bytes, largest);
 	return bytes;
 }
 


