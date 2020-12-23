Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 371712E167B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgLWCTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728684AbgLWCTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E331225AA;
        Wed, 23 Dec 2020 02:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689943;
        bh=y4SClHplxMoNfmDVqbnedSr667czje45z1pHwNh970w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFBDN77Vv6pH65Q0gniOU/IoqnbzhROgkXq/P+4RlAjwocxq1SmStfvRd0bKKniRm
         QbS9VbvGaJ+aeBh5KHxNNn98q+ogz56ZxIncDJ7L+maRYVytYVIa99aqRwiGelPlGa
         Rx9S7e4hbt93+7SA3crA0yhfB2DwS+mg7hZDp/Ugo0TYnu4dYnRW54aGr+sf11QMvc
         hgSoa/1Ezb/ckiAfDkoa8hD+7cNy2ogMj4vLLXcQJO1tcRVup76vkHy7GP9Mec17LY
         KvosdLHxXq9qLBi6Tp4xH5tJk/gdpMKEz042SeSeyFyPFUCPx4HWiV5kCVLjFTJOjl
         O+WcVSF43qFyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 038/130] media: cec-core: first mark device unregistered, then wake up fhs
Date:   Tue, 22 Dec 2020 21:16:41 -0500
Message-Id: <20201223021813.2791612-38-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit e91c255733d9bbb4978a372f44fb5ed689ccdbd1 ]

If a CEC device node is unregistered, then it should be marked as
unregistered before waking up any filehandles that are waiting for
an event.

This ensures that there is no race condition where an application can
call CEC_DQEVENT and have the ioctl return 0 instead of ENODEV.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/cec/cec-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 9c610e1e99b84..76b78fb627e83 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -166,12 +166,12 @@ static void cec_devnode_unregister(struct cec_adapter *adap)
 		mutex_unlock(&devnode->lock);
 		return;
 	}
+	devnode->registered = false;
+	devnode->unregistered = true;
 
 	list_for_each_entry(fh, &devnode->fhs, list)
 		wake_up_interruptible(&fh->wait);
 
-	devnode->registered = false;
-	devnode->unregistered = true;
 	mutex_unlock(&devnode->lock);
 
 	mutex_lock(&adap->lock);
-- 
2.27.0

