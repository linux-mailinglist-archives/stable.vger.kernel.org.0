Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3753337C8EF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbhELQN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:13:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239377AbhELQH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F0F161D36;
        Wed, 12 May 2021 15:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833865;
        bh=049XFbixev2xees/4/h5OSTGiPM97cIyJcKr7n0TfGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhSXIVdLmoLIcW+SXuD5XtC15DOIg1bs2iwmhrbHTq4Ooy9YQbabP78aVXgmERRm+
         ywPlhU5tJLlevBYZ28rlK5BNFaYcEEdGE0hpre9anAWBeG5H53kNq4fbJZaCIwjcq4
         LPenFxPKc72+HQx77hhVBlzd84e/Vjn/zomD1XwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 319/601] media: omap4iss: return error code when omap4iss_get() failed
Date:   Wed, 12 May 2021 16:46:36 +0200
Message-Id: <20210512144838.320094868@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index e06ea7ea1e50..3dac35f68238 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1236,8 +1236,10 @@ static int iss_probe(struct platform_device *pdev)
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



