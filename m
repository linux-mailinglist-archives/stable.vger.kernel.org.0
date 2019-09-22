Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63ADBA44F
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391176AbfIVSrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:47:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391165AbfIVSrs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:47:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F15C2186A;
        Sun, 22 Sep 2019 18:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178068;
        bh=n0YP2zWRVCxk4rF17AJs7NMY8AhDufGUs2cq5yP0HdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSX8+Oh+JsILnGqh8pFgizAoBKEUohZSur/eMkgrjf0/QwIqqBqB6+YOwow4fYsDu
         u6OEUdEXbBUiHZx4g5Hf7BKZcT8+loM+ooEsYedaIS8klpiOvBMf6JP/ZNVAaR5/iA
         6gQgCp5znYU4mf9OLzEY4CYHUs8T1sbpsQP1rygA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Murray <andrew.murray@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 141/203] jump_label: Don't warn on __exit jump entries
Date:   Sun, 22 Sep 2019 14:42:47 -0400
Message-Id: <20190922184350.30563-141-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Murray <andrew.murray@arm.com>

[ Upstream commit 8f35eaa5f2de020073a48ad51112237c5932cfcc ]

On architectures that discard .exit.* sections at runtime, a
warning is printed for each jump label that is used within an
in-kernel __exit annotated function:

can't patch jump_label at ehci_hcd_cleanup+0x8/0x3c
WARNING: CPU: 0 PID: 1 at kernel/jump_label.c:410 __jump_label_update+0x12c/0x138

As these functions will never get executed (they are free'd along
with the rest of initmem) - we do not need to patch them and should
not display any warnings.

The warning is displayed because the test required to satisfy
jump_entry_is_init is based on init_section_contains (__init_begin to
__init_end) whereas the test in __jump_label_update is based on
init_kernel_text (_sinittext to _einittext) via kernel_text_address).

Fixes: 19483677684b ("jump_label: Annotate entries that operate on __init code earlier")
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/jump_label.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index df3008419a1d0..cdb3ffab128b6 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -407,7 +407,9 @@ static bool jump_label_can_update(struct jump_entry *entry, bool init)
 		return false;
 
 	if (!kernel_text_address(jump_entry_code(entry))) {
-		WARN_ONCE(1, "can't patch jump_label at %pS", (void *)jump_entry_code(entry));
+		WARN_ONCE(!jump_entry_is_init(entry),
+			  "can't patch jump_label at %pS",
+			  (void *)jump_entry_code(entry));
 		return false;
 	}
 
-- 
2.20.1

