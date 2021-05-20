Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E198C38A919
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239142AbhETK5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:57:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239343AbhETKyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:54:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11308616EB;
        Thu, 20 May 2021 10:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504877;
        bh=p58Su/mXEqlLZWGxN//FzrObBgFLeTTpue4aC2N+oE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b236TGFT3F2NY+TDRYWnK23Ypo9A2k0erJ9OajzkAxZbWGDQEsAAeQgdM/jqdanaF
         6XMgKcOgpFxMzlytUPCGBhl62TkfE2zs5tfB3XcFur8IUevsW8+hJV2PBO6EyCE26Z
         7HGpa3bo7d5rrRnuLalGV4EySosKiN2M1hDdZ888=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 122/240] media: vivid: fix assignment of dev->fbuf_out_flags
Date:   Thu, 20 May 2021 11:21:54 +0200
Message-Id: <20210520092112.767381792@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
 drivers/media/platform/vivid/vivid-vid-out.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 8fed2fbe91a9..f78caf72cb3e 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -1003,7 +1003,7 @@ int vivid_vid_out_s_fbuf(struct file *file, void *fh,
 		return -EINVAL;
 	}
 	dev->fbuf_out_flags &= ~(chroma_flags | alpha_flags);
-	dev->fbuf_out_flags = a->flags & (chroma_flags | alpha_flags);
+	dev->fbuf_out_flags |= a->flags & (chroma_flags | alpha_flags);
 	return 0;
 }
 
-- 
2.30.2



