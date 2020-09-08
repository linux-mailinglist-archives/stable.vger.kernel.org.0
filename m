Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B12261D14
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731809AbgIHTbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730203AbgIHP6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:58:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6BFB23D57;
        Tue,  8 Sep 2020 15:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579452;
        bh=mqOp7faWMHjB+BCoPMZBYO0zRn3ohRGM5EpDtKb3YVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AohbE4Mx8u8I4x+faguWnK5GCLBDuy68vqis60O8/2+6H76qhj46dZ+5Fvoy2eG6p
         Ff81p4WiZ+0/TmdribZO7ORq/DFELTcixHKiPwA5kLkQsWSGd43YeG4L9hnIJazhQ2
         wUTHrTP95ITWr8TURF/RnzkeEmT7+2qkSUl+p2T0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 076/186] media: vicodec: add missing v4l2_ctrl_request_hdl_put()
Date:   Tue,  8 Sep 2020 17:23:38 +0200
Message-Id: <20200908152245.333172985@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 2e7c8fb8942773f412fe12f3b63e8bb92c18ab3f ]

The check for a required control in the request was missing a call to
v4l2_ctrl_request_hdl_put(), so the control request object was never
released.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: 997deb811bf5 ("media: vicodec: Add support for stateless decoder.")
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vicodec/vicodec-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/test-drivers/vicodec/vicodec-core.c b/drivers/media/test-drivers/vicodec/vicodec-core.c
index e879290727ef4..25c4ca6884dda 100644
--- a/drivers/media/test-drivers/vicodec/vicodec-core.c
+++ b/drivers/media/test-drivers/vicodec/vicodec-core.c
@@ -1994,6 +1994,7 @@ static int vicodec_request_validate(struct media_request *req)
 	}
 	ctrl = v4l2_ctrl_request_hdl_ctrl_find(hdl,
 					       vicodec_ctrl_stateless_state.id);
+	v4l2_ctrl_request_hdl_put(hdl);
 	if (!ctrl) {
 		v4l2_info(&ctx->dev->v4l2_dev,
 			  "Missing required codec control\n");
-- 
2.25.1



