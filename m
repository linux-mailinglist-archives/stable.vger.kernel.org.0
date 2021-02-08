Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6B13137AA
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhBHP2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233492AbhBHPYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:24:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08A5664EB6;
        Mon,  8 Feb 2021 15:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797286;
        bh=9K13U7yAYhW9NBWzjCT4t+OMve9AhGLmAwwo9Pwuxvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAtU9yQOGQE69D+6YVIewUHxqWVOpTK3ZHNLMb6SNi2mM/37XV0cA29bZkkWD0awb
         PNnZxk57q1U2j8xSV689W7nWf//29r9XIglWlmxdUIkP0IZBJ7YnXyXt0FtdKXQSxM
         kcvgJZQpz0NROlRvHT7IuGhJrIQr6GN6XeItRdxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/120] um: virtio: free vu_dev only with the contained struct device
Date:   Mon,  8 Feb 2021 16:00:16 +0100
Message-Id: <20210208145819.551107451@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit f4172b084342fd3f9e38c10650ffe19eac30d8ce ]

Since struct device is refcounted, we shouldn't free the vu_dev
immediately when it's removed from the platform device, but only
when the references actually all go away. Move the freeing to
the release to accomplish that.

Fixes: 5d38f324993f ("um: drivers: Add virtio vhost-user driver")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virtio_uml.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index a6c4bb6c2c012..c17b8e5ec1869 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -1083,6 +1083,7 @@ static void virtio_uml_release_dev(struct device *d)
 	}
 
 	os_close_file(vu_dev->sock);
+	kfree(vu_dev);
 }
 
 /* Platform device */
@@ -1096,7 +1097,7 @@ static int virtio_uml_probe(struct platform_device *pdev)
 	if (!pdata)
 		return -EINVAL;
 
-	vu_dev = devm_kzalloc(&pdev->dev, sizeof(*vu_dev), GFP_KERNEL);
+	vu_dev = kzalloc(sizeof(*vu_dev), GFP_KERNEL);
 	if (!vu_dev)
 		return -ENOMEM;
 
-- 
2.27.0



