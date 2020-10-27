Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14AA729B515
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793738AbgJ0PIF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1791013AbgJ0PF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:05:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35B9522275;
        Tue, 27 Oct 2020 15:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811157;
        bh=xlhEOzynfP14jssKdwl2/mvT5fwki824Eq4CS4Xa17c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jq7eKUBruUewuKzCQloZBrNNQ1z99sBatKL5mLW1UvHG+vW/eHGaWLVtJiX7eiGzw
         kBqh2LBk+6MbXv3fPOiBVGby41YNS6nUmYbUgYF23ntz1ZnBF2Oq1cSGc13iaYS2NO
         MY1g9RngSt82b7T28NNsjbGgy3FJ9wmklUGOsXUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 394/633] kdb: Fix pager search for multi-line strings
Date:   Tue, 27 Oct 2020 14:52:17 +0100
Message-Id: <20201027135541.191273718@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Thompson <daniel.thompson@linaro.org>

[ Upstream commit d081a6e353168f15e63eb9e9334757f20343319f ]

Currently using forward search doesn't handle multi-line strings correctly.
The search routine replaces line breaks with \0 during the search and, for
regular searches ("help | grep Common\n"), there is code after the line
has been discarded or printed to replace the break character.

However during a pager search ("help\n" followed by "/Common\n") when the
string is matched we will immediately return to normal output and the code
that should restore the \n becomes unreachable. Fix this by restoring the
replaced character when we disable the search mode and update the comment
accordingly.

Fixes: fb6daa7520f9d ("kdb: Provide forward search at more prompt")
Link: https://lore.kernel.org/r/20200909141708.338273-1-daniel.thompson@linaro.org
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/debug/kdb/kdb_io.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 683a799618ade..bc827bd547c81 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -706,12 +706,16 @@ int vkdb_printf(enum kdb_msgsrc src, const char *fmt, va_list ap)
 			size_avail = sizeof(kdb_buffer) - len;
 			goto kdb_print_out;
 		}
-		if (kdb_grepping_flag >= KDB_GREPPING_FLAG_SEARCH)
+		if (kdb_grepping_flag >= KDB_GREPPING_FLAG_SEARCH) {
 			/*
 			 * This was a interactive search (using '/' at more
-			 * prompt) and it has completed. Clear the flag.
+			 * prompt) and it has completed. Replace the \0 with
+			 * its original value to ensure multi-line strings
+			 * are handled properly, and return to normal mode.
 			 */
+			*cphold = replaced_byte;
 			kdb_grepping_flag = 0;
+		}
 		/*
 		 * at this point the string is a full line and
 		 * should be printed, up to the null.
-- 
2.25.1



