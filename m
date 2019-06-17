Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAED049271
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbfFQVUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729037AbfFQVUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:20:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C3822089E;
        Mon, 17 Jun 2019 21:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806416;
        bh=GMZqX2X3Vukih/0rye6TPz5iz4qZJB9tSJRMUj4xMR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+Q9Nkv5dcfygdar+JPNr1mddrKqExRXlaWU16CjFvbLeMMCeH4mXztzZdsq+uLvZ
         oyy8CdwSArJ/HhBOIohl72WljA3ure3Ts8NpK5PbLvwCSCHUxwmXs13zWUpxO7c5sh
         RoAEWV6PNIH6s2IE/63bnPpt/dj7vny0kJtDO84w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Breno Leitao <leitao@debian.org>
Subject: [PATCH 5.1 006/115] HID: multitouch: handle faulty Elo touch device
Date:   Mon, 17 Jun 2019 23:08:26 +0200
Message-Id: <20190617210800.232008225@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
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

---
 drivers/hid/hid-multitouch.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -641,6 +641,13 @@ static void mt_store_field(struct hid_de
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


