Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B54E2E1574
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbgLWCVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:21:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbgLWCVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8128C2332A;
        Wed, 23 Dec 2020 02:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690097;
        bh=G2eiU8KbGiKzLpzj/6o0rq92g4n5T42u8zY5E4Ykp58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0tCNt79fxiLYONY62R4ypdPIHupXG8P8JnQYpOLPjoASd9TQvHBJd+kXNFiCz3Jv
         WhsZW+ilHUKjvS9/rTtKw3lqQWkMhqN+Z4+bEEW02/rEbGZBvb1RhDOX4AbO30hgU9
         pwFqo8ZERYuFpnlyfCexzZJIeqHcOy8gXUfIeOsndKc1OO7cHP3G7yyhqRgXEnEdld
         MfZe28JjnJv552XX0YIeo/E67YvXUxFVWlog++N1k8vbxMv4vlwxT3Uab9rsCchVlT
         ph9RKdadoElA36s9BrsnnLBZVc2HZEL6Fw8iuGgqsj8q99w9axo+Y0rY1AE+6gNJQe
         sacev+WpGrcLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 27/87] media: cec-core: first mark device unregistered, then wake up fhs
Date:   Tue, 22 Dec 2020 21:20:03 -0500
Message-Id: <20201223022103.2792705-27-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index b278ab90b3871..1cd2f9d4a6045 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -160,12 +160,12 @@ static void cec_devnode_unregister(struct cec_adapter *adap)
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

