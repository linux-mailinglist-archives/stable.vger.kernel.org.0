Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F9E38A6E9
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237101AbhETKbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237116AbhETK3i (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:29:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFC5E61412;
        Thu, 20 May 2021 09:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504290;
        bh=e/saoSKQSXc1xLAhPuyeu7mnQsRJFJA40wQLwfH72D4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COrxkK/XvrPVCIh09MaD13f0CFoZHf8upqxrARrJCnjVtvLiWOjICzI4agw71X+t0
         WOcG4hBSV9zuwiylAaM6opvzoMvWyi1ToXVtDJbqjjvpPB65d17gZ9snMnLhmAhivX
         sf9ysCovFpf2Kl8HzjaswfpJWKjicpuHWl8L70Hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 179/323] media: vivid: fix assignment of dev->fbuf_out_flags
Date:   Thu, 20 May 2021 11:21:11 +0200
Message-Id: <20210520092126.257455356@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index 3e7a26d15074..4629679a0f3c 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -1010,7 +1010,7 @@ int vivid_vid_out_s_fbuf(struct file *file, void *fh,
 		return -EINVAL;
 	}
 	dev->fbuf_out_flags &= ~(chroma_flags | alpha_flags);
-	dev->fbuf_out_flags = a->flags & (chroma_flags | alpha_flags);
+	dev->fbuf_out_flags |= a->flags & (chroma_flags | alpha_flags);
 	return 0;
 }
 
-- 
2.30.2



