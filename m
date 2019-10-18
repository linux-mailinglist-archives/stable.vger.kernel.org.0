Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B986EDD44A
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729321AbfJRWFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729303AbfJRWFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:05:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BCD1222C2;
        Fri, 18 Oct 2019 22:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436312;
        bh=IEy/Uf64WWx5r28Ky/7zeFyYJNzL1e4yhFukKOfLYi8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2udVMMqVdQ0ofSkB9+mNrjpa0I2q/ebAVS4NPV6Ji6S+uam1oDd19TIzQkREXBad
         hf55RlCgg5jsCZWCmM6KkBlm6uxFp3hvGwiEXQv+HBOjegsOLrSKXm4ZS7A/c8HX8i
         yEZXTB42O9DOnxdi39JbTLqShBuc57R4NrBCBntc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, linux-mips@linux-mips.org
Subject: [PATCH AUTOSEL 5.3 81/89] MIPS: fw: sni: Fix out of bounds init of o32 stack
Date:   Fri, 18 Oct 2019 18:03:16 -0400
Message-Id: <20191018220324.8165-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit efcb529694c3b707dc0471b312944337ba16e4dd ]

Use ARRAY_SIZE to caluculate the top of the o32 stack.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/fw/sni/sniprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/fw/sni/sniprom.c b/arch/mips/fw/sni/sniprom.c
index 8772617b64cef..80112f2298b68 100644
--- a/arch/mips/fw/sni/sniprom.c
+++ b/arch/mips/fw/sni/sniprom.c
@@ -43,7 +43,7 @@
 
 /* O32 stack has to be 8-byte aligned. */
 static u64 o32_stk[4096];
-#define O32_STK	  &o32_stk[sizeof(o32_stk)]
+#define O32_STK	  (&o32_stk[ARRAY_SIZE(o32_stk)])
 
 #define __PROM_O32(fun, arg) fun arg __asm__(#fun); \
 				     __asm__(#fun " = call_o32")
-- 
2.20.1

