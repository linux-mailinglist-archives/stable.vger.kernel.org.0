Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0489B3110D6
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhBERaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:30:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233468AbhBEP7m (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:59:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AA2C6502A;
        Fri,  5 Feb 2021 14:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534285;
        bh=7tNhC8ulhDtwMtSaZXJRxLWlcNzh4K3Z0fdcmoEtpOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHjEas38vVqojxjAbWA7WLloHEtJ7ECjDkTfc51NxDB0SwlCh+PuG0Jv29vFnTLB3
         tN8aCnQbsSAmg+LFJd6ddaNPkVF3f2CKG0vXCiIJpmMnUPLuZ9cMlyr7c7wTgrBGCR
         Dm790fIQ8hVjQUWO9wRpPlr6oOV6+sotaXRdqnTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 54/57] objtool: Dont fail the kernel build on fatal errors
Date:   Fri,  5 Feb 2021 15:07:20 +0100
Message-Id: <20210205140658.306208184@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit 655cf86548a3938538642a6df27dd359e13c86bd ]

This is basically a revert of commit 644592d32837 ("objtool: Fail the
kernel build on fatal errors").

That change turned out to be more trouble than it's worth.  Failing the
build is an extreme measure which sometimes gets too much attention and
blocks CI build testing.

These fatal-type warnings aren't yet as rare as we'd hope, due to the
ever-increasing matrix of supported toolchains/plugins and their
fast-changing nature as of late.

Also, there are more people (and bots) looking for objtool warnings than
ever before, so even non-fatal warnings aren't likely to be ignored for
long.

Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index c6ab44543c92a..956383d5fa62e 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2921,14 +2921,10 @@ int check(struct objtool_file *file)
 	warnings += ret;
 
 out:
-	if (ret < 0) {
-		/*
-		 *  Fatal error.  The binary is corrupt or otherwise broken in
-		 *  some way, or objtool itself is broken.  Fail the kernel
-		 *  build.
-		 */
-		return ret;
-	}
-
+	/*
+	 *  For now, don't fail the kernel build on fatal warnings.  These
+	 *  errors are still fairly common due to the growing matrix of
+	 *  supported toolchains and their recent pace of change.
+	 */
 	return 0;
 }
-- 
2.27.0



