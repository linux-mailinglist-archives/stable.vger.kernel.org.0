Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C73493EB
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbfFQVeW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729376AbfFQVYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:24:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01EAD20673;
        Mon, 17 Jun 2019 21:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806692;
        bh=YlHabfqMULhS0Hr9yCPfXQqFD9lmiBr8Yt0SzuQQQ0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bll6/F+K10SuNxyuFJH9els+vBHMBbWzIZDm8DtHeh3DkAs8AHZEP/hQlGcsknjaU
         GNpcgH7jyHaufuUuga9g0C21LhmQY5pyqxUgtRX2AME02tHQxeiH7s3B7MAVBL3EqE
         YX9Zr/6SbYiV5apbVgjQZ6Zok1qkGeb8ogMqLClU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Breno Leitao <leitao@debian.org>
Subject: [PATCH 4.19 03/75] HID: multitouch: handle faulty Elo touch device
Date:   Mon, 17 Jun 2019 23:09:14 +0200
Message-Id: <20190617210752.945246748@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 81bcbad53bab4bf9f200eda303d7a05cdb9bd73b upstream.

Since kernel v5.0, one single win8 touchscreen device failed.
And it turns out this is because it reports 2 InRange usage per touch.

It's a first, and I *really* wonder how this was allowed by Microsoft in
the first place. But IIRC, Breno told me this happened *after* a firmware
upgrade...

Anyway, better be safe for those crappy devices, and make sure we have
a full slot before jumping to the next.
This won't prevent all crappy devices to fail here, but at least we will
have a safeguard as long as the contact ID and the X and Y coordinates
are placed in the report after the grabage.

Fixes: 01eaac7e5713 ("HID: multitouch: remove one copy of values")
CC: stable@vger.kernel.org # v5.0+
Reported-and-tested-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index c02d4cad1893..1565a307170a 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -641,6 +641,13 @@ static void mt_store_field(struct hid_device *hdev,
 	if (*target != DEFAULT_TRUE &&
 	    *target != DEFAULT_FALSE &&
 	    *target != DEFAULT_ZERO) {
+		if (usage->contactid == DEFAULT_ZERO ||
+		    usage->x == DEFAULT_ZERO ||
+		    usage->y == DEFAULT_ZERO) {
+			hid_dbg(hdev,
+				"ignoring duplicate usage on incomplete");
+			return;
+		}
 		usage = mt_allocate_usage(hdev, application);
 		if (!usage)
 			return;


