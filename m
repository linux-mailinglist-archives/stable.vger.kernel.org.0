Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BABD3785CF
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbhEJLB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:01:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234652AbhEJK4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79780619A8;
        Mon, 10 May 2021 10:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643674;
        bh=OP3TQ4aYMT9fRgui+1WxHCcqKPcWP+XaNxdu/Z/OwWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dVJwQDopJBgdmVtwBdkU1WRNk1KngO9iQ0cM/6hAwRE0yBB9y6RYu1VyyqAyZmQ6
         aJ2DVJgqjmoqVPLvhTQKeL9IgTVJkBFhe8efiim+Xhm5NHkGjUM0dnV127B9TD5YqT
         kmoK2AUh7+EVYs1ZOc+Bvv7/yWx4aoLdqvaOi8YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Bixuan Cui <cuibixuan@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 112/342] usb: core: hub: Fix PM reference leak in usb_port_resume()
Date:   Mon, 10 May 2021 12:18:22 +0200
Message-Id: <20210510102013.787557863@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 025f97d188006eeee4417bb475a6878d1e0eed3f ]

pm_runtime_get_sync will increment pm usage counter even it failed.
thus a pairing decrement is needed.
Fix it by replacing it with pm_runtime_resume_and_get to keep usage
counter balanced.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Link: https://lore.kernel.org/r/20210408130831.56239-1-cuibixuan@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 7f71218cc1e5..404507d1b76f 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3556,7 +3556,7 @@ int usb_port_resume(struct usb_device *udev, pm_message_t msg)
 	u16		portchange, portstatus;
 
 	if (!test_and_set_bit(port1, hub->child_usage_bits)) {
-		status = pm_runtime_get_sync(&port_dev->dev);
+		status = pm_runtime_resume_and_get(&port_dev->dev);
 		if (status < 0) {
 			dev_dbg(&udev->dev, "can't resume usb port, status %d\n",
 					status);
-- 
2.30.2



