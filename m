Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC8132AF3E
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236843AbhCCAQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:16:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1446830AbhCBMNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:13:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0EFB64F65;
        Tue,  2 Mar 2021 11:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686245;
        bh=A+8lIU4f24cYQr8XfQ3XIwVOtmvhmbXPcCuLDpUJtZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDGOAitNj19EmvTJD1MPFu016yeMplboo13yEN3s39OcYYmT91CtTHEy6koofFmP6
         aLqjLn8ZYJTVGzEv0P4JN6LoqJc562C9zGJizwBfMl+UvFme+k0pVATJOHaj0wV8tH
         joe7SCKotCOVlc5dXnR31LPBkLQLsbhBqakHgeXHqLXeHj//CJSPJVul/qSktz2C5n
         GQfwIE0hVqr91NanciuTQJXitKe36g55Axxv1UJaVkjN+lYC5xgHbTOSUgo+c0C28x
         T27Z5bLUZkOcQV7w46SrjQ1cCcOpevEC42QSSqRSB7JyFRf+Kse0/DHjbpXf8ZcdDA
         THOj0Sl67zuyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 31/47] drivers/base: build kunit tests without structleak plugin
Date:   Tue,  2 Mar 2021 06:56:30 -0500
Message-Id: <20210302115646.62291-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 38009c766725a9877ea8866fc813a5460011817f ]

The structleak plugin causes the stack frame size to grow immensely:

drivers/base/test/property-entry-test.c: In function 'pe_test_reference':
drivers/base/test/property-entry-test.c:481:1: error: the frame size of 2640 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
  481 | }
      | ^
drivers/base/test/property-entry-test.c: In function 'pe_test_uints':
drivers/base/test/property-entry-test.c:99:1: error: the frame size of 2592 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]

Turn it off in this file.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210125124533.101339-3-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/test/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/base/test/Makefile b/drivers/base/test/Makefile
index 3ca56367c84b..2f15fae8625f 100644
--- a/drivers/base/test/Makefile
+++ b/drivers/base/test/Makefile
@@ -2,3 +2,4 @@
 obj-$(CONFIG_TEST_ASYNC_DRIVER_PROBE)	+= test_async_driver_probe.o
 
 obj-$(CONFIG_KUNIT_DRIVER_PE_TEST) += property-entry-test.o
+CFLAGS_REMOVE_property-entry-test.o += -fplugin-arg-structleak_plugin-byref -fplugin-arg-structleak_plugin-byref-all
-- 
2.30.1

