Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E99D300D02
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbhAVT4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727517AbhAVOKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:10:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62C9823A75;
        Fri, 22 Jan 2021 14:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324563;
        bh=sOkpxDdA5DSQyv9tafJKuk6w3gPd/pNyDXBhe+5YM5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7DaDFSzUIfk1flcaH88nzeN8shJvagyh7bk1Z7D6/7TecTtcUF+/lyfeUb3QKdhy
         Puc/5T5H9lF+W+uWYUuxx/1RmVGSPFZXq4O6WHSL/u9n+hDyUZ7k82FUJb4FtVrLov
         4b2YIGqFjGYMRa3oJplcFXCLQM//hGYZftp/wqDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Nuno=20S=E1?= <nuno.sa@analog.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 21/31] iio: buffer: Fix demux update
Date:   Fri, 22 Jan 2021 15:08:35 +0100
Message-Id: <20210122135732.717616060@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Nuno Sá" <nuno.sa@analog.com>

commit 19ef7b70ca9487773c29b449adf0c70f540a0aab upstream

When updating the buffer demux, we will skip a scan element from the
device in the case `in_ind != out_ind` and we enter the while loop.
in_ind should only be refreshed with `find_next_bit()` in the end of the
loop.

Note, to cause problems we need a situation where we are skippig over
an element (channel not enabled) that happens to not have the same size
as the next element.   Whilst this is a possible situation we haven't
actually identified any cases in mainline where it happens as most drivers
have consistent channel storage sizes with the exception of the timestamp
which is the last element and hence never skipped over.

Fixes: 5ada4ea9be16 ("staging:iio: add demux optionally to path from device to buffer")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20201112144323.28887-1-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -1281,9 +1281,6 @@ static int iio_buffer_update_demux(struc
 				       indio_dev->masklength,
 				       in_ind + 1);
 		while (in_ind != out_ind) {
-			in_ind = find_next_bit(indio_dev->active_scan_mask,
-					       indio_dev->masklength,
-					       in_ind + 1);
 			ch = iio_find_channel_from_si(indio_dev, in_ind);
 			if (ch->scan_type.repeat > 1)
 				length = ch->scan_type.storagebits / 8 *
@@ -1292,6 +1289,9 @@ static int iio_buffer_update_demux(struc
 				length = ch->scan_type.storagebits / 8;
 			/* Make sure we are aligned */
 			in_loc = roundup(in_loc, length) + length;
+			in_ind = find_next_bit(indio_dev->active_scan_mask,
+					       indio_dev->masklength,
+					       in_ind + 1);
 		}
 		ch = iio_find_channel_from_si(indio_dev, in_ind);
 		if (ch->scan_type.repeat > 1)


