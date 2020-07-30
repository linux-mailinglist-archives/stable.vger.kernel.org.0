Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB3A233A05
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 22:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbgG3Uv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 16:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728778AbgG3Uv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 16:51:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAFCC061575
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 13:51:27 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u12so35457887ybj.0
        for <stable@vger.kernel.org>; Thu, 30 Jul 2020 13:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=G95KKuekTz1iA7Zr8ZdyT9EdDFTvRs8dYtvTVOv4Dfc=;
        b=ViS1JlQVeIZx1+sasiczEhUQiJqT9BJ3+cGlNfVvdmsU9R2mLheJZdbOTUgKPav/+p
         5pdrAapxvRSoKlz+chL0Gy18OCbJssl+aqaycS4dtpZekMdniwmfHSE28+u/htN+H2l+
         lzAV54E++V9VAVcItllAAJIR59b/yWJz3F+UzYTyFBu/N5BqHonoSRohu96fk/lK3LEL
         0FlD+6rYx6p5mrUR2jhCMNL3Mk/QYxpV5o//SYtwl8PLWXae6OWyWZcWxICKQUEdXgj8
         g1z85D6nN1NBUXBVWo8pSEl6use+HV+VDaOcghe11TQpqrFnYk0mdJa+xoPyhRvpSBPa
         46FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=G95KKuekTz1iA7Zr8ZdyT9EdDFTvRs8dYtvTVOv4Dfc=;
        b=qEHUoJfPTmywOWb1nVbMxFjnOzMbN+CEgPi+J6oTXR6rUhMCwfncqrC9Utadn/lyZe
         Nh/F3lZDIOWhhhxUaeERTBuhqACOKFhA5K9C7UVfg9m5YyGwWLOcbL1a+F34XoKKgrGP
         oeu5TFHQhyFvz7tLje2J1ax3hjAy6Ewczisp7+YeYhbJe+IVLA0Ij4DFAZoRzVK2nWAc
         ZklpGqYt5J+zcTqPJQcUyNHGRjfzFUFKuwf8XT00tLBHyuya2fsR0+/CHyipOT2jOlJh
         uMgixcW6wDphzXimA2VOSBiJi1H/yu7VHM55PGZfuDyNyW+2f83v3Ds6RpzTcD1PQTJL
         v83A==
X-Gm-Message-State: AOAM530jLUTS/wXeECPySBQZqCyoa/CiQIo8UOZMLGk1EpaKht5geLqc
        kzRyVEyFfJwljE8r9GvGwonCJpkAkFmYOnpI/6w=
X-Google-Smtp-Source: ABdhPJx9IM+NZ+Dy+UO1H89OWuA1mQwu+ABN06cb8h6aN7Xpr4/KTHo0SHpRsO8t4uShHvxZa2ijHx26yaXliUNcOww=
X-Received: by 2002:a25:40cb:: with SMTP id n194mr1171359yba.380.1596142286622;
 Thu, 30 Jul 2020 13:51:26 -0700 (PDT)
Date:   Thu, 30 Jul 2020 13:51:09 -0700
In-Reply-To: <20200730205112.2099429-1-ndesaulniers@google.com>
Message-Id: <20200730205112.2099429-2-ndesaulniers@google.com>
Mime-Version: 1.0
References: <20200730205112.2099429-1-ndesaulniers@google.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH 1/4] ARM: backtrace-clang: check for NULL lr
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Nathan Huckleberry <nhuck15@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        clang-built-linux@googlegroups.com,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Lvqiang Huang <lvqiang.huang@unisoc.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miles Chen <miles.chen@mediatek.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the link register was zeroed out, do not attempt to use it for
address calculations for which there are currently no fixup handlers,
which can lead to a panic during unwind. Since panicking triggers
another unwind, this can lead to an infinite loop.  If this occurs
during start_kernel(), this can prevent a kernel from booting.

commit 59b6359dd92d ("ARM: 8702/1: head-common.S: Clear lr before jumping to start_kernel()")
intentionally zeros out the link register in __mmap_switched which tail
calls into start kernel. Test for this condition so that we can stop
unwinding when initiated within start_kernel() correctly.

Cc: stable@vger.kernel.org
Fixes: commit 6dc5fd93b2f1 ("ARM: 8900/1: UNWINDER_FRAME_POINTER implementation for Clang")
Reported-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 arch/arm/lib/backtrace-clang.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/lib/backtrace-clang.S b/arch/arm/lib/backtrace-clang.S
index 6174c45f53a5..5388ac664c12 100644
--- a/arch/arm/lib/backtrace-clang.S
+++ b/arch/arm/lib/backtrace-clang.S
@@ -144,6 +144,8 @@ for_each_frame:	tst	frame, mask		@ Check for address exceptions
  */
 1003:		ldr	sv_lr, [sv_fp, #4]	@ get saved lr from next frame
 
+		tst	sv_lr, #0		@ If there's no previous lr,
+		beq	finished_setup		@ we're done.
 		ldr	r0, [sv_lr, #-4]	@ get call instruction
 		ldr	r3, .Lopcode+4
 		and	r2, r3, r0		@ is this a bl call
-- 
2.28.0.163.g6104cc2f0b6-goog

