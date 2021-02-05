Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066EB311470
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhBEWGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:06:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:44348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232817AbhBEOwO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C912B65018;
        Fri,  5 Feb 2021 14:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534256;
        bh=mfiiNN2iZPRQejpl2BGTt2sEn3eQDVkN/A1SY07Oq/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XCpM0PpVwxtZ2CGsenE8drxWFFNLDSu+ViKxeMKlIxyJZYSQkVbbOFxEjPM4ajjb+
         1FfeAeRO+axY90raabrxEFrkW75gg8n//b/NmB2biyt9hnzk0GgUTROOeBOvUN3XTq
         U4s9ixdLbtMbbwvMpjVvJS3zqwpIrS7MSjz43lww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Libor Pechacek <lpechacek@suse.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/57] selftests/powerpc: Only test lwm/stmw on big endian
Date:   Fri,  5 Feb 2021 15:07:11 +0100
Message-Id: <20210205140657.911974385@linuxfoundation.org>
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
index cb53a8b777e68..c25cf7cd45e9f 100644
--- a/tools/testing/selftests/powerpc/alignment/alignment_handler.c
+++ b/tools/testing/selftests/powerpc/alignment/alignment_handler.c
@@ -443,7 +443,6 @@ int test_alignment_handler_integer(void)
 	LOAD_DFORM_TEST(ldu);
 	LOAD_XFORM_TEST(ldx);
 	LOAD_XFORM_TEST(ldux);
-	LOAD_DFORM_TEST(lmw);
 	STORE_DFORM_TEST(stb);
 	STORE_XFORM_TEST(stbx);
 	STORE_DFORM_TEST(stbu);
@@ -462,7 +461,11 @@ int test_alignment_handler_integer(void)
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



