Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E1433B945
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234841AbhCOOFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233106AbhCOOBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B26464F47;
        Mon, 15 Mar 2021 14:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816854;
        bh=ensQVPdp1x56j3abJKC2wDhARCAQg4MNTzAYhAOB52o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8Gr0o5e9I59Lnk8Xi3TuUPE9x7i5C/yJwnTqSXte1eH4RfCbuP150ZfApkDHrc0L
         cDAsTBVmbXeULhlgvtw4WKI6HIdLpZQa5w24Yax7IESzlOG0zhMyIL9ds63bK75HV1
         MufqGtcbT5e/oC3qfIcpbEa0Ey/paUm92BPxeNEY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/290] drivers/base: build kunit tests without structleak plugin
Date:   Mon, 15 Mar 2021 14:54:06 +0100
Message-Id: <20210315135547.094708395@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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



