Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBD438A8A2
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239130AbhETKwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238774AbhETKuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:50:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FEC461C69;
        Thu, 20 May 2021 09:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504769;
        bh=tcIqoDhSdlnMtI/Ic/0nYuj/89dWfHyaRrv7gQ4v1Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5xGqIEAmXw3lkK9wkLQtlq55a0rrZSEUV+u+fkgUxLwSwqeVkpdiRFEN38lrbt6T
         EjsOy+gTLemacw0veL5xBdZLG7418Z0jNygzZ14o4QlxTaCXM5NHyQ2UsNLI0EpVCz
         jlBU2XT0nTOqnRh8hMoqv97J46FEJkdO2vzp27zU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 039/240] media: adv7604: fix possible use-after-free in adv76xx_remove()
Date:   Thu, 20 May 2021 11:20:31 +0200
Message-Id: <20210520092109.966867629@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit fa56f5f1fe31c2050675fa63b84963ebd504a5b3 ]

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
 drivers/media/i2c/adv7604.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index ce6f93074ae0..56b8b7bf759e 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -3541,7 +3541,7 @@ static int adv76xx_remove(struct i2c_client *client)
 	io_write(sd, 0x6e, 0);
 	io_write(sd, 0x73, 0);
 
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	v4l2_async_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv76xx_unregister_clients(to_state(sd));
-- 
2.30.2



