Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF7F261E84
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbgIHTwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:52:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729911AbgIHPtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:49:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA5862483E;
        Tue,  8 Sep 2020 15:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579900;
        bh=fy6yFgsQnKEq5JeOEazG6HyDQXit/TLSbvWOcO0SZDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGvdkBtPLLyRyzMrpTM9MgE2TC2/c3EU2KCC0BcJ3xGw73P4sRviY9mubu/o/+SKL
         jr+BW1ik3Jjr2t/tN+PK7waqVrpvoxutwAF32xPlt8/hOXZVRev0Mf8cOKCHMhoFvm
         WSXvF0h54IGAiBU72MxRkoEzcDup4BxWDAhAoWZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/129] media: vicodec: add missing v4l2_ctrl_request_hdl_put()
Date:   Tue,  8 Sep 2020 17:24:50 +0200
Message-Id: <20200908152232.163255138@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
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
 drivers/media/platform/vicodec/vicodec-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 84ec36156f73f..c77281d43f892 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -2052,6 +2052,7 @@ static int vicodec_request_validate(struct media_request *req)
 	}
 	ctrl = v4l2_ctrl_request_hdl_ctrl_find(hdl,
 					       vicodec_ctrl_stateless_state.id);
+	v4l2_ctrl_request_hdl_put(hdl);
 	if (!ctrl) {
 		v4l2_info(&ctx->dev->v4l2_dev,
 			  "Missing required codec control\n");
-- 
2.25.1



