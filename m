Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E3833B8BF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbhCOOEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233109AbhCOOAl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D85C64F3F;
        Mon, 15 Mar 2021 14:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816828;
        bh=ensQVPdp1x56j3abJKC2wDhARCAQg4MNTzAYhAOB52o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFlIoJ8MDvx9gH6tIDIVvXkm/ZaWuRUNDnWlOaeaTiaHvJp5XkvIEH1Z4KjjLvgeQ
         bzvLXNXzEMI3itgKL/AlhsZWAO6ddK+NqcJbC+HbevX0lqe/CAn6R7mfQg1x88LkgH
         JvQNeSyk7Qok6kXprxLYlTpGYcvWTjA0DQgSvf0E=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 149/306] drivers/base: build kunit tests without structleak plugin
Date:   Mon, 15 Mar 2021 14:53:32 +0100
Message-Id: <20210315135512.681329712@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
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



