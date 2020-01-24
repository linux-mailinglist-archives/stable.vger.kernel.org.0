Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE1E147BAD
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732903AbgAXJnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732925AbgAXJnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:43:02 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7598E21556;
        Fri, 24 Jan 2020 09:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858981;
        bh=KKVXNwJxYTMrw4ygB8YQ5kz2ss37UiXdh/U4xXEiEpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRS7KVaJWYl+e2e3m2tvVYufVVvkT0CRlyStubUbfaVF5DKdOe8xvm+zamNijZ/4H
         aISuY8TWfvBpLPN3Z8ASS1C4Zs17PzdwBkK9zHUBs6ZARIF+Ig1sEzcE8HraDJ8e3S
         qyvEkwD3EZ78rTV9BQ1HGIu6UstvkbI7ulxRcZtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Nick Crews <ncrews@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/102] platform/chrome: wilco_ec: fix use after free issue
Date:   Fri, 24 Jan 2020 10:31:37 +0100
Message-Id: <20200124092821.193405865@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

[ Upstream commit 856a0a6e2d09d31fd8f00cc1fc6645196a509d56 ]

This is caused by dereferencing 'dev_data' after put_device() in
the telem_device_remove() function.
This patch just moves the put_device() down a bit to avoid this
issue.

Fixes: 1210d1e6bad1 ("platform/chrome: wilco_ec: Add telemetry char device interface")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Benson Leung <bleung@chromium.org>
Cc: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Cc: Nick Crews <ncrews@chromium.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/wilco_ec/telemetry.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/wilco_ec/telemetry.c b/drivers/platform/chrome/wilco_ec/telemetry.c
index b9d03c33d8dc1..1176d543191af 100644
--- a/drivers/platform/chrome/wilco_ec/telemetry.c
+++ b/drivers/platform/chrome/wilco_ec/telemetry.c
@@ -406,8 +406,8 @@ static int telem_device_remove(struct platform_device *pdev)
 	struct telem_device_data *dev_data = platform_get_drvdata(pdev);
 
 	cdev_device_del(&dev_data->cdev, &dev_data->dev);
-	put_device(&dev_data->dev);
 	ida_simple_remove(&telem_ida, MINOR(dev_data->dev.devt));
+	put_device(&dev_data->dev);
 
 	return 0;
 }
-- 
2.20.1



