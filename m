Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB8A49270
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfFQVUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbfFQVUO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:20:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD2B320B1F;
        Mon, 17 Jun 2019 21:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806413;
        bh=ZVYnyXlmr4r0ZjL3OXJl4+LVg+xG9Wy3Cn8VrSg8LPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Njs8GaSx4dsD108x/x6E4iWfjsmDRJFSGKHNd0i01lAv+61lEm2Vn/HI0lGM4Byf2
         WbIXdIIJToUnYc3lQ+lVUiPHxVpjRpI7DdtEFKybe+8V+Kbf5Kzo/yNbj7fU1GWg5d
         gat7dd/pAwftCz0UVVL3B2ihtmcnIQDSgMcJBszE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.1 005/115] Revert "HID: Increase maximum report size allowed by hid_field_extract()"
Date:   Mon, 17 Jun 2019 23:08:25 +0200
Message-Id: <20190617210800.188656099@linuxfoundation.org>
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

commit 15fc1b5c86128f91c8c6699c3b0d9615740b13f1 upstream.

This reverts commit 94a9992f7dbdfb28976b565af220e0c4a117144a.

The commit allows for more than 32 bits in hid_field_extract(),
but the return value is a 32 bits int.
So basically what this commit is doing is just silencing those
legitimate errors.

Revert to a previous situation in the hope that a proper
fix will be impletemented.

Fixes: 94a9992f7dbd ("HID: Increase maximum report size allowed by hid_field_extract()")
Cc: stable@vger.kernel.org # v5.1
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1313,10 +1313,10 @@ static u32 __extract(u8 *report, unsigne
 u32 hid_field_extract(const struct hid_device *hid, u8 *report,
 			unsigned offset, unsigned n)
 {
-	if (n > 256) {
-		hid_warn(hid, "hid_field_extract() called with n (%d) > 256! (%s)\n",
+	if (n > 32) {
+		hid_warn(hid, "hid_field_extract() called with n (%d) > 32! (%s)\n",
 			 n, current->comm);
-		n = 256;
+		n = 32;
 	}
 
 	return __extract(report, offset, n);


