Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0223E1CAB68
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbgEHMnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:43:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:41028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728628AbgEHMnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B94624973;
        Fri,  8 May 2020 12:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941800;
        bh=o09AbihFk1U8cZaNVlDxAFf6s2POqISJ26OQPdbCOUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTadYBaYnE7aoj/586UqtVDXHvw/7zd4tMmW3bW8UYL2miGxCBnhwan5UpAl/qiUi
         Je/Cw+MAdInQxaQ0WnqFSCMvsCCLRNvQP36EP2Y8by5eB07mQ4oKIUeE0bgKGe9ZiM
         HKzCEZnL35XX+BWoYyPi2dT0BkspQtVG/6Xo0PGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Milo Kim <milo.kim@ti.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 176/312] mfd: lp8788-irq: Uninitialized variable in irq handler
Date:   Fri,  8 May 2020 14:32:47 +0200
Message-Id: <20200508123136.871251981@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 22aab38e7b59fd79ce1045006be69a9abab58e5a upstream.

Instead to being true/false, the "handled" is true/uninitialized.
Presumably this doesn't cause that many problems in real life because
normally we handle the IRQ.

Fixes: eea6b7cc53aa ('mfd: Add lp8788 mfd driver')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Milo Kim <milo.kim@ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/lp8788-irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/lp8788-irq.c
+++ b/drivers/mfd/lp8788-irq.c
@@ -112,7 +112,7 @@ static irqreturn_t lp8788_irq_handler(in
 	struct lp8788_irq_data *irqd = ptr;
 	struct lp8788 *lp = irqd->lp;
 	u8 status[NUM_REGS], addr, mask;
-	bool handled;
+	bool handled = false;
 	int i;
 
 	if (lp8788_read_multi_bytes(lp, LP8788_INT_1, status, NUM_REGS))


