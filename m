Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B45624FD
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390965AbfGHPrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:43178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733147AbfGHPTE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:19:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E58221537;
        Mon,  8 Jul 2019 15:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599143;
        bh=7SOyGxXUyKgnF2RBPDDk0vkQ0YmwBw4ow/U9fFAQ/kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IauCUPloCggEKkoif+F8AQv5lFrJQakPeWl27Afjel8OHI3i02ZCdUlAHWt9tDrUo
         87YtvHmk0nkqzL2DO1/4Av2zD8XZEODNrnN/rnL2N3dVO1IC7p7WKZ9eM4talkCyfk
         uqHnLLbZgVmhLjxhoyBN3y9L6iG+abty3FL1fpvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 002/102] gcc-9: silence address-of-packed-member warning
Date:   Mon,  8 Jul 2019 17:11:55 +0200
Message-Id: <20190708150526.106087644@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 6f303d60534c46aa1a239f29c321f95c83dda748 upstream.

We already did this for clang, but now gcc has that warning too.  Yes,
yes, the address may be unaligned.  And that's kind of the point.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -647,6 +647,7 @@ KBUILD_CFLAGS	+= $(call cc-disable-warni
 KBUILD_CFLAGS	+= $(call cc-disable-warning, format-truncation)
 KBUILD_CFLAGS	+= $(call cc-disable-warning, format-overflow)
 KBUILD_CFLAGS	+= $(call cc-disable-warning, int-in-bool-context)
+KBUILD_CFLAGS	+= $(call cc-disable-warning, address-of-packed-member)
 KBUILD_CFLAGS	+= $(call cc-disable-warning, attribute-alias)
 
 ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
@@ -718,7 +719,6 @@ ifeq ($(cc-name),clang)
 KBUILD_CPPFLAGS += $(call cc-option,-Qunused-arguments,)
 KBUILD_CFLAGS += $(call cc-disable-warning, format-invalid-specifier)
 KBUILD_CFLAGS += $(call cc-disable-warning, gnu)
-KBUILD_CFLAGS += $(call cc-disable-warning, address-of-packed-member)
 # Quiet clang warning: comparison of unsigned expression < 0 is always false
 KBUILD_CFLAGS += $(call cc-disable-warning, tautological-compare)
 # CLANG uses a _MergedGlobals as optimization, but this breaks modpost, as the


