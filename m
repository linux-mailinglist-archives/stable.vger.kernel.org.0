Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63918EEC46
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 22:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388164AbfKDVzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:55:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387652AbfKDVzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:55:31 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 132CB217F4;
        Mon,  4 Nov 2019 21:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904530;
        bh=nG6VPbCohQi6fBlcsnH+qIJ+5t18M1eyrl6miwMHJpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyYACyB1QMFWX8Sy+5AfcLOwZcwuMoV1uqRgeUnv6WXdUcPsH5DeuRaaM4WRTBjew
         q96Zvh1hBWJqTFepP7aHlt6iecv7Ub9bhhshwThjxW1i6dQm7vuHNz0TKjGcdtQ66w
         +Uchc/G0Q5K7gpyfrHwcajdOxHVbQHqa6VrMa1hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 77/95] HID: fix error message in hid_open_report()
Date:   Mon,  4 Nov 2019 22:45:15 +0100
Message-Id: <20191104212118.836009009@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michał Mirosław <mirq-linux@rere.qmqm.pl>

commit b3a81c777dcb093020680490ab970d85e2f6f04f upstream.

On HID report descriptor parsing error the code displays bogus
pointer instead of error offset (subtracts start=NULL from end).
Make the message more useful by displaying correct error offset
and include total buffer size for reference.

This was carried over from ancient times - "Fixed" commit just
promoted the message from DEBUG to ERROR.

Cc: stable@vger.kernel.org
Fixes: 8c3d52fc393b ("HID: make parser more verbose about parsing errors by default")
Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -979,6 +979,7 @@ int hid_open_report(struct hid_device *d
 	__u8 *start;
 	__u8 *buf;
 	__u8 *end;
+	__u8 *next;
 	int ret;
 	static int (*dispatch_type[])(struct hid_parser *parser,
 				      struct hid_item *item) = {
@@ -1032,7 +1033,8 @@ int hid_open_report(struct hid_device *d
 	device->collection_size = HID_DEFAULT_NUM_COLLECTIONS;
 
 	ret = -EINVAL;
-	while ((start = fetch_item(start, end, &item)) != NULL) {
+	while ((next = fetch_item(start, end, &item)) != NULL) {
+		start = next;
 
 		if (item.format != HID_ITEM_FORMAT_SHORT) {
 			hid_err(device, "unexpected long global item\n");
@@ -1061,7 +1063,8 @@ int hid_open_report(struct hid_device *d
 		}
 	}
 
-	hid_err(device, "item fetching failed at offset %d\n", (int)(end - start));
+	hid_err(device, "item fetching failed at offset %u/%u\n",
+		size - (unsigned int)(end - start), size);
 err:
 	vfree(parser);
 	hid_close_report(device);


