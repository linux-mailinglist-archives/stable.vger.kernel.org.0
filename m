Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0233C533E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352182AbhGLHyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241930AbhGLHtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:49:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C0A361991;
        Mon, 12 Jul 2021 07:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075791;
        bh=HCZcP+Ty1qnCgdKYpbkDBpUw2OYMYBhyhTyOk1EqRqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftKGog6uO2kMDTHMSYpXPxUqKeT+vQV2iFhdzFwE/tYmPBpBwWN6yGo+G1a1Kj46W
         cdlYsu6UuXsMoO3mJqB9Rntg1SVJ60sty4QzjazX9qZmJhZ57OYXpsnhubxCNuYd1k
         W++bOV2MiqQwJXcxvsBZsFlZ7gNPEzElAhCGAWAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maximilian Luz <luzmaximilian@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 365/800] HID: surface-hid: Fix get-report request
Date:   Mon, 12 Jul 2021 08:06:28 +0200
Message-Id: <20210712061005.898387612@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maximilian Luz <luzmaximilian@gmail.com>

[ Upstream commit 2b2bcc76e2ffbaff7e6ec1c62cb9c10881dc70cd ]

Getting a report (e.g. feature report) from a device requires us to send
a request indicating which report we want to retrieve and then waiting
for the corresponding response containing that report. We already
provide the response structure to the request call, but the request
isn't marked as a request that expects a response. Thus the request
returns before we receive the response and the response buffer indicates
a zero length response due to that.

This essentially means that the get-report calls are broken and will
always indicate that a report of length zero has been read.

Fix this by appropriately marking the request.

Fixes: b05ff1002a5c ("HID: Add support for Surface Aggregator Module HID transport")
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/surface-hid/surface_hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/surface-hid/surface_hid.c b/drivers/hid/surface-hid/surface_hid.c
index 3477b31611ae..a3a70e4f3f6c 100644
--- a/drivers/hid/surface-hid/surface_hid.c
+++ b/drivers/hid/surface-hid/surface_hid.c
@@ -143,7 +143,7 @@ static int ssam_hid_get_raw_report(struct surface_hid_device *shid, u8 rprt_id,
 	rqst.target_id = shid->uid.target;
 	rqst.instance_id = shid->uid.instance;
 	rqst.command_id = SURFACE_HID_CID_GET_FEATURE_REPORT;
-	rqst.flags = 0;
+	rqst.flags = SSAM_REQUEST_HAS_RESPONSE;
 	rqst.length = sizeof(rprt_id);
 	rqst.payload = &rprt_id;
 
-- 
2.30.2



