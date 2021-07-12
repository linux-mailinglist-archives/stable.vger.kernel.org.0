Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C33E3C5259
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242236AbhGLHpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:51092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344298AbhGLHnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:43:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BFB961208;
        Mon, 12 Jul 2021 07:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075611;
        bh=LzbG7fXZjrsaRA8HcC06b775tF3WKW6YxniWQfninkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQO0NCssbatKFj8qrRPi5V45x0bM0LCibeLCgUa5A3Q7rGyRPDJtds5vc79Gl/BCv
         nlI8v99z0CjLzi+OYTgHkD8HEO6o1jQvd3yqY8pYSpZ0LF0MVG1iHvbjDmDv2ubPTz
         1xFUTWmQZ+a+26S9ga8Ngpq8NRl2McZafUrJgVGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Richey <joerichey@google.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 286/800] x86/elf: Use _BITUL() macro in UAPI headers
Date:   Mon, 12 Jul 2021 08:05:09 +0200
Message-Id: <20210712060955.225706519@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Richey <joerichey@google.com>

[ Upstream commit d06aca989c243dd9e5d3e20aa4e5c2ecfdd07050 ]

Replace BIT() in x86's UAPI header with _BITUL(). BIT() is not defined
in the UAPI headers and its usage may cause userspace build errors.

Fixes: 742c45c3ecc9 ("x86/elf: Enumerate kernel FSGSBASE capability in AT_HWCAP2")
Signed-off-by: Joe Richey <joerichey@google.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210521085849.37676-2-joerichey94@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/uapi/asm/hwcap2.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/hwcap2.h b/arch/x86/include/uapi/asm/hwcap2.h
index 5fdfcb47000f..054604aba9f0 100644
--- a/arch/x86/include/uapi/asm/hwcap2.h
+++ b/arch/x86/include/uapi/asm/hwcap2.h
@@ -2,10 +2,12 @@
 #ifndef _ASM_X86_HWCAP2_H
 #define _ASM_X86_HWCAP2_H
 
+#include <linux/const.h>
+
 /* MONITOR/MWAIT enabled in Ring 3 */
-#define HWCAP2_RING3MWAIT		(1 << 0)
+#define HWCAP2_RING3MWAIT		_BITUL(0)
 
 /* Kernel allows FSGSBASE instructions available in Ring 3 */
-#define HWCAP2_FSGSBASE			BIT(1)
+#define HWCAP2_FSGSBASE			_BITUL(1)
 
 #endif
-- 
2.30.2



