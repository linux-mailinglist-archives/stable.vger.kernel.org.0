Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE3431456B2
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731712AbgAVN2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:28:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731597AbgAVN2k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:28:40 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF65820678;
        Wed, 22 Jan 2020 13:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699719;
        bh=5FSKRFfW6wddOTy4Vlusz6443sxjlfwb3l7KRaDwDng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPzjafmdp+fA/N0eVzY5xeLB14rlqc9bMGrINDkVAkXXWFehIX5xHzdgPmMjcIyJh
         3yBH3SajcVkC5EOMRTVNrFJpUJ8luBKMuVT0Je3AHzGNZvlBl0ehwc7fcT0l3Zx0W5
         F8bn+/l7a3uGBBGZREQnYrywi1jIZHw9LJdcmdBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.4 196/222] um: Dont trace irqflags during shutdown
Date:   Wed, 22 Jan 2020 10:29:42 +0100
Message-Id: <20200122092847.746688593@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 5c1f33e2a03c0b8710b5d910a46f1e1fb0607679 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/um/os-Linux/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/um/os-Linux/main.c
+++ b/arch/um/os-Linux/main.c
@@ -170,7 +170,7 @@ int __init main(int argc, char **argv, c
 	 * that they won't be delivered after the exec, when
 	 * they are definitely not expected.
 	 */
-	unblock_signals_trace();
+	unblock_signals();
 
 	os_info("\n");
 	/* Reboot */


