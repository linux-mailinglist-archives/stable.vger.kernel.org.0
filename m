Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78C13442C9
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhCVMpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232679AbhCVMnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:43:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C5B1619D5;
        Mon, 22 Mar 2021 12:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416865;
        bh=1bawS5OTku2R6D5ze2GbkygzAGmlVC9GfgjGVO+5eIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5b97X73FN8ntE83pnZ6zgu9y4/LlLRhL+SRtjdDjvjyfUIgH+Nrehde+lO/EXaO2
         nzisWLuW9sBQjhPe+neo3uSZg0/Q3PZ1vrRwEX571IvOO50Pa6LdmrfLLegyqht3IT
         arXe1CwV19aczEEvRevJTVOrbb2psOk0vBUYAe7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 153/157] static_call: Fix static_call_update() sanity check
Date:   Mon, 22 Mar 2021 13:28:30 +0100
Message-Id: <20210322121938.596306243@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 38c93587375053c5b9ef093f4a5ea754538cba32 upstream.

Sites that match init_section_contains() get marked as INIT. For
built-in code init_sections contains both __init and __exit text. OTOH
kernel_text_address() only explicitly includes __init text (and there
are no __exit text markers).

Match what jump_label already does and ignore the warning for INIT
sites. Also see the excellent changelog for commit: 8f35eaa5f2de
("jump_label: Don't warn on __exit jump entries")

Fixes: 9183c3f9ed710 ("static_call: Add inline static call infrastructure")
Reported-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Sumit Garg <sumit.garg@linaro.org>
Link: https://lkml.kernel.org/r/20210318113610.739542434@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/jump_label.c  |    8 ++++++++
 kernel/static_call.c |   11 ++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -407,6 +407,14 @@ static bool jump_label_can_update(struct
 		return false;
 
 	if (!kernel_text_address(jump_entry_code(entry))) {
+		/*
+		 * This skips patching built-in __exit, which
+		 * is part of init_section_contains() but is
+		 * not part of kernel_text_address().
+		 *
+		 * Skipping built-in __exit is fine since it
+		 * will never be executed.
+		 */
 		WARN_ONCE(!jump_entry_is_init(entry),
 			  "can't patch jump_label at %pS",
 			  (void *)jump_entry_code(entry));
--- a/kernel/static_call.c
+++ b/kernel/static_call.c
@@ -182,7 +182,16 @@ void __static_call_update(struct static_
 			}
 
 			if (!kernel_text_address((unsigned long)site_addr)) {
-				WARN_ONCE(1, "can't patch static call site at %pS",
+				/*
+				 * This skips patching built-in __exit, which
+				 * is part of init_section_contains() but is
+				 * not part of kernel_text_address().
+				 *
+				 * Skipping built-in __exit is fine since it
+				 * will never be executed.
+				 */
+				WARN_ONCE(!static_call_is_init(site),
+					  "can't patch static call site at %pS",
 					  site_addr);
 				continue;
 			}


