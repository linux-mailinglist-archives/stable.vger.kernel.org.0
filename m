Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C6F378611
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbhEJLDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:03:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234857AbhEJK5L (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 223F3619C0;
        Mon, 10 May 2021 10:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643801;
        bh=qcarRuFNmv3/mRHWtu6Dq8OHL5WzVoDuAExRRu4EuXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExJ9fZXecpaYEJ1JZwGADLIxgO8yy2xWoAWwCqKREOJ3azPMFdyrcTr5gcnTQn28l
         vBVokLs2ChlFpIumFRGVgImlNjNrVY3Bmp5pQYIFtRseJyTNziuNXtFe9Mtcj5iN4W
         61QDjow3a4iXeEfPuBdFHclk62b16SiHPbFbnlTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 163/342] media: v4l2-ctrls.c: initialize flags field of p_fwht_params
Date:   Mon, 10 May 2021 12:19:13 +0200
Message-Id: <20210510102015.478646916@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit ea1611ba3a544b34f89ffa3d1e833caab30a3f09 ]

The V4L2_CID_STATELESS_FWHT_PARAMS compound control was missing a
proper initialization of the flags field, so after loading the vicodec
module for the first time, running v4l2-compliance for the stateless
decoder would fail on this control because the initial control value
was considered invalid by the vicodec driver.

Initializing the flags field to sane values fixes this.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 9dc151431a5c..584c5b33690e 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1659,6 +1659,8 @@ static void std_init_compound(const struct v4l2_ctrl *ctrl, u32 idx,
 		p_fwht_params->version = V4L2_FWHT_VERSION;
 		p_fwht_params->width = 1280;
 		p_fwht_params->height = 720;
+		p_fwht_params->flags = V4L2_FWHT_FL_PIXENC_YUV |
+			(2 << V4L2_FWHT_FL_COMPONENTS_NUM_OFFSET);
 		break;
 	}
 }
-- 
2.30.2



