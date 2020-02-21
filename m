Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7ABB1675C2
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733226AbgBUIOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:14:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732492AbgBUIOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:14:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A42AA24670;
        Fri, 21 Feb 2020 08:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272887;
        bh=hDDi7NfkHyAkUUnTbKQGRytKtjAXcZBx1AojSyMOTjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+mUhSB+L/4xHwI2sLVHH79pkNKFV1ZHQzGNiwuhehikdGo5XlX00pCGsAvT49tbU
         lVZ3dx1M1Du46YMYjGnk7ld+vlTvG32For/QgBfX/1ByQTBC/TXgrg89M3cpOK+MhN
         zcLSSQFkfHdMH/OA78jo+qz/L/4DzhWNpXW+FIvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Eric Biggers <ebiggers@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 312/344] char: hpet: Fix out-of-bounds read bug
Date:   Fri, 21 Feb 2020 08:41:51 +0100
Message-Id: <20200221072418.378382693@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

[ Upstream commit 98c49f1746ac44ccc164e914b9a44183fad09f51 ]

Currently, there is an out-of-bounds read on array hpetp->hp_dev
in the following for loop:

870         for (i = 0; i < hdp->hd_nirqs; i++)
871                 hpetp->hp_dev[i].hd_hdwirq = hdp->hd_irq[i];

This is due to the recent change from one-element array to
flexible-array member in struct hpets:

104 struct hpets {
	...
113         struct hpet_dev hp_dev[];
114 };

This change affected the total size of the dynamic memory
allocation, decreasing it by one time the size of struct hpet_dev.

Fix this by adjusting the allocation size when calling
struct_size().

Fixes: 987f028b8637c ("char: hpet: Use flexible-array member")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Link: https://lore.kernel.org/r/20200129022613.GA24281@embeddedor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hpet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 9ac6671bb5141..f69609b47fef8 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -855,7 +855,7 @@ int hpet_alloc(struct hpet_data *hdp)
 		return 0;
 	}
 
-	hpetp = kzalloc(struct_size(hpetp, hp_dev, hdp->hd_nirqs - 1),
+	hpetp = kzalloc(struct_size(hpetp, hp_dev, hdp->hd_nirqs),
 			GFP_KERNEL);
 
 	if (!hpetp)
-- 
2.20.1



