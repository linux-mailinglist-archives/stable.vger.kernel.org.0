Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD98915EB43
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404039AbgBNRTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:19:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:36544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390874AbgBNQKw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:10:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 115142469B;
        Fri, 14 Feb 2020 16:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696650;
        bh=H1Pl5C7u+IIKGTxmcgLvipyZTnbCfoWKS0ajJ064jvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLHAhSg0tot9fINKKCHcm9jJHWfyxup/pB2wFkadS3CtPAVvUDpKzEPwGBvMcMvI+
         ntlMnQggLaMvAGoRzlnSQK7uq/i2c67MkqWILoCaJTVHy2Vj6LpA6TM/FhS9KwP1JZ
         8fNPiNmNcCAuB0/iaPDBmCPYYh6eQo7xKlyjZTh4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Eric Biggers <ebiggers@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 426/459] char: hpet: Fix out-of-bounds read bug
Date:   Fri, 14 Feb 2020 11:01:16 -0500
Message-Id: <20200214160149.11681-426-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

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
index aed2c45f7968c..ed3b7dab678db 100644
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

