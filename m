Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3583147E90
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731617AbgAXKOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:14:31 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:33883 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729509AbgAXKOb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 05:14:31 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jan 2020 05:14:30 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1579860869;
        s=strato-dkim-0002; d=plating.de;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=8SA5S2nypmC1xtLlmQD/4rllmpgnr0vFw0HlX5m+dMw=;
        b=beqdh9wP/Cu52kmmqawaNdN2AyHiHG2Rrv8lA3B67EA20aRNfu8dbu7tMsQ9LP88Li
        z3mT9/RnNdwZx0IayAG1snakQjqgx4XE+w6BM2Y3sif4lpdsVi+bNWl6cuAiW7e10S9e
        SWhgP+z4mcQbfSnaLQ+ezaoLmq/i9qIeLH2tbqPmlwDMMKVL5QV4+Ou+/VRhP81foSzl
        SltFbaycQbyUp//L3aja5C8A/gEIemANEHTdImAXSADv4Lm6Hgz26rxP6DrOF6UKhVyV
        3J2iCcjr+7674dniOS353j8OnZYf74TOdxQ1sBZU7He5DhnIjYDcT3QO2ovBdX8DRhQx
        kVeA==
X-RZG-AUTH: ":P2EQZVataeyI5jZ/YFVerR/NeEUpp/1ZEi4FSKT8sA3i0IzVhLiw6JgrUzaKN77axfKEX18="
X-RZG-CLASS-ID: mo00
Received: from mail.dl.plating.de
        by smtp.strato.de (RZmta 46.1.7 AUTH)
        with ESMTPSA id L0b26cw0OA8P4q3
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Fri, 24 Jan 2020 11:08:25 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mail.dl.plating.de (Postfix) with ESMTP id 16C0D122237;
        Fri, 24 Jan 2020 11:08:25 +0100 (CET)
X-Virus-Scanned: amavisd-new at dl.plating.de
Received: from mail.dl.plating.de ([127.0.0.1])
        by localhost (mail.dl.plating.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MgZBhhXL45DQ; Fri, 24 Jan 2020 11:08:18 +0100 (CET)
Received: from localhost (unknown [172.16.4.186])
        by mail.dl.plating.de (Postfix) with ESMTPSA id 0321B120413;
        Fri, 24 Jan 2020 11:08:16 +0100 (CET)
From:   =?UTF-8?q?Lars=20M=C3=B6llendorf?= <lars.moellendorf@plating.de>
To:     Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-iio@vger.kernel.org,
        stable@vger.kernel.org
Cc:     =?UTF-8?q?Lars=20M=C3=B6llendorf?= <lars.moellendorf@plating.de>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] iio: buffer: align the size of scan bytes to size of the largest element
Date:   Fri, 24 Jan 2020 11:07:00 +0100
Message-Id: <20200124100700.25632-1-lars.moellendorf@plating.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 883f61653069 ("iio: buffer: align the size of scan bytes to size of
the largest element")

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
index 0f6f63b20263..3534f981e561 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -516,7 +516,7 @@ static int iio_compute_scan_bytes(struct iio_dev *indio_dev,
 {
 	const struct iio_chan_spec *ch;
 	unsigned bytes = 0;
-	int length, i;
+	int length, i, largest = 0;

 	/* How much space will the demuxed element take? */
 	for_each_set_bit(i, mask,
@@ -529,6 +529,7 @@ static int iio_compute_scan_bytes(struct iio_dev *indio_dev,
 			length = ch->scan_type.storagebits / 8;
 		bytes = ALIGN(bytes, length);
 		bytes += length;
+		largest = max(largest, length);
 	}
 	if (timestamp) {
 		ch = iio_find_channel_from_si(indio_dev,
@@ -540,7 +541,10 @@ static int iio_compute_scan_bytes(struct iio_dev *indio_dev,
 			length = ch->scan_type.storagebits / 8;
 		bytes = ALIGN(bytes, length);
 		bytes += length;
+		largest = max(largest, length);
 	}
+
+	bytes = ALIGN(bytes, largest);
 	return bytes;
 }

--
2.23.0

