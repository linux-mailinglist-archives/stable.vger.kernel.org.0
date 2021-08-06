Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DCE3E2594
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244306AbhHFIU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243970AbhHFIUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:20:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6297A61207;
        Fri,  6 Aug 2021 08:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237985;
        bh=m8eVRp7kvqRylifcK3gNGxLsO1GYKoZFlzGmAUzr1Bs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvJx0vIWjk5GC5wv0DiikEdim/DbG0gqRl/N+XEIwBgS1ocBIrjlzQZY3obmQmMFS
         B7jxqF6oOWt3dAR9g6+vblOfhJzTetLi0LhsQP6PHIoGmD6o8nKaJG35cipxA7HA5H
         33VHYFZOfu9O7D4kA5+E1JZOMx1Xs2k7DCs7M0ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Scally <djrscally@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 19/30] ACPI: fix NULL pointer dereference
Date:   Fri,  6 Aug 2021 10:16:57 +0200
Message-Id: <20210806081113.780004075@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
References: <20210806081113.126861800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 37dac195adbb..6ad3b89a8a2e 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -689,7 +689,8 @@ acpi_dev_get_first_match_dev(const char *hid, const char *uid, s64 hrv);
 
 static inline void acpi_dev_put(struct acpi_device *adev)
 {
-	put_device(&adev->dev);
+	if (adev)
+		put_device(&adev->dev);
 }
 #else	/* CONFIG_ACPI */
 
-- 
2.30.2



