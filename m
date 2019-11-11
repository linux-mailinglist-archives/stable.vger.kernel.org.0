Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2E9F7F14
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfKKSfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:35:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728413AbfKKSff (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:35:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA079214E0;
        Mon, 11 Nov 2019 18:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497335;
        bh=6VIKjkADuQVWzy7sSUCb36dA36xQEKAE3RYlBg5BnCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uq9S/CcGv/2CbRY1du1SC2fhlfhi13wycmboyNaqpTtNF7u0Oq4dEea+WtKfRf/YK
         Uqhym80QjLCoJwAtiq1+/Y379t24ClWx+2Iy6ZeF0DX42HKOcJ4nNzROky156SAMvn
         dR7v3fmjpdAZzlBB/+IgfqdJ0/Pxln8HBj6l8vqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 4.14 019/105] tools: gpio: Use !building_out_of_srctree to determine srctree
Date:   Mon, 11 Nov 2019 19:27:49 +0100
Message-Id: <20191111181433.608041362@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 4a6a6f5c4aeedb72db871d60bfcca89835f317aa upstream.

make TARGETS=gpio kselftest fails with:

Makefile:23: tools/build/Makefile.include: No such file or directory

When the gpio tool make is invoked from tools Makefile, srctree is
cleared and the current logic check for srctree equals to empty
string to determine srctree location from CURDIR.

When the build in invoked from selftests/gpio Makefile, the srctree
is set to "." and the same logic used for srctree equals to empty is
needed to determine srctree.

Check building_out_of_srctree undefined as the condition for both
cases to fix "make TARGETS=gpio kselftest" build failure.

Cc: stable@vger.kernel.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/gpio/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/gpio/Makefile
+++ b/tools/gpio/Makefile
@@ -3,7 +3,11 @@ include ../scripts/Makefile.include
 
 bindir ?= /usr/bin
 
-ifeq ($(srctree),)
+# This will work when gpio is built in tools env. where srctree
+# isn't set and when invoked from selftests build, where srctree
+# is set to ".". building_out_of_srctree is undefined for in srctree
+# builds
+ifndef building_out_of_srctree
 srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 endif


