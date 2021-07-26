Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1177C3D61F8
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbhGZPdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233770AbhGZPck (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80256604AC;
        Mon, 26 Jul 2021 16:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315988;
        bh=gRO08aN6NLVwr78x0am/cMJ/XPtjSjttuudzOiZyBAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TKUQRx7pDAa3r9c12bk7o78+WUH82gFalpnl2peolwA4bwhpnfO6uj1RywkbCtm3h
         b3pVSd4gKwqXh8IDue/yjoMHUAFCh4eCaTBj9AiaIzju8XS42b/tFd2uuP024hAWvh
         skDWlz2oSnf4TMGaAufXslMRsu4vwASjPUsBgOko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Scally <djrscally@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 143/223] ACPI: fix NULL pointer dereference
Date:   Mon, 26 Jul 2021 17:38:55 +0200
Message-Id: <20210726153850.912570677@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit fc68f42aa737dc15e7665a4101d4168aadb8e4c4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/acpi/acpi_bus.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -711,7 +711,8 @@ static inline struct acpi_device *acpi_d
 
 static inline void acpi_dev_put(struct acpi_device *adev)
 {
-	put_device(&adev->dev);
+	if (adev)
+		put_device(&adev->dev);
 }
 #else	/* CONFIG_ACPI */
 


