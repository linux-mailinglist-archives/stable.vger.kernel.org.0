Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE5643A32B
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235829AbhJYT4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239326AbhJYTyh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:54:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6D12611BD;
        Mon, 25 Oct 2021 19:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191120;
        bh=wHnaPwbGdkGyJ5IVRy5XqjNA7QEAET8Qz2Sy3061jyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGFvKLeQr3+jnkONI2jJbcQDzD5oGjaKroT8motRmYtjk+Coh3dHBY62FNVKbsLVn
         oQ2va7XDIXzXCImAarIH+Aszu8m7MU3NWDyl1q7ubZH5ryeJXdSSEkIJWnkwKewhx3
         2sNz2R4swvktLF9oSWYOm8L/vA/p/a+B1cLHBV6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Brendan Higgins <brendanhiggins@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 129/169] device property: build kunit tests without structleak plugin
Date:   Mon, 25 Oct 2021 21:15:10 +0200
Message-Id: <20211025191034.060674188@linuxfoundation.org>
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

From: Brendan Higgins <brendanhiggins@google.com>

[ Upstream commit 6a1e2d93d55b000962b82b9a080006446150b022 ]

The structleak plugin causes the stack frame size to grow immensely when
used with KUnit:

../drivers/base/test/property-entry-test.c:492:1: warning: the frame size of 2832 bytes is larger than 2048 bytes [-Wframe-larger-than=]
../drivers/base/test/property-entry-test.c:322:1: warning: the frame size of 2080 bytes is larger than 2048 bytes [-Wframe-larger-than=]
../drivers/base/test/property-entry-test.c:250:1: warning: the frame size of 4976 bytes is larger than 2048 bytes [-Wframe-larger-than=]
../drivers/base/test/property-entry-test.c:115:1: warning: the frame size of 3280 bytes is larger than 2048 bytes [-Wframe-larger-than=]

Turn it off in this file.

Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/test/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/test/Makefile b/drivers/base/test/Makefile
index 64b2f3d744d5..7f76fee6f989 100644
--- a/drivers/base/test/Makefile
+++ b/drivers/base/test/Makefile
@@ -2,4 +2,4 @@
 obj-$(CONFIG_TEST_ASYNC_DRIVER_PROBE)	+= test_async_driver_probe.o
 
 obj-$(CONFIG_DRIVER_PE_KUNIT_TEST) += property-entry-test.o
-CFLAGS_REMOVE_property-entry-test.o += -fplugin-arg-structleak_plugin-byref -fplugin-arg-structleak_plugin-byref-all
+CFLAGS_property-entry-test.o += $(DISABLE_STRUCTLEAK_PLUGIN)
-- 
2.33.0



