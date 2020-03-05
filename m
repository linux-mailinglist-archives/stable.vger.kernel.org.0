Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809E917ACA1
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbgCERO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:14:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbgCEROY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:24 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7272621739;
        Thu,  5 Mar 2020 17:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428464;
        bh=pJVC9i/QPbvPIH+sJdfj6m0BKMTWaYXmsMkok+iVz6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbYXLUHc5mfzRjPCN6wRNpLERm631urH87QZMtuEMbCEaYzS2mceC3W334T1oswet
         03XLTHdJgtcxohI86c5J43HUT4amsEECWgWxtpcCQe75/9h9e4XZZpadbHaFseZ58G
         8uny5PqbK4W6mKRBRhTxyNTOMWITCgKrRxGgNftY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Korsnes <jkorsnes@cisco.com>,
        Armando Visconti <armando.visconti@st.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/58] HID: core: fix off-by-one memset in hid_report_raw_event()
Date:   Thu,  5 Mar 2020 12:13:24 -0500
Message-Id: <20200305171420.29595-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171420.29595-1-sashal@kernel.org>
References: <20200305171420.29595-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Korsnes <jkorsnes@cisco.com>

[ Upstream commit 5ebdffd25098898aff1249ae2f7dbfddd76d8f8f ]

In case a report is greater than HID_MAX_BUFFER_SIZE, it is truncated,
but the report-number byte is not correctly handled. This results in a
off-by-one in the following memset, causing a kernel Oops and ensuing
system crash.

Note: With commit 8ec321e96e05 ("HID: Fix slab-out-of-bounds read in
hid_field_extract") I no longer hit the kernel Oops as we instead fail
"controlled" at probe if there is a report too long in the HID
report-descriptor. hid_report_raw_event() is an exported symbol, so
presumabely we cannot always rely on this being the case.

Fixes: 966922f26c7f ("HID: fix a crash in hid_report_raw_event()
                     function.")
Signed-off-by: Johan Korsnes <jkorsnes@cisco.com>
Cc: Armando Visconti <armando.visconti@st.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 851fe54ea59e7..359616e3efbbb 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1741,7 +1741,9 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
 
 	rsize = ((report->size - 1) >> 3) + 1;
 
-	if (rsize > HID_MAX_BUFFER_SIZE)
+	if (report_enum->numbered && rsize >= HID_MAX_BUFFER_SIZE)
+		rsize = HID_MAX_BUFFER_SIZE - 1;
+	else if (rsize > HID_MAX_BUFFER_SIZE)
 		rsize = HID_MAX_BUFFER_SIZE;
 
 	if (csize < rsize) {
-- 
2.20.1

