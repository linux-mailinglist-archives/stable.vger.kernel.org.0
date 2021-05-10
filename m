Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7AC137882C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239031AbhEJLUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233727AbhEJLJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:09:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C3D661933;
        Mon, 10 May 2021 11:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644683;
        bh=Rn0EJ/oyshipWSTP5vZpeIKbNoRmk7qGzBjufqOYjCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAHZU28vMcsrxm6z3ADe3Y1dLtMQXgRHT/gWn2CPzSBIN7dGEY5NxA0Ig5iDuANzo
         ICuExVeNf9u0dAOQ0e0IIkzGAphMZRbqqsAgMIPxU9tj5oYc61AWJBwczJ55ZmXPax
         fKhdegLMTtpSdO6t+tmN8yz6WI0cUXAi8z1MxYcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 180/384] media: v4l2-ctrls.c: initialize flags field of p_fwht_params
Date:   Mon, 10 May 2021 12:19:29 +0200
Message-Id: <20210510102020.824853634@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
index 016cf6204cbb..77f63773096e 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1675,6 +1675,8 @@ static void std_init_compound(const struct v4l2_ctrl *ctrl, u32 idx,
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



