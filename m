Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD2A370C7A
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233159AbhEBOG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233156AbhEBOF4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:05:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8B45613D4;
        Sun,  2 May 2021 14:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964304;
        bh=jmHrcJkeLpaMF2gfUFLZ3/4K7LZ0sMd5TJntExn0exY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZdzeZmPIBO+eLSw9U/UA2AjAZbPDEWUwPjJIiOA1R4bAMtHa1YPoPaYwBoJ97MEhL
         q8jTUjqGf/q/471+rV5Ep7C2amv7JR+/aGcr1UfSKUyWLJc9Ow0cuYHBYJ4QqZckRo
         N/sP5TQUW3syzu4elFaWOcRYJBJRg8VEXciZXH6U+H4EiL/wfxI6ryf5gIhyAr9+aD
         e7nZBoDDj9o2Bj7lPCb/5oPxgYfzkAq8MObd8FRVp1zM2I5Btjs6zh3HnzR1Bk2n1v
         mujCSpd9psHAgHTEjpN6T570jreeJdB12IOX1gxDeAD9HuWYBl/bY7QSRhtIs4Hw9F
         swc9JMqjf8JTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 24/34] usb: musb: fix PM reference leak in musb_irq_work()
Date:   Sun,  2 May 2021 10:04:24 -0400
Message-Id: <20210502140434.2719553-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 9535b99533904e9bc1607575aa8e9539a55435d7 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
thus a pairing decrement is needed.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Link: https://lore.kernel.org/r/20210408091836.55227-1-cuibixuan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/musb_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 166f68f639c2..70ef603f7bb9 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1932,7 +1932,7 @@ static void musb_irq_work(struct work_struct *data)
 	struct musb *musb = container_of(data, struct musb, irq_work.work);
 	int error;
 
-	error = pm_runtime_get_sync(musb->controller);
+	error = pm_runtime_resume_and_get(musb->controller);
 	if (error < 0) {
 		dev_err(musb->controller, "Could not enable: %i\n", error);
 
-- 
2.30.2

