Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53148621B0
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733061AbfGHPSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:18:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728609AbfGHPSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:18:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71180216C4;
        Mon,  8 Jul 2019 15:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599112;
        bh=d37ICMBKvoimNiAqVg+adZ7Qd5e54zOXaNlzOgph3Rw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTDGMpI2mUzwZ/v2JpNWs047RQUzhdanuBnhakwJ9E810+KcOiABC9k75nSLrDVf9
         D7e6QAUXMaUjmuiukPwTKOeUf+8hZLKs4tQ1FoIeWbsOxrcOLX+nvjy10zyoSTsBCB
         0wlHXzIALq+d4WgXRPtuzuV6UWFRZixr9KJdsnCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 010/102] parisc: Fix compiler warnings in float emulation code
Date:   Mon,  8 Jul 2019 17:12:03 +0200
Message-Id: <20190708150526.580835739@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150525.973820964@linuxfoundation.org>
References: <20190708150525.973820964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



