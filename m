Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CF3378196
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhEJK1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231549AbhEJK07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:26:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26FBD61493;
        Mon, 10 May 2021 10:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642354;
        bh=jmHrcJkeLpaMF2gfUFLZ3/4K7LZ0sMd5TJntExn0exY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TKCiNSV0FRg1at1Vkh8nqIYxrBfOv4W9Elmnd+cQU4vTCEm94a/bZ0v6/9SIk19MQ
         F0Ee1F0qbUVwSemYYS8B0R7EFhainrpLcSYJfAkmBunfLHy+rAz3bA0hoIKSGQngO/
         cIPFcGuimBAdilkEnbSW0QeZQmKxkkGeI5hHnfcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Bixuan Cui <cuibixuan@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/184] usb: musb: fix PM reference leak in musb_irq_work()
Date:   Mon, 10 May 2021 12:19:15 +0200
Message-Id: <20210510101952.207680162@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



