Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3211329B007
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756992AbgJ0OPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756989AbgJ0OPg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:15:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DFB4206F7;
        Tue, 27 Oct 2020 14:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808135;
        bh=VPcK4QekstiDnUmXbtzac80C6mHVC6oL3H4FbCSlz5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBoauFFF+7UrcM7Ubm09tp5LTCdOaRN+giAaK/zl+bHb5IxptbVsiEFs1doVJpcvP
         AevCOf4XbyJ797fxQHSoiO9f9V0EdDmb1AE9EK8ULY8seBSgFuDPun3ODcWEC1zNJv
         R8mgvu6EZv7bBGrvmpFzbUKSvYmsyndx5XZ/VvLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 139/191] media: st-delta: Fix reference count leak in delta_run_work
Date:   Tue, 27 Oct 2020 14:49:54 +0100
Message-Id: <20201027134916.395524241@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 57cc666d36adc7b45e37ba4cd7bc4e44ec4c43d7 ]

delta_run_work() calls delta_get_sync() that increments
the reference counter. In case of failure, decrement the reference
count by calling delta_put_autosuspend().

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sti/delta/delta-v4l2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index b2dc3d223a9c9..7c925f309158d 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -970,8 +970,10 @@ static void delta_run_work(struct work_struct *work)
 	/* enable the hardware */
 	if (!dec->pm) {
 		ret = delta_get_sync(ctx);
-		if (ret)
+		if (ret) {
+			delta_put_autosuspend(ctx);
 			goto err;
+		}
 	}
 
 	/* decode this access unit */
-- 
2.25.1



