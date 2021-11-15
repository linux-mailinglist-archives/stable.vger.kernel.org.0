Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC91450B1D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbhKORTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:19:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:51976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236810AbhKORRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:17:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0718563257;
        Mon, 15 Nov 2021 17:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996382;
        bh=r7MT3L16rNgKpJAaZ5pMOOWvRgHtnQLKMjcpb0r11PU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXHN6WQFc5jeni+pgYjIJ2OFAPiwkVSMGRv0mMUicpM1tplMnBLzjsKHNpdhCboSp
         Q+ucPJGFknGuVCzeWP/aEGNunjWHDoJXrxd61M/HaMyvmWHJz8/5x4b7LRP8eC+8K/
         4An00q0RupaoH0k7/fZrV8OAirbX+jCordxxRLts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 119/355] platform/x86: wmi: do not fail if disabling fails
Date:   Mon, 15 Nov 2021 18:00:43 +0100
Message-Id: <20211115165317.664529395@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 59e9aa0f96436..cb029126a68c6 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -353,7 +353,14 @@ static acpi_status __query_block(struct wmi_block *wblock, u8 instance,
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



