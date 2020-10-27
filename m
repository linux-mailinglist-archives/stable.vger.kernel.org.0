Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4147F29C4B5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1823038AbgJ0R45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2509116AbgJ0OUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:20:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79150206FA;
        Tue, 27 Oct 2020 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808433;
        bh=JZO0FMmtG4vn/Ir8BKBtAao/jx/uemYfhrNZ6ukyQ5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7gxS0Q5HNCRgz4ov+QdR1oqxMCEn+E/83rOKvI365w+1tJr7YGbwIuyxoeSb+8MC
         +43y2X6eSxt4+09ADyKWYufHBT3DceJ5O06JW+KyEC2F3An6YAznNmChJyU3csLFRI
         PCDpdFEfMfZL4gDffHknk4p0lNC5xjOnBVxUp8WU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Andrew Morton <akpm@osdl.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 090/264] video: fbdev: sis: fix null ptr dereference
Date:   Tue, 27 Oct 2020 14:52:28 +0100
Message-Id: <20201027135434.926617654@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit ad6f93e9cd56f0b10e9b22e3e137d17a1a035242 ]

Clang static analysis reports this representative error

init.c:2501:18: warning: Array access (from variable 'queuedata') results
  in a null pointer dereference
      templ |= ((queuedata[i] & 0xc0) << 3);

This is the problem block of code

   if(ModeNo > 0x13) {
      ...
      if(SiS_Pr->ChipType == SIS_730) {
	 queuedata = &FQBQData730[0];
      } else {
	 queuedata = &FQBQData[0];
      }
   } else {

   }

queuedata is not set in the else block

Reviewing the old code, the arrays FQBQData730 and FQBQData were
used directly.

So hoist the setting of queuedata out of the if-else block.

Fixes: 544393fe584d ("[PATCH] sisfb update")
Signed-off-by: Tom Rix <trix@redhat.com>
Cc: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Andrew Morton <akpm@osdl.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200805145208.17727-1-trix@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/sis/init.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/sis/init.c b/drivers/video/fbdev/sis/init.c
index dfe3eb769638b..fde27feae5d0c 100644
--- a/drivers/video/fbdev/sis/init.c
+++ b/drivers/video/fbdev/sis/init.c
@@ -2428,6 +2428,11 @@ SiS_SetCRT1FIFO_630(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
 
    i = 0;
 
+	if (SiS_Pr->ChipType == SIS_730)
+		queuedata = &FQBQData730[0];
+	else
+		queuedata = &FQBQData[0];
+
    if(ModeNo > 0x13) {
 
       /* Get VCLK  */
@@ -2445,12 +2450,6 @@ SiS_SetCRT1FIFO_630(struct SiS_Private *SiS_Pr, unsigned short ModeNo,
       /* Get half colordepth */
       colorth = colortharray[(SiS_Pr->SiS_ModeType - ModeEGA)];
 
-      if(SiS_Pr->ChipType == SIS_730) {
-	 queuedata = &FQBQData730[0];
-      } else {
-	 queuedata = &FQBQData[0];
-      }
-
       do {
 	 templ = SiS_CalcDelay2(SiS_Pr, queuedata[i]) * VCLK * colorth;
 
-- 
2.25.1



