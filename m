Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B92737C92D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238745AbhELQPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:15:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231558AbhELQIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:08:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE73761D29;
        Wed, 12 May 2021 15:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833940;
        bh=xz92FOpheA9ZOF9VnEJ0f1K84zDSsAqk20jhK4woGiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hWAIvwQRIiGB3GJTyj3d8ukrttcZAKgJiDBR1Pjchdz4z9Uq4BVGXj3g7eP+nW2Yt
         X82Rsr0GuFfK8S02Er4pEhJ1uA+i9UMu6QOeLcq7KxkJRKg+uuLn7LhKQAkvxM0RUH
         zkIRUVH6skLIzPlBcd8c7k2Z9LTw9H0EURvC5s98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 330/601] media: atomisp: Fix use after free in atomisp_alloc_css_stat_bufs()
Date:   Wed, 12 May 2021 16:46:47 +0200
Message-Id: <20210512144838.668259434@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ba11bbf303fafb33989e95473e409f6ab412b18d ]

The "s3a_buf" is freed along with all the other items on the
"asd->s3a_stats" list.  It leads to a double free and a use after free.

Link: https://lore.kernel.org/linux-media/X9dSO3RGf7r0pq2k@mwanda
Fixes: ad85094b293e ("Revert "media: staging: atomisp: Remove driver"")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
index 2ae50decfc8b..9da82855552d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_ioctl.c
@@ -948,10 +948,8 @@ int atomisp_alloc_css_stat_bufs(struct atomisp_sub_device *asd,
 		dev_dbg(isp->dev, "allocating %d dis buffers\n", count);
 		while (count--) {
 			dis_buf = kzalloc(sizeof(struct atomisp_dis_buf), GFP_KERNEL);
-			if (!dis_buf) {
-				kfree(s3a_buf);
+			if (!dis_buf)
 				goto error;
-			}
 			if (atomisp_css_allocate_stat_buffers(
 				asd, stream_id, NULL, dis_buf, NULL)) {
 				kfree(dis_buf);
-- 
2.30.2



