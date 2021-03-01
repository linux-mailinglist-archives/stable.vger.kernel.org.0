Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89B1328F29
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239991AbhCATqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:46:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237492AbhCATgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:36:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B003764FCA;
        Mon,  1 Mar 2021 17:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620652;
        bh=BhJs3vM23hPT4HWIOtKESG+hIvMj9t2GghvX/kZ4ORc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZxJoWie4lBltsi0pv0/bmq7+LUUwj7jgA9aaDvzo1wMRnP5Ube8gU2bLRdwNqdSrm
         KmP8Ptedux+Xlp9ihYYvuEBuA/fWn+6z3eSgZLIbvwEHZ0vTvUow+6r0YgwgF0ahpl
         bth7JrgEttcX+PpAEl/PxNsGahUPoEgv2zixPkRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 229/775] media: mtk-vcodec: fix argument used when DEBUG is defined
Date:   Mon,  1 Mar 2021 17:06:37 +0100
Message-Id: <20210301161212.944148475@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit a04e187d231086a1313fd635ac42bdbc997137ad ]

When DEBUG is defined this error occurs

drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c:306:41:
  error: ‘i’ undeclared (first use in this function)
  mtk_v4l2_debug(2, "reg[%d] base=0x%p", i, dev->reg_base[VENC_SYS]);

Reviewing the old line

	mtk_v4l2_debug(2, "reg[%d] base=0x%p", i, dev->reg_base[i]);

All the i's need to be changed to VENC_SYS.
Fix a similar error for VENC_LT_SYS.

Fixes: 0dc4b3286125 ("media: mtk-vcodec: venc: support SCP firmware")
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
index dfb42e19bf813..be3842e6ca475 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
@@ -303,7 +303,7 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
 		ret = PTR_ERR((__force void *)dev->reg_base[VENC_SYS]);
 		goto err_res;
 	}
-	mtk_v4l2_debug(2, "reg[%d] base=0x%p", i, dev->reg_base[VENC_SYS]);
+	mtk_v4l2_debug(2, "reg[%d] base=0x%p", VENC_SYS, dev->reg_base[VENC_SYS]);
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {
@@ -332,7 +332,7 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
 			ret = PTR_ERR((__force void *)dev->reg_base[VENC_LT_SYS]);
 			goto err_res;
 		}
-		mtk_v4l2_debug(2, "reg[%d] base=0x%p", i, dev->reg_base[VENC_LT_SYS]);
+		mtk_v4l2_debug(2, "reg[%d] base=0x%p", VENC_LT_SYS, dev->reg_base[VENC_LT_SYS]);
 
 		dev->enc_lt_irq = platform_get_irq(pdev, 1);
 		irq_set_status_flags(dev->enc_lt_irq, IRQ_NOAUTOEN);
-- 
2.27.0



