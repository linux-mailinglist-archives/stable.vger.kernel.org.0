Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED701F2E8C
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgFIAmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729089AbgFHXM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8075120C09;
        Mon,  8 Jun 2020 23:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657947;
        bh=ZTIsX73d20iSdcbXGG9Igm0SR8pILM4kweFvdrEtmjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJku1xQVUPrQzzGidFLR3WXAUh5rkt3HMvlto2k6xXJ1EjtkTC9hI9EiXXUEHp3Ci
         V4s3WwxueyVGP4QBWafSgOrNOhdnlKVKqC0JSitewq0kPUN+2jwnvE2Uk12Hp45Zwn
         kqz8zmixBnarkJ200Jb8pIJTkakClo0gIFwgsCOU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 012/606] gcc-10: disable 'array-bounds' warning for now
Date:   Mon,  8 Jun 2020 19:02:17 -0400
Message-Id: <20200608231211.3363633-12-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 44720996e2d79e47d508b0abe99b931a726a3197 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index b1ce2a7a25b0..e7c2811856f1 100644
--- a/Makefile
+++ b/Makefile
@@ -859,6 +859,7 @@ KBUILD_CFLAGS += $(call cc-disable-warning, stringop-truncation)
 
 # We'll want to enable this eventually, but it's not going away for 5.7 at least
 KBUILD_CFLAGS += $(call cc-disable-warning, zero-length-bounds)
+KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
 
 # Enabled with W=2, disabled by default as noisy
 KBUILD_CFLAGS += $(call cc-disable-warning, maybe-uninitialized)
-- 
2.25.1

