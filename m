Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFA938A279
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhETJmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232919AbhETJkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:40:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFDA360FDB;
        Thu, 20 May 2021 09:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503093;
        bh=evni02BbwAdeZIzay0TcfA75MDlrzK9isldoS+5pYSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fl8+RJfIE8JpNfoaGQ/X893X8dZ7gCF+ZUjk1CJiAdPohcMLOU5rocdqTu5/PWLRO
         s0o1PIvyYY4NmI5QYZgJIihKRakCETSNFcliseB5kUUTvTuXnoG8GF6TsAbcKZecVP
         w2yfTRkF2xaw5tAqOUaUqhHrhz/fIpeOAUfC5G68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/425] media: i2c: adv7842: fix possible use-after-free in adv7842_remove()
Date:   Thu, 20 May 2021 11:17:13 +0200
Message-Id: <20210520092133.551140389@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 58662ba92d4f..d0ed20652ddb 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -3585,7 +3585,7 @@ static int adv7842_remove(struct i2c_client *client)
 	struct adv7842_state *state = to_state(sd);
 
 	adv7842_irq_enable(sd, false);
-	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
 	v4l2_device_unregister_subdev(sd);
 	media_entity_cleanup(&sd->entity);
 	adv7842_unregister_clients(sd);
-- 
2.30.2



