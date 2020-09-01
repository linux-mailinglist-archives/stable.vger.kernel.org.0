Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6481259483
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731495AbgIAPk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:40:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729063AbgIAPk0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:40:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C674920866;
        Tue,  1 Sep 2020 15:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974826;
        bh=pcV0oajEnpm+aZV6RyAIZ2HIm69x7JgW03C8QV9BoQY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AR5j3FWhmkb/xGv9yYe7bNHf3LPKT++jAsPt7f01xRgRCT9OzZ98m6RgO8j81oOde
         63ZUHdk/XgDn7dGHl9vbD1W3K6mJCICdIdEHYDJkNtPlIG7Km+rvpiUUyNTs0INE7R
         6VRA86pL/1FscSKlqj3NQHvatFCtG6b+GwWlfWvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 105/255] video: fbdev: controlfb: Fix build for COMPILE_TEST=y && PPC_PMAC=n
Date:   Tue,  1 Sep 2020 17:09:21 +0200
Message-Id: <20200901151005.744355680@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 4d618b9f3fcab84e9ec28c180de46fb2c929d096 ]

The build is currently broken, if COMPILE_TEST=y and PPC_PMAC=n:

  linux/drivers/video/fbdev/controlfb.c: In function ‘control_set_hardware’:
  linux/drivers/video/fbdev/controlfb.c:276:2: error: implicit declaration of function ‘btext_update_display’
    276 |  btext_update_display(p->frame_buffer_phys + CTRLFB_OFF,
        |  ^~~~~~~~~~~~~~~~~~~~

Fix it by including btext.h whenever CONFIG_BOOTX_TEXT is enabled.

Fixes: a07a63b0e24d ("video: fbdev: controlfb: add COMPILE_TEST support")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://lore.kernel.org/r/20200821104910.3363818-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/controlfb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/fbdev/controlfb.c b/drivers/video/fbdev/controlfb.c
index 9c4f1be856eca..547abeb39f87a 100644
--- a/drivers/video/fbdev/controlfb.c
+++ b/drivers/video/fbdev/controlfb.c
@@ -49,6 +49,8 @@
 #include <linux/cuda.h>
 #ifdef CONFIG_PPC_PMAC
 #include <asm/prom.h>
+#endif
+#ifdef CONFIG_BOOTX_TEXT
 #include <asm/btext.h>
 #endif
 
-- 
2.25.1



