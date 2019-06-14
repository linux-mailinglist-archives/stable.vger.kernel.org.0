Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1742346AC9
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 22:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbfFNUif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 16:38:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726688AbfFNU3C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 16:29:02 -0400
Received: from sasha-vm.mshome.net (unknown [131.107.159.134])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 617112184D;
        Fri, 14 Jun 2019 20:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560544141;
        bh=+sGlqvlLqmA22YlA2dqVbaydWxLo8aCW4MixVvyHZdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1+oq9r5f0UucZARlZAhj582JAN3uosja3b3myigP1W8I3ScwJGVsTe56taTVCZeu
         XGEeRJkcf1XrnqJPuymcD3XWH+7ZCS4tROQM7aYqVmoLU8iqDml2C7m0I1dEVGG2kr
         r9cNlzKsvB5g1z/85EGzGP9BDIgoWXO/KVWNF0qU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 19/59] parisc: Fix compiler warnings in float emulation code
Date:   Fri, 14 Jun 2019 16:28:03 -0400
Message-Id: <20190614202843.26941-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614202843.26941-1-sashal@kernel.org>
References: <20190614202843.26941-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

[ Upstream commit 6b98d9134e14f5ef4bcf64b27eedf484ed19a1ec ]

Avoid such compiler warnings:
arch/parisc/math-emu/cnv_float.h:71:27: warning: ‘<<’ in boolean context, did you mean ‘<’ ? [-Wint-in-bool-context]
     ((Dintp1(dint_valueA) << 33 - SGL_EXP_LENGTH) || Dintp2(dint_valueB))
arch/parisc/math-emu/fcnvxf.c:257:6: note: in expansion of macro ‘Dint_isinexact_to_sgl’
  if (Dint_isinexact_to_sgl(srcp1,srcp2)) {

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/math-emu/cnv_float.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/math-emu/cnv_float.h b/arch/parisc/math-emu/cnv_float.h
index 933423fa5144..b0db61188a61 100644
--- a/arch/parisc/math-emu/cnv_float.h
+++ b/arch/parisc/math-emu/cnv_float.h
@@ -60,19 +60,19 @@
     ((exponent < (SGL_P - 1)) ?				\
      (Sall(sgl_value) << (SGL_EXP_LENGTH + 1 + exponent)) : FALSE)
 
-#define Int_isinexact_to_sgl(int_value)	(int_value << 33 - SGL_EXP_LENGTH)
+#define Int_isinexact_to_sgl(int_value)	((int_value << 33 - SGL_EXP_LENGTH) != 0)
 
 #define Sgl_roundnearest_from_int(int_value,sgl_value)			\
     if (int_value & 1<<(SGL_EXP_LENGTH - 2))   /* round bit */		\
-    	if ((int_value << 34 - SGL_EXP_LENGTH) || Slow(sgl_value))	\
+	if (((int_value << 34 - SGL_EXP_LENGTH) != 0) || Slow(sgl_value)) \
 		Sall(sgl_value)++
 
 #define Dint_isinexact_to_sgl(dint_valueA,dint_valueB)		\
-    ((Dintp1(dint_valueA) << 33 - SGL_EXP_LENGTH) || Dintp2(dint_valueB))
+    (((Dintp1(dint_valueA) << 33 - SGL_EXP_LENGTH) != 0) || Dintp2(dint_valueB))
 
 #define Sgl_roundnearest_from_dint(dint_valueA,dint_valueB,sgl_value)	\
     if (Dintp1(dint_valueA) & 1<<(SGL_EXP_LENGTH - 2)) 			\
-    	if ((Dintp1(dint_valueA) << 34 - SGL_EXP_LENGTH) ||		\
+	if (((Dintp1(dint_valueA) << 34 - SGL_EXP_LENGTH) != 0) ||	\
     	Dintp2(dint_valueB) || Slow(sgl_value)) Sall(sgl_value)++
 
 #define Dint_isinexact_to_dbl(dint_value) 	\
-- 
2.20.1

