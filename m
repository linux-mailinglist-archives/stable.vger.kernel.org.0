Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD4D43A33E
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239687AbhJYT53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235571AbhJYTzI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:55:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B52461261;
        Mon, 25 Oct 2021 19:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191128;
        bh=CujmvpHIs6lbGStzSlLrCfn8XAToEiZUTO4Y5Fj20hA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q0iT3NePbRLID9dzydnnT6ZH+YNSvkas5gd44ZpeCf7Sx3tj22ywqTUcqax8ZYjWB
         U9/3iBx0q6YyqWYBt+aIh8YrOdblbjSMvc04WRkvIIFhOoVv845OYuGiSbEtLj5GNS
         ekdVb4Ax9IgnMzf0Lo2MKi4ekjCwKz9vDJn+Nbvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Brendan Higgins <brendanhiggins@google.com>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 131/169] bitfield: build kunit tests without structleak plugin
Date:   Mon, 25 Oct 2021 21:15:12 +0200
Message-Id: <20211025191034.321207574@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a8cf90332ae3e2b53813a146a99261b6a5e16a73 ]

The structleak plugin causes the stack frame size to grow immensely:

lib/bitfield_kunit.c: In function 'test_bitfields_constants':
lib/bitfield_kunit.c:93:1: error: the frame size of 7440 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

Turn it off in this file.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Makefile b/lib/Makefile
index 5efd1b435a37..a841be5244ac 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -351,7 +351,7 @@ obj-$(CONFIG_OBJAGG) += objagg.o
 obj-$(CONFIG_PLDMFW) += pldmfw/
 
 # KUnit tests
-CFLAGS_bitfield_kunit.o := $(call cc-option,-Wframe-larger-than=10240)
+CFLAGS_bitfield_kunit.o := $(DISABLE_STRUCTLEAK_PLUGIN)
 obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
 obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
-- 
2.33.0



