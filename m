Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7157A4523FE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352476AbhKPBfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:35:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241781AbhKOSgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:36:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38A6061A6C;
        Mon, 15 Nov 2021 18:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999340;
        bh=rHUsHtngfJ01PWkzk+xW18SXgQk96K+dt0s8V893RUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VL57jwGT2VJtMgonHem6H2uw9LTwcR42EwRg5fX7ldyKz+917y4aqJS9BVEIWOzi5
         lbgSIQeAt/vlXSNvwmmZNLFJlm+OBB1zASRvfxnzuN0MVrWR2U9TfCM0/j/l95UWY6
         gtT8u7J+D2T524E3+cv8BIJ95ytUiKQitHf+NWuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ricardo Ribalda <ribalda@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 263/849] media: ipu3-imgu: imgu_fmt: Handle properly try
Date:   Mon, 15 Nov 2021 17:55:46 +0100
Message-Id: <20211115165429.141003104@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 553481e38045f349bb9aa596d03bebd020020c9c ]

For a try_fmt call, the node noes not need to be enabled.

Fixes v4l2-compliance

fail: v4l2-test-formats.cpp(717): Video Output Multiplanar is valid, but
				  no TRY_FMT was implemented
test VIDIOC_TRY_FMT: FAIL

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu3/ipu3-v4l2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index 38a2407645096..ea746e8054eb7 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -696,7 +696,7 @@ static int imgu_fmt(struct imgu_device *imgu, unsigned int pipe, int node,
 
 		/* CSS expects some format on OUT queue */
 		if (i != IPU3_CSS_QUEUE_OUT &&
-		    !imgu_pipe->nodes[inode].enabled) {
+		    !imgu_pipe->nodes[inode].enabled && !try) {
 			fmts[i] = NULL;
 			continue;
 		}
-- 
2.33.0



