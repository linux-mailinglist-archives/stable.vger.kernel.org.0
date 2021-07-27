Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838FC3D7685
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbhG0N37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:29:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236949AbhG0NU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:20:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7D9661AED;
        Tue, 27 Jul 2021 13:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627392014;
        bh=k5J0mZNQw20SNwxhrdAmA8y1cCG4pluSg0R+QmQnye4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEHwJAOyk0uRis/Scjdj2wd/+V4A1zE4oSwPfBFSdzi/Zdni70M/vDETGSjpEbina
         I7WZ65l0TJuRXT84vYVbYTd58JNzvsuFL2+XPePL94NwBUdhfJfVzDMSfaK9QW0WJm
         E64B0bDuclNCQ7LhzTg+PLDrFOeVj98jbNS5zdF5gkYTV3jykW9rYvoQl6m1PGAg43
         uQBj8x6/FOGRydes7XBh0vgh+vijZpTnaW7+YwHmtxia0hP8EciubpHs9/5dmO/XqT
         fSJMaumURtr/3ddeW+aXNVlaE+CbaiMj9ltUlMgOYuM6C5uElXSXYvmtlG1Jc5/9tz
         5pg0uk93KNpDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Daniel Scally <djrscally@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 5.4 9/9] ACPI: fix NULL pointer dereference
Date:   Tue, 27 Jul 2021 09:20:01 -0400
Message-Id: <20210727132002.835130-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727132002.835130-1-sashal@kernel.org>
References: <20210727132002.835130-1-sashal@kernel.org>
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
index 4d67a67964fa..1e5ae3b01eb2 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -681,7 +681,8 @@ acpi_dev_get_first_match_dev(const char *hid, const char *uid, s64 hrv);
 
 static inline void acpi_dev_put(struct acpi_device *adev)
 {
-	put_device(&adev->dev);
+	if (adev)
+		put_device(&adev->dev);
 }
 #else	/* CONFIG_ACPI */
 
-- 
2.30.2

