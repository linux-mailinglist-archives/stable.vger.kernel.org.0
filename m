Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6347C35D1E
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 14:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfFEMoe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 08:44:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46566 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727732AbfFEMoe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Jun 2019 08:44:34 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8996F308338F;
        Wed,  5 Jun 2019 12:44:30 +0000 (UTC)
Received: from plouf.redhat.com (ovpn-116-164.ams2.redhat.com [10.36.116.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 288D960CD6;
        Wed,  5 Jun 2019 12:44:27 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] Revert "HID: Increase maximum report size allowed by hid_field_extract()"
Date:   Wed,  5 Jun 2019 14:44:05 +0200
Message-Id: <20190605124408.8637-2-benjamin.tissoires@redhat.com>
In-Reply-To: <20190605124408.8637-1-benjamin.tissoires@redhat.com>
References: <20190605124408.8637-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 05 Jun 2019 12:44:34 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 94a9992f7dbdfb28976b565af220e0c4a117144a.

The commit allows for more than 32 bits in hid_field_extract(),
but the return value is a 32 bits int.
So basically what this commit is doing is just silencing those
legitimate errors.

Revert to a previous situation in the hope that a proper
fix will be impletemented.

Fixes: 94a9992f7dbd ("HID: Increase maximum report size allowed by hid_field_extract()")
Cc: stable@vger.kernel.org # v5.1
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 08d310723e96..205d6b82a706 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1311,10 +1311,10 @@ static u32 __extract(u8 *report, unsigned offset, int n)
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
-- 
2.19.2

