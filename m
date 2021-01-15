Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B9A2F7A91
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387636AbhAOMvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:51:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387790AbhAOMgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:36:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDB18223E0;
        Fri, 15 Jan 2021 12:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714145;
        bh=w/CCngwlvQXfR6R9z2V8zA7OSINpshvyHzofDEeKu5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CYsWm8NKp6FzqKBTJSBxHIXdUtetVYS+pDRws9kQ3v8A7o45JFEYIP8GW7tLb1AmT
         V49ru03U+n1Gr5IE9Zjbihvaxeq/9HyCrd4IexcDQ68SgFVD1fhCU09+k7HO+EOttN
         +lc23JKgQ5cwcR/XXNlFnyqypSk0ibpCYZcEL8r0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 50/62] lightnvm: select CONFIG_CRC32
Date:   Fri, 15 Jan 2021 13:28:12 +0100
Message-Id: <20210115122000.806755044@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 19cd3403cb0d522dd5e10188eef85817de29e26e upstream.

Without CRC32 support, this fails to link:

arm-linux-gnueabi-ld: drivers/lightnvm/pblk-init.o: in function `pblk_init':
pblk-init.c:(.text+0x2654): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/lightnvm/pblk-init.o: in function `pblk_exit':
pblk-init.c:(.text+0x2a7c): undefined reference to `crc32_le'

Fixes: a4bd217b4326 ("lightnvm: physical block device (pblk) target")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/lightnvm/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/lightnvm/Kconfig
+++ b/drivers/lightnvm/Kconfig
@@ -19,6 +19,7 @@ if NVM
 
 config NVM_PBLK
 	tristate "Physical Block Device Open-Channel SSD target"
+	select CRC32
 	help
 	  Allows an open-channel SSD to be exposed as a block device to the
 	  host. The target assumes the device exposes raw flash and must be


