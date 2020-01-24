Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7F571483F2
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389069AbgAXLis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391987AbgAXLip (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:38:45 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8763920708;
        Fri, 24 Jan 2020 11:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865925;
        bh=oi+MjKGkj+3amReMtz4+25L60nkOW7AVttiic5YxrXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IB11vlMxIZIToYeudOngQ7CIbk+pDWr+vleRl4YbBbjv3PoLMzclRDAPF5kDFnsTx
         MzQQr3JDz+h2k5O6+vS8alfazY2en1ryTlXXWFtF5bXWB51vZ4xldNdmJuMVv0l3fD
         tEG1AuqbA4jZv1HJHmOUCzdPK7X8osnFpoVtI6oI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 321/639] media: ov2659: fix unbalanced mutex_lock/unlock
Date:   Fri, 24 Jan 2020 10:28:11 +0100
Message-Id: <20200124093127.242991179@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

[ Upstream commit 384538bda10913e5c94ec5b5d34bd3075931bcf4 ]

Avoid returning with mutex locked.

Fixes: fa8cb6444c32 ("[media] ov2659: Don't depend on subdev API")

Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2659.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
index 4b6be3b0fd528..5cdda9d6ca31e 100644
--- a/drivers/media/i2c/ov2659.c
+++ b/drivers/media/i2c/ov2659.c
@@ -1136,7 +1136,7 @@ static int ov2659_set_fmt(struct v4l2_subdev *sd,
 		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		*mf = fmt->format;
 #else
-		return -ENOTTY;
+		ret = -ENOTTY;
 #endif
 	} else {
 		s64 val;
-- 
2.20.1



