Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBF222EC1B
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731561AbfE3DS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:18:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731549AbfE3DS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:18:28 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42419247C9;
        Thu, 30 May 2019 03:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186307;
        bh=0Yf7YGQ/sEpb1kMylafb/6YPgn3HoZ7N3cN3eq1HrTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCogC67faGCcET/7J7GXCV7w3Em/aNIANPz9LUCqtK3s1MA6DuSvcQCUri5B7aSW7
         wmubR0gxjag0sdFSRNPQbx3fjX3JEh63SE3CXtCrsjDKn6JY3YtpWI9vE6qjarT+ND
         Zbh7uOwCtzoG7hLg4/iheBFyNG5MBGiYJgCW6lig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 272/276] drm: Wake up next in drm_read() chain if we are forced to putback the event
Date:   Wed, 29 May 2019 20:07:10 -0700
Message-Id: <20190530030542.215922846@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 60b801999c48b6c1dd04e653a38e2e613664264e ]

After an event is sent, we try to copy it into the user buffer of the
first waiter in drm_read() and if the user buffer doesn't have enough
room we put it back onto the list. However, we didn't wake up any
subsequent waiter, so that event may sit on the list until either a new
vblank event is sent or a new waiter appears. Rare, but in the worst
case may lead to a stuck process.

Testcase: igt/drm_read/short-buffer-wakeup
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20170804082328.17173-1-chris@chris-wilson.co.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/drm_file.c b/drivers/gpu/drm/drm_file.c
index e4ccb52c67ea4..334addaca9c54 100644
--- a/drivers/gpu/drm/drm_file.c
+++ b/drivers/gpu/drm/drm_file.c
@@ -567,6 +567,7 @@ ssize_t drm_read(struct file *filp, char __user *buffer,
 				file_priv->event_space -= length;
 				list_add(&e->link, &file_priv->event_list);
 				spin_unlock_irq(&dev->event_lock);
+				wake_up_interruptible(&file_priv->event_wait);
 				break;
 			}
 
-- 
2.20.1



