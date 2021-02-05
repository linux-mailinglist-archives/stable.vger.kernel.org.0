Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434C6311103
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 20:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbhBERjc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 12:39:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233443AbhBEP5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:57:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF51265090;
        Fri,  5 Feb 2021 14:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534425;
        bh=8eU1kZakRpD69eguGY0XAU41DgXoTE2EH38U74TnHSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYkff4pvXYOyVbCkENnw4nOlbJF2O629Gw4HvLORzofXyTJmomxxnB6uDYnrUGS/H
         TgTXru9iOEIhWrX/R2h/l8Ugm494LCY9gVJHUAKjIe8WnegnFRBrPKIQUGWQwmGan5
         Hh2gImgcXtiO5e00jCcHS5z64HMpvLR5p6t0EXpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Libor Pechacek <lpechacek@suse.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/17] selftests/powerpc: Only test lwm/stmw on big endian
Date:   Fri,  5 Feb 2021 15:08:08 +0100
Message-Id: <20210205140650.385701195@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.825180779@linuxfoundation.org>
References: <20210205140649.825180779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit dd3a44c06f7b4f14e90065bf05d62c255b20005f ]

Newer binutils (>= 2.36) refuse to assemble lmw/stmw when building in
little endian mode. That breaks compilation of our alignment handler
test:

  /tmp/cco4l14N.s: Assembler messages:
  /tmp/cco4l14N.s:1440: Error: `lmw' invalid when little-endian
  /tmp/cco4l14N.s:1814: Error: `stmw' invalid when little-endian
  make[2]: *** [../../lib.mk:139: /output/kselftest/powerpc/alignment/alignment_handler] Error 1

These tests do pass on little endian machines, as the kernel will
still emulate those instructions even when running little
endian (which is arguably a kernel bug).

But we don't really need to test that case, so ifdef those
instructions out to get the alignment test building again.

Reported-by: Libor Pechacek <lpechacek@suse.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Tested-by: Libor Pechacek <lpechacek@suse.com>
Link: https://lore.kernel.org/r/20210119041800.3093047-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/powerpc/alignment/alignment_handler.c  | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/alignment/alignment_handler.c b/tools/testing/selftests/powerpc/alignment/alignment_handler.c
index 169a8b9719fb9..4f8335e0c9858 100644
--- a/tools/testing/selftests/powerpc/alignment/alignment_handler.c
+++ b/tools/testing/selftests/powerpc/alignment/alignment_handler.c
@@ -384,7 +384,6 @@ int test_alignment_handler_integer(void)
 	LOAD_DFORM_TEST(ldu);
 	LOAD_XFORM_TEST(ldx);
 	LOAD_XFORM_TEST(ldux);
-	LOAD_DFORM_TEST(lmw);
 	STORE_DFORM_TEST(stb);
 	STORE_XFORM_TEST(stbx);
 	STORE_DFORM_TEST(stbu);
@@ -403,7 +402,11 @@ int test_alignment_handler_integer(void)
 	STORE_XFORM_TEST(stdx);
 	STORE_DFORM_TEST(stdu);
 	STORE_XFORM_TEST(stdux);
+
+#ifdef __BIG_ENDIAN__
+	LOAD_DFORM_TEST(lmw);
 	STORE_DFORM_TEST(stmw);
+#endif
 
 	return rc;
 }
-- 
2.27.0



