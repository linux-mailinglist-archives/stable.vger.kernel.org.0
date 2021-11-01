Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3244E44162C
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhKAJXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232197AbhKAJWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81EEA610EA;
        Mon,  1 Nov 2021 09:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758374;
        bh=maQ4MxNKY5L3TnTiUTYt57su3TfHoFW3ctaqN1+9/BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFIq6oEeltQLE4hQ8rG0Y2O6LoheDQhKc/e6xYF7NxA78gaVM6vcN7Pve+PlsbecV
         S9uM1hPfPRuaH91i4LxUCvBqKFdlDbQVW02+qqEm0rA3ymcQWua/iJlwNP4E6uTTFJ
         t9ViYEsvwCngmbV61yqDeZ0owjgToQqb5VeZLK6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 4.9 17/20] nios2: Make NIOS2_DTB_SOURCE_BOOL depend on !COMPILE_TEST
Date:   Mon,  1 Nov 2021 10:17:26 +0100
Message-Id: <20211101082447.774151497@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082444.133899096@linuxfoundation.org>
References: <20211101082444.133899096@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

commit 4a089e95b4d6bb625044d47aed0c442a8f7bd093 upstream.

nios2:allmodconfig builds fail with

make[1]: *** No rule to make target 'arch/nios2/boot/dts/""',
	needed by 'arch/nios2/boot/dts/built-in.a'.  Stop.
make: [Makefile:1868: arch/nios2/boot/dts] Error 2 (ignored)

This is seen with compile tests since those enable NIOS2_DTB_SOURCE_BOOL,
which in turn enables NIOS2_DTB_SOURCE. This causes the build error
because the default value for NIOS2_DTB_SOURCE is an empty string.
Disable NIOS2_DTB_SOURCE_BOOL for compile tests to avoid the error.

Fixes: 2fc8483fdcde ("nios2: Build infrastructure")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/nios2/platform/Kconfig.platform |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/nios2/platform/Kconfig.platform
+++ b/arch/nios2/platform/Kconfig.platform
@@ -37,6 +37,7 @@ config NIOS2_DTB_PHYS_ADDR
 
 config NIOS2_DTB_SOURCE_BOOL
 	bool "Compile and link device tree into kernel image"
+	depends on !COMPILE_TEST
 	default n
 	help
 	  This allows you to specify a dts (device tree source) file


