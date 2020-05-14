Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88A51D3A22
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 20:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbgENSyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728939AbgENSyF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:54:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04E972076A;
        Thu, 14 May 2020 18:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482444;
        bh=Rh2fTYQfbtq2e4tgM/2ICblYH83hEQ5MpFqNJ7lM7z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T15YdilF/Wfxvcecf5nWLwVagArUFHxVDaJ7o9JMNhGITTB+wOGl9z2HCnaCFn22F
         hAuJsVO1ppangEL/EzpOfYOL3CtJtdm+6++mzpThZhdZoq49p6i+XnzU2cQUnkArQT
         2HpF3oRgV63shzQuZhMWyoTdmETdaJNxEk7Xwnqw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 43/49] gcc-10: disable 'array-bounds' warning for now
Date:   Thu, 14 May 2020 14:53:04 -0400
Message-Id: <20200514185311.20294-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185311.20294-1-sashal@kernel.org>
References: <20200514185311.20294-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 44720996e2d79e47d508b0abe99b931a726a3197 ]

This is another fine warning, related to the 'zero-length-bounds' one,
but hitting the same historical code in the kernel.

Because C didn't historically support flexible array members, we have
code that instead uses a one-sized array, the same way we have cases of
zero-sized arrays.

The one-sized arrays come from either not wanting to use the gcc
zero-sized array extension, or from a slight convenience-feature, where
particularly for strings, the size of the structure now includes the
allocation for the final NUL character.

So with a "char name[1];" at the end of a structure, you can do things
like

       v = my_malloc(sizeof(struct vendor) + strlen(name));

and avoid the "+1" for the terminator.

Yes, the modern way to do that is with a flexible array, and using
'offsetof()' instead of 'sizeof()', and adding the "+1" by hand.  That
also technically gets the size "more correct" in that it avoids any
alignment (and thus padding) issues, but this is another long-term
cleanup thing that will not happen for 5.7.

So disable the warning for now, even though it's potentially quite
useful.  Having a slew of warnings that then hide more urgent new issues
is not an improvement.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 49c74e8b55df4..8c8ad7e25e15e 100644
--- a/Makefile
+++ b/Makefile
@@ -859,6 +859,7 @@ KBUILD_CFLAGS += $(call cc-disable-warning, stringop-truncation)
 
 # We'll want to enable this eventually, but it's not going away for 5.7 at least
 KBUILD_CFLAGS += $(call cc-disable-warning, zero-length-bounds)
+KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
 
 # Enabled with W=2, disabled by default as noisy
 KBUILD_CFLAGS += $(call cc-disable-warning, maybe-uninitialized)
-- 
2.20.1

