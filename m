Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED903C523D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349982AbhGLHpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244209AbhGLHmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C03A61108;
        Mon, 12 Jul 2021 07:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075571;
        bh=sOkcMFvyP8ddjj0l3jVJa2A1Ubwg3F1LfGq2uOXUpSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQNPY1BMHg4I0V6/fNESzD8e9P0tib8SsIAb02o8Zd3vYdmlF0ghg6505HulgJy14
         dmGJROZBmUQP3efPNIeWW2haQNLALYLrU9mapi0IhOAIXjRpc4f7/WwfU/IZqwnJJK
         B0LyuNeDDlEFoXB0ntx6oU/QYbCb2EhFgbdAnDf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 271/800] media: i2c: ccs-core: return the right error code at suspend
Date:   Mon, 12 Jul 2021 08:04:54 +0200
Message-Id: <20210712060952.999963170@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 6005a8e955e4e451e4bf6000affaab566d4cab5e ]

If pm_runtime resume logic fails, return the error code
provided by it, instead of -EAGAIN, as, depending on what
caused it to fail, it may not be something that would be
recovered.

Fixes: cbba45d43631 ("[media] smiapp: Use runtime PM")
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ccs/ccs-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ccs/ccs-core.c b/drivers/media/i2c/ccs/ccs-core.c
index 9dc3f45da3dc..b05f409014b2 100644
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3093,7 +3093,7 @@ static int __maybe_unused ccs_suspend(struct device *dev)
 	if (rval < 0) {
 		pm_runtime_put_noidle(dev);
 
-		return -EAGAIN;
+		return rval;
 	}
 
 	if (sensor->streaming)
-- 
2.30.2



