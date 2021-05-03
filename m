Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2CE371CFC
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbhECQ5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234970AbhECQzS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:55:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D401161938;
        Mon,  3 May 2021 16:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060160;
        bh=nHKqf+ia+pBTvLRLxNJX69EmoMpzURZPC99nq04ng0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tehL+Bsv1q7+mT43bGI1DHrHir1tFyIaZgVvcQzJ9ILU+cQ/7harFIYzRI/EX35fu
         G9ZkGg0eQ+xEZyn8q69sf/2HXewS6X8pVpmyGlPkpI+cvK65vXsfiv61u+/EbGiaXY
         ubk9WDWwB8AJQfeQdH41p+/FIhThmrCzbP8pR6JlCIZYY5euClNxyMmFOiSMszMHyL
         2vQ+x87BJvq4GndSPA3iR8r8TTFXrLDnYnzZvDXU12jjlRnvW37lzsxJuxRounp1Ub
         f4QW3LmyW0FI/iJTDcr5/xxwzgnqiOKpLrKhLQsGk4/MjORQ8okkWlcE7beDaAyrqS
         l8CX7gWu/T1eg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 24/31] media: i2c: adv7842: fix possible use-after-free in adv7842_remove()
Date:   Mon,  3 May 2021 12:41:57 -0400
Message-Id: <20210503164204.2854178-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164204.2854178-1-sashal@kernel.org>
References: <20210503164204.2854178-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 4a15275b6a18597079f18241c87511406575179a ]

This driver's remove path calls cancel_delayed_work(). However, that
function does not wait until the work function finishes. This means
that the callback function may still be running after the driver's
remove function has finished, which would result in a use-after-free.

Fix by calling cancel_delayed_work_sync(), which ensures that
the work is properly cancelled, no longer running, and unable
to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7842.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index dcce8d030e5d..c28bf94a7409 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3599,7 +3599,7 @@ static int adv7842_remove(struct i2c_client *client)
 	struct adv7842_state *state = to_state(sd);
 
 	adv7842_irq_enable(sd, false);
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv7842_unregister_clients(sd);
-- 
2.30.2

