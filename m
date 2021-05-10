Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1125378197
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbhEJK1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:27:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231555AbhEJK1B (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:27:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B1A6144E;
        Mon, 10 May 2021 10:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642356;
        bh=Rxx7QQiEMwx5ectBXmoX2TNIsjxxoayW2YdY6kOtLZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/+65C5tr4rPQADnSCwM+JeFIQSshcOMWi97wQtmmT2TgCKn92DpR//ChSxKkbR/+
         9MI/rCNip0d7TM07xaI8ZNRMXwbjyH3FHi1RrlOvVkQDsi7SuPYf7QnFuMRTdLQyTh
         obybHuK5xaYsC/ls2kfmTKzXoSxLU6r1DE1jsSHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Bixuan Cui <cuibixuan@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/184] usb: core: hub: Fix PM reference leak in usb_port_resume()
Date:   Mon, 10 May 2021 12:19:16 +0200
Message-Id: <20210510101952.237780680@linuxfoundation.org>
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
index 4d3de33885ff..cd61860cada5 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3537,7 +3537,7 @@ int usb_port_resume(struct usb_device *udev, pm_message_t msg)
 	u16		portchange, portstatus;
 
 	if (!test_and_set_bit(port1, hub->child_usage_bits)) {
-		status = pm_runtime_get_sync(&port_dev->dev);
+		status = pm_runtime_resume_and_get(&port_dev->dev);
 		if (status < 0) {
 			dev_dbg(&udev->dev, "can't resume usb port, status %d\n",
 					status);
-- 
2.30.2



