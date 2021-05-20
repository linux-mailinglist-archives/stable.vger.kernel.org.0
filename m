Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978D038A918
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238356AbhETK5b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:57:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239347AbhETKyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:54:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BA2F61CDF;
        Thu, 20 May 2021 10:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504879;
        bh=nLaZ4mPuYunB74JpKyPuKjcu8B0IQppJM1qCRYgeFOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJhBk24FT6rbSEHz3co3Apc5HY8Q8DtJEbxqYquppFpYO/GHwLTfZOHDuKbVU5Erv
         J19vTJLj+uOsVXV88tpOAHyzVBZ1jYyFkCPfv/86Pi5cZIsogQyQXN9pgD3ciG90xF
         08b4onofejPi6AbKtkNFeYshiOGYyQ2tpQu9zCV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 123/240] media: omap4iss: return error code when omap4iss_get() failed
Date:   Thu, 20 May 2021 11:21:55 +0200
Message-Id: <20210520092112.798567270@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 8938c48fa25b491842ece9eb38f0bea0fcbaca44 ]

If omap4iss_get() failed, it need return error code in iss_probe().

Fixes: 59f0ad807681 ("[media] v4l: omap4iss: Add support for OMAP4...")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/omap4iss/iss.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index c26c99fd4a24..1e10fe204d3b 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1244,8 +1244,10 @@ static int iss_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto error;
 
-	if (!omap4iss_get(iss))
+	if (!omap4iss_get(iss)) {
+		ret = -EINVAL;
 		goto error;
+	}
 
 	ret = iss_reset(iss);
 	if (ret < 0)
-- 
2.30.2



