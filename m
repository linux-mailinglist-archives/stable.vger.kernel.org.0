Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5472E1065CE
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfKVG0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:26:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbfKVFuk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0950C2071C;
        Fri, 22 Nov 2019 05:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401839;
        bh=Ql9x8nBLRruSTrj/axpdo25m6wC+H80WPeR0h+hYPu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fa8IE+auH7bNqpDrTWeyFOq3CyzulDLsTcGjS/A5nsP8Wkg1yzHNeMEljkb/Zfwu3
         FY7J0KsmR5RsiqNhE9kGjK+spJFxUJw7fK/pNbDjWJU/xijMji3wQv98IyaE08io5M
         fiS2sL3klxqWZ1U82IMX8nPhnN6hdQll835Kg84I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrea Righi <righi.andrea@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 4.19 080/219] kprobes/x86/xen: blacklist non-attachable xen interrupt functions
Date:   Fri, 22 Nov 2019 00:46:52 -0500
Message-Id: <20191122054911.1750-73-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrea Righi <righi.andrea@gmail.com>

[ Upstream commit bf9445a33ae6ac2f0822d2f1ce1365408387d568 ]

Blacklist symbols in Xen probe-prohibited areas, so that user can see
these prohibited symbols in debugfs.

See also: a50480cb6d61.

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/xen-asm_64.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/xen/xen-asm_64.S b/arch/x86/xen/xen-asm_64.S
index 3a6feed76dfc1..a93d8a7cef26c 100644
--- a/arch/x86/xen/xen-asm_64.S
+++ b/arch/x86/xen/xen-asm_64.S
@@ -12,6 +12,7 @@
 #include <asm/segment.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
+#include <asm/asm.h>
 
 #include <xen/interface/xen.h>
 
@@ -24,6 +25,7 @@ ENTRY(xen_\name)
 	pop %r11
 	jmp  \name
 END(xen_\name)
+_ASM_NOKPROBE(xen_\name)
 .endm
 
 xen_pv_trap divide_error
-- 
2.20.1

