Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14AD13E224
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731492AbgAPQyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:54:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728921AbgAPQyE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C27220730;
        Thu, 16 Jan 2020 16:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193644;
        bh=H4TGDuj/IGoXsgjHYEbP9PeZK/cLYnM2Qg5WbYMX6t8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFY2y+5wVsgRnfh/grr4YpYsMtEWr/4pXQyoEV08VaOXdIFYdmn9MO0Mb2rzJ3M9w
         5EeB1naN0O5TRqrLlC6V1VC2tnFCzHnFOJm7CA8qO5OCZkaj2UIo0ve9ibkZ0YL4nF
         qV3qquKA7x4yvXlfN+FBRljZpV2yAbHAsKmho1is=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>, linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 175/205] um: Don't trace irqflags during shutdown
Date:   Thu, 16 Jan 2020 11:42:30 -0500
Message-Id: <20200116164300.6705-175-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5c1f33e2a03c0b8710b5d910a46f1e1fb0607679 ]

In the main() code, we eventually enable signals just before
exec() or exit(), in order to to not have signals pending and
delivered *after* the exec().

I've observed SIGSEGV loops at this point, and the reason seems
to be the irqflags tracing; this makes sense as the kernel is
no longer really functional at this point. Since there's really
no reason to use unblock_signals_trace() here (I had just done
a global search & replace), use the plain unblock_signals() in
this case to avoid going into the no longer functional kernel.

Fixes: 0dafcbe128d2 ("um: Implement TRACE_IRQFLAGS_SUPPORT")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/os-Linux/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/os-Linux/main.c b/arch/um/os-Linux/main.c
index 8014dfac644d..c8a42ecbd7a2 100644
--- a/arch/um/os-Linux/main.c
+++ b/arch/um/os-Linux/main.c
@@ -170,7 +170,7 @@ int __init main(int argc, char **argv, char **envp)
 	 * that they won't be delivered after the exec, when
 	 * they are definitely not expected.
 	 */
-	unblock_signals_trace();
+	unblock_signals();
 
 	os_info("\n");
 	/* Reboot */
-- 
2.20.1

