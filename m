Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE543D769A
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbhG0NaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236738AbhG0NUQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F13661ABC;
        Tue, 27 Jul 2021 13:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391977;
        bh=CAXc8LZihg7Es+984OqvWcmER3uPykOlQi6083aw+5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktEqGYXftZmybaNR253XPfpQAELy5b42ROT0tMyw4u0tlWvfMMSIMyLCzhOvoBJYD
         5dOLWaEP6XhNuF8d3dA/TJtQq1t33ll8yd/Z9/NxmVtzJDXR+0q0f+Z8PHjA9lv9ql
         WG6wu4iel52UC6i23rkpEdpMPWI5mjGPYMDJL0x4k7T8lJRtkcOs/W++9v6TOhw8rN
         Wye/ABj2M90Pr7R87b9flNMTXdrugk9rCZ3QhSwRSHIEzr/K4LR6nwgu4cXhEqFqdM
         QHiuvBU31Z7iScJkew+8yItfkugahbVBQ6qSBGEgScgZGnCy7Lrzs5C9rAkz9M6qU8
         qxteXEJqrD31w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Daniel Scally <djrscally@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.13 21/21] ACPI: fix NULL pointer dereference
Date:   Tue, 27 Jul 2021 09:19:08 -0400
Message-Id: <20210727131908.834086-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131908.834086-1-sashal@kernel.org>
References: <20210727131908.834086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit fc68f42aa737dc15e7665a4101d4168aadb8e4c4 ]

Commit 71f642833284 ("ACPI: utils: Fix reference counting in
for_each_acpi_dev_match()") started doing "acpi_dev_put()" on a pointer
that was possibly NULL.  That fails miserably, because that helper
inline function is not set up to handle that case.

Just make acpi_dev_put() silently accept a NULL pointer, rather than
calling down to put_device() with an invalid offset off that NULL
pointer.

Link: https://lore.kernel.org/lkml/a607c149-6bf6-0fd0-0e31-100378504da2@kernel.dk/
Reported-and-tested-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Daniel Scally <djrscally@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/acpi/acpi_bus.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 3a82faac5767..cd98af6ba155 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -716,7 +716,8 @@ static inline struct acpi_device *acpi_dev_get(struct acpi_device *adev)
 
 static inline void acpi_dev_put(struct acpi_device *adev)
 {
-	put_device(&adev->dev);
+	if (adev)
+		put_device(&adev->dev);
 }
 #else	/* CONFIG_ACPI */
 
-- 
2.30.2

