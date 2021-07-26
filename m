Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92583D5D7A
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235597AbhGZPBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:40774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235606AbhGZPBi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:01:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C053860F37;
        Mon, 26 Jul 2021 15:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314127;
        bh=JfxhRDXSCZ5rsxg7bPn6nFqZE5y+4xJFrqfVZLUcIn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkWVZP6a62eO/xh8TTUeGgjKXqDe0BE2YJ6cTqYVN9r7/ayEzxZeYK8pIziISHSqa
         sBbNdRHT23/FRxJzn9RzOSQP8n4yOC8ijoB/VfJVbn2uqU0y/Q8ppei7EDohutHt6H
         wSoa8d0zNfQEDZ99w0vA0nanVxy8vzm0G7Pd3Fdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 4.4 43/47] media: ngene: Fix out-of-bounds bug in ngene_command_config_free_buf()
Date:   Mon, 26 Jul 2021 17:39:01 +0200
Message-Id: <20210726153824.330703924@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
References: <20210726153822.980271128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit 8d4abca95ecc82fc8c41912fa0085281f19cc29f upstream.

Fix an 11-year old bug in ngene_command_config_free_buf() while
addressing the following warnings caught with -Warray-bounds:

arch/alpha/include/asm/string.h:22:16: warning: '__builtin_memcpy' offset [12, 16] from the object at 'com' is out of the bounds of referenced subobject 'config' with type 'unsigned char' at offset 10 [-Warray-bounds]
arch/x86/include/asm/string_32.h:182:25: warning: '__builtin_memcpy' offset [12, 16] from the object at 'com' is out of the bounds of referenced subobject 'config' with type 'unsigned char' at offset 10 [-Warray-bounds]

The problem is that the original code is trying to copy 6 bytes of
data into a one-byte size member _config_ of the wrong structue
FW_CONFIGURE_BUFFERS, in a single call to memcpy(). This causes a
legitimate compiler warning because memcpy() overruns the length
of &com.cmd.ConfigureBuffers.config. It seems that the right
structure is FW_CONFIGURE_FREE_BUFFERS, instead, because it contains
6 more members apart from the header _hdr_. Also, the name of
the function ngene_command_config_free_buf() suggests that the actual
intention is to ConfigureFreeBuffers, instead of ConfigureBuffers
(which takes place in the function ngene_command_config_buf(), above).

Fix this by enclosing those 6 members of struct FW_CONFIGURE_FREE_BUFFERS
into new struct config, and use &com.cmd.ConfigureFreeBuffers.config as
the destination address, instead of &com.cmd.ConfigureBuffers.config,
when calling memcpy().

This also helps with the ongoing efforts to globally enable
-Warray-bounds and get us closer to being able to tighten the
FORTIFY_SOURCE routines on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Fixes: dae52d009fc9 ("V4L/DVB: ngene: Initial check-in")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/linux-hardening/20210420001631.GA45456@embeddedor/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/ngene/ngene-core.c |    2 +-
 drivers/media/pci/ngene/ngene.h      |   14 ++++++++------
 2 files changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -402,7 +402,7 @@ static int ngene_command_config_free_buf
 
 	com.cmd.hdr.Opcode = CMD_CONFIGURE_FREE_BUFFER;
 	com.cmd.hdr.Length = 6;
-	memcpy(&com.cmd.ConfigureBuffers.config, config, 6);
+	memcpy(&com.cmd.ConfigureFreeBuffers.config, config, 6);
 	com.in_len = 6;
 	com.out_len = 0;
 
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -407,12 +407,14 @@ enum _BUFFER_CONFIGS {
 
 struct FW_CONFIGURE_FREE_BUFFERS {
 	struct FW_HEADER hdr;
-	u8   UVI1_BufferLength;
-	u8   UVI2_BufferLength;
-	u8   TVO_BufferLength;
-	u8   AUD1_BufferLength;
-	u8   AUD2_BufferLength;
-	u8   TVA_BufferLength;
+	struct {
+		u8   UVI1_BufferLength;
+		u8   UVI2_BufferLength;
+		u8   TVO_BufferLength;
+		u8   AUD1_BufferLength;
+		u8   AUD2_BufferLength;
+		u8   TVA_BufferLength;
+	} __packed config;
 } __attribute__ ((__packed__));
 
 struct FW_CONFIGURE_UART {


