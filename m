Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A9E37CCBD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbhELQrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:47:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243436AbhELQlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91A6561E44;
        Wed, 12 May 2021 16:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835452;
        bh=fifFGCMZRJllw639RHNSjzTTHTP+E2DNOy1t/8mMLMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L00+pHsfPLB9bUFe7rQQ1d9lbucUb2ZMcy7q0xnM0VYfaLy3Q58/YIlJJPM/shW0u
         GAkZgh37RYMqRZU9rGVkCbFvDaA7sjSwGNmbmwXfEyEedgQK7yjcxYrd+bLfOEj/eK
         oO0IAK+lWfxOC3CxVkyL9uZmtaLBEFcQMqoO66iM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 351/677] media: vivid: fix assignment of dev->fbuf_out_flags
Date:   Wed, 12 May 2021 16:46:37 +0200
Message-Id: <20210512144848.972586040@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 5cde22fcc7271812a7944c47b40100df15908358 ]

Currently the chroma_flags and alpha_flags are being zero'd with a bit-wise
mask and the following statement should be bit-wise or'ing in the new flag
bits but instead is making a direct assignment.  Fix this by using the |=
operator rather than an assignment.

Addresses-Coverity: ("Unused value")

Fixes: ef834f7836ec ("[media] vivid: add the video capture and output parts")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vivid/vivid-vid-out.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vivid/vivid-vid-out.c b/drivers/media/test-drivers/vivid/vivid-vid-out.c
index ac1e981e8342..9f731f085179 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-out.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-out.c
@@ -1021,7 +1021,7 @@ int vivid_vid_out_s_fbuf(struct file *file, void *fh,
 		return -EINVAL;
 	}
 	dev->fbuf_out_flags &= ~(chroma_flags | alpha_flags);
-	dev->fbuf_out_flags = a->flags & (chroma_flags | alpha_flags);
+	dev->fbuf_out_flags |= a->flags & (chroma_flags | alpha_flags);
 	return 0;
 }
 
-- 
2.30.2



