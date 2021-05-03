Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35915371B1B
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232362AbhECQnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:43:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232403AbhECQko (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:40:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9176F61413;
        Mon,  3 May 2021 16:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059873;
        bh=qcarRuFNmv3/mRHWtu6Dq8OHL5WzVoDuAExRRu4EuXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDRK0wETn9kjenDc3GFzqOH5nMatYcrG7/Kf0MqdYsHK7pIl3Bdh6klRckNVHmWzV
         3EbXDAFAaOpnFYwozrRtfkn7G6TDQWVuoCkDk7ZPdCaEhXn93C2hvVOi9eTmRmphwO
         ChzsUK84bDdihZzImkGefTv6TG7V58zTfnohmGBDFZ8wik7NswSECVz/EkbS9SpcLT
         otgIu8Qf3PTFATYTB71I57fcJkWiFYHxKOBL4EcDjhdL9Y124w/XShAuadsFUxzHQT
         0HdINQ2Q/kdG4B1ko61hd/osb/+8pX0ohjjs7R9o255zLxLU6dJDkDehNapQgrR+tE
         BsxPnvCthAlbQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 035/115] media: v4l2-ctrls.c: initialize flags field of p_fwht_params
Date:   Mon,  3 May 2021 12:35:39 -0400
Message-Id: <20210503163700.2852194-35-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

