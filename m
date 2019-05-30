Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5EB2F474
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbfE3DMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729173AbfE3DMm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:42 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D146E23DE3;
        Thu, 30 May 2019 03:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185961;
        bh=XcJ67KVlbfws4QxK94sQYcVSTdHXWYoiAMcJLHgKWQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXdYmy86gvrKCrmXDH4r2+x94xYrYvZ6Uo65qx3Os5vUGaZtefW2+E0YlQN8LaZGK
         tqqqM9QN2B9zCgAz8IayPCAkD9y5atuWIx+u5CThKCwX9DDooYq7C0ledGZOBDqwzs
         ls9U4U79f/nMbdwDUIydQyj4u2Sq7A7cb+FElVOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 338/405] media: vicodec: reset last_src/dst_buf based on the IS_OUTPUT
Date:   Wed, 29 May 2019 20:05:36 -0700
Message-Id: <20190530030557.798675147@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 76eb24fc233b8c94b2156ead5811e08d2046ad58 ]

When start_streaming was called both last_src_buf and last_dst_buf
pointers were set to NULL, but this depends on whether the capture
or output queue starts streaming.

When decoding with resolution changes in between the capture queue
has to restart streaming whenever a resolution change occurs. And
that would reset last_src_buf as well, which causes a problem if
the decoder was stopped by the application. Since last_src_buf
is now NULL, the LAST flag is never set for the last capture
buffer.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vicodec/vicodec-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 6b618452700c4..8788369e59a0a 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1339,8 +1339,11 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	chroma_div = info->width_div * info->height_div;
 	q_data->sequence = 0;
 
-	ctx->last_src_buf = NULL;
-	ctx->last_dst_buf = NULL;
+	if (V4L2_TYPE_IS_OUTPUT(q->type))
+		ctx->last_src_buf = NULL;
+	else
+		ctx->last_dst_buf = NULL;
+
 	state->gop_cnt = 0;
 
 	if ((V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) ||
-- 
2.20.1



