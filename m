Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96864CA9AA
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392605AbfJCQqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:46:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732423AbfJCQp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:45:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DB95215EA;
        Thu,  3 Oct 2019 16:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121157;
        bh=n0YP2zWRVCxk4rF17AJs7NMY8AhDufGUs2cq5yP0HdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lcdk7BHy4fGonZlYvD0OkiRxadkExY7FNI4I8fJDuV+oRdLc0puWQUaNCkMPZMdnd
         ddAfjClY21bMfeMkdw+t3Xy1jL+bIz1h8c3EoIAskEsyOTd162mZdqhALRhKSGwHu2
         0YR1EVo00a+CvkVIM+E/biL7pH60lhLV6JI7S36c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Murray <andrew.murray@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 174/344] jump_label: Dont warn on __exit jump entries
Date:   Thu,  3 Oct 2019 17:52:19 +0200
Message-Id: <20191003154557.391502578@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



