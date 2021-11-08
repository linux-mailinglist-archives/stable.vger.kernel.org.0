Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DF744A20D
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242098AbhKIBQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:16:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:40982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242082AbhKIBMx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:12:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0328F61A8E;
        Tue,  9 Nov 2021 01:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419921;
        bh=RdyAUPeWHwqSaZcCBqjgldY7s4d+hnJI9k5HpUxAa28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+PqNWvJBnV0se24GhMNzVrCLdBorwiCBzgwywLXPKs1FOSRRIuHsucuz9dQL3KEL
         YsYpMKHPR/GrmHTF421/v9G1EM8PcA8LG+vzyNoP+AbPNf8R2anrYZYV4FJ+Dqrf/r
         QysDytnLWc8eMjLSsx5rpmR6gpXHWBifEO+I+ISSNrxk29rG+KVF91dCWPdwh3onKD
         ESVZdKJqEaIvO93GfQgaMS2UDDeVdyznPZIWJYG/VMBon/7khlNV4LD12zqHDKd1mI
         b3tFQihMCEYkbSN6pnJ8B0M4DFN2uH4p7xoR0UIA6mZAw9taQ7ZqhFwDJOHJCaahnP
         b7LI9k1RnlzsQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 04/47] platform/x86: wmi: do not fail if disabling fails
Date:   Mon,  8 Nov 2021 12:49:48 -0500
Message-Id: <20211108175031.1190422-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 35cdc3998eb59..387358af685c5 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -350,7 +350,14 @@ static acpi_status __query_block(struct wmi_block *wblock, u8 instance,
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

