Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFFF45BD57
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240872AbhKXMh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:37:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344098AbhKXMfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:35:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF2E46109D;
        Wed, 24 Nov 2021 12:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756485;
        bh=/xHtoZ7MQQLQoyuWuljeDGAuf8KEEVV43WgNkGu2r88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYbKiDmaqMLElPTYL2SFSTsIAECucSG7STPXsVOWCELqb8Zi4Nckr9cloIQU/QuUf
         2eUYgbWC1hHGeYx6hZ+H5N3A0D1W9r1FcltDvR7KrpBNgYZ9s02L7qblKs+SCNamkN
         AS4hsWC+z3EkeCg0xZjNXGxAYrUUg+hcHr2p35PY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 070/251] platform/x86: wmi: do not fail if disabling fails
Date:   Wed, 24 Nov 2021 12:55:12 +0100
Message-Id: <20211124115712.682130118@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Barnabás Pőcze <pobrn@protonmail.com>

[ Upstream commit 1975718c488a39128f1f515b23ae61a5a214cc3d ]

Previously, `__query_block()` would fail if the
second WCxx method call failed. However, the
WQxx method might have succeeded, and potentially
allocated memory for the result. Instead of
throwing away the result and potentially
leaking memory, ignore the result of
the second WCxx call.

Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>
Link: https://lore.kernel.org/r/20210904175450.156801-25-pobrn@protonmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index a56e997816b23..07c1e0829b19a 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -307,7 +307,14 @@ static acpi_status __query_block(struct wmi_block *wblock, u8 instance,
 	 * the WQxx method failed - we should disable collection anyway.
 	 */
 	if ((block->flags & ACPI_WMI_EXPENSIVE) && ACPI_SUCCESS(wc_status)) {
-		status = acpi_execute_simple_method(handle, wc_method, 0);
+		/*
+		 * Ignore whether this WCxx call succeeds or not since
+		 * the previously executed WQxx method call might have
+		 * succeeded, and returning the failing status code
+		 * of this call would throw away the result of the WQxx
+		 * call, potentially leaking memory.
+		 */
+		acpi_execute_simple_method(handle, wc_method, 0);
 	}
 
 	return status;
-- 
2.33.0



