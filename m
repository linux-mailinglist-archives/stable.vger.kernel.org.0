Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9515E999FA
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfHVRJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:09:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390697AbfHVRJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:09:12 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8362E2342F;
        Thu, 22 Aug 2019 17:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493751;
        bh=pEYPkZqlavPya5XXQTmozjCedN/vAJk5AiBNMwSLs/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8FKBQrAAJSGYpuOeOm58xjWjHekDZVTLrO8CnuYgBtbUo5fvGpgmoPqA7k8WuMUl
         cOJRefd4TncSj5Q3E7Vaj81/Kn/rZDjG2DwLZB7SiO/P/9pqfboiLSMWr9LISiXndn
         HuZZiX5B6WuHqgHRzrRb58/srR4TKQzPwCnvOmrY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hui Wang <hui.wang@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.2 106/135] Input: psmouse - fix build error of multiple definition
Date:   Thu, 22 Aug 2019 13:07:42 -0400
Message-Id: <20190822170811.13303-107-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit 49e6979e7e92cf496105b5636f1df0ac17c159c0 upstream.

trackpoint_detect() should be static inline while
CONFIG_MOUSE_PS2_TRACKPOINT is not set, otherwise, we build fails:

drivers/input/mouse/alps.o: In function `trackpoint_detect':
alps.c:(.text+0x8e00): multiple definition of `trackpoint_detect'
drivers/input/mouse/psmouse-base.o:psmouse-base.c:(.text+0x1b50): first defined here

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 55e3d9224b60 ("Input: psmouse - allow disabing certain protocol extensions")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/trackpoint.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/trackpoint.h b/drivers/input/mouse/trackpoint.h
index 0afffe8d824fa..77110f3ec21da 100644
--- a/drivers/input/mouse/trackpoint.h
+++ b/drivers/input/mouse/trackpoint.h
@@ -158,7 +158,8 @@ struct trackpoint_data {
 #ifdef CONFIG_MOUSE_PS2_TRACKPOINT
 int trackpoint_detect(struct psmouse *psmouse, bool set_properties);
 #else
-inline int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
+static inline int trackpoint_detect(struct psmouse *psmouse,
+				    bool set_properties)
 {
 	return -ENOSYS;
 }
-- 
2.20.1

