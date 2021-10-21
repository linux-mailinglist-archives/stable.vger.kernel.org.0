Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98B964356E3
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhJUAXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:23:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231430AbhJUAXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:23:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66C4261212;
        Thu, 21 Oct 2021 00:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775652;
        bh=wHnaPwbGdkGyJ5IVRy5XqjNA7QEAET8Qz2Sy3061jyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFKc2gpzJzJ6DJ02S69+Q0EwUOwWxv9dlU2uzeI+pp1R0NxrwPHQglgU5prId9ymb
         UQ9qHXGtgnbsz+P+adzgB/B3D97mf03RNicLE8nku6juvd2HF23Jq+0u8nP3WH7Emg
         0jCQJ3mAuM5bwDjgBSF9LVk2KcHMvcJBqzMYXwZ0DzHcYVYaOU/AIYz4YyZ+dltRzr
         8Da+TGObV7XPaexDy6PYsGSPedn/PfUDPB+q4HjkB0ADheomGIZxW+u/6QpFxdS3rI
         2kBAyI9/A9A+Uvs1klqXup8jBzuVDypsFmVCBL9MA7rkTS6SRs/TQHObi/plFCIJY0
         OZwxW+Fx8F7qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        npache@redhat.com
Subject: [PATCH AUTOSEL 5.14 05/26] device property: build kunit tests without structleak plugin
Date:   Wed, 20 Oct 2021 20:20:02 -0400
Message-Id: <20211021002023.1128949-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

