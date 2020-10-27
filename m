Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 616A729B657
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1797381AbgJ0PXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:38082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797374AbgJ0PXI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:23:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5E7020657;
        Tue, 27 Oct 2020 15:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812187;
        bh=P/bk7xuVHHNBjoKf6h+7mas2/W2ecpQm5r52hVrm8qY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ROKUU+at6uJE+HloL9+FVPrEXSLzhDHT80wxpQqrT0pwur5zDXLGo7v6jCL7oGmN
         71uWF7AIv4/JmmhaISCBPvY/CG/ac3wrpfzNZVmGrxJliIwtCZ1A6zxRBVhSCD070F
         9y80oyIJpqdPctcYxPIiTaXnSU/bznBuz6D97fPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+02d9172bf4c43104cd70@syzkaller.appspotmail.com
Subject: [PATCH 5.9 123/757] media: vivid: Fix global-out-of-bounds read in precalculate_color()
Date:   Tue, 27 Oct 2020 14:46:13 +0100
Message-Id: <20201027135456.347653979@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

[ Upstream commit e3158a5e7e661786b3ab650c7e4d21024e8eff0f ]

vivid_meta_out_process() is setting `brightness`, `contrast`, `saturation`
and `hue` using tpg_s_*(). This is wrong, since tpg_s_*() do not provide
range checks. Using tpg_s_*() here also makes the control framework
out-of-sync with the actual values. Use v4l2_ctrl_s_ctrl() instead.

This issue has been reported by syzbot as an out-of-bounds read bug in
precalculate_color().

Reported-and-tested-by: syzbot+02d9172bf4c43104cd70@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=02d9172bf4c43104cd70

Fixes: 746facd39370 ("media: vivid: Add metadata output support")
Suggested-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vivid/vivid-meta-out.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/test-drivers/vivid/vivid-meta-out.c b/drivers/media/test-drivers/vivid/vivid-meta-out.c
index ff8a039aba72e..95835b52b58fc 100644
--- a/drivers/media/test-drivers/vivid/vivid-meta-out.c
+++ b/drivers/media/test-drivers/vivid/vivid-meta-out.c
@@ -164,10 +164,11 @@ void vivid_meta_out_process(struct vivid_dev *dev,
 {
 	struct vivid_meta_out_buf *meta = vb2_plane_vaddr(&buf->vb.vb2_buf, 0);
 
-	tpg_s_brightness(&dev->tpg, meta->brightness);
-	tpg_s_contrast(&dev->tpg, meta->contrast);
-	tpg_s_saturation(&dev->tpg, meta->saturation);
-	tpg_s_hue(&dev->tpg, meta->hue);
+	v4l2_ctrl_s_ctrl(dev->brightness, meta->brightness);
+	v4l2_ctrl_s_ctrl(dev->contrast, meta->contrast);
+	v4l2_ctrl_s_ctrl(dev->saturation, meta->saturation);
+	v4l2_ctrl_s_ctrl(dev->hue, meta->hue);
+
 	dprintk(dev, 2, " %s brightness %u contrast %u saturation %u hue %d\n",
 		__func__, meta->brightness, meta->contrast,
 		meta->saturation, meta->hue);
-- 
2.25.1



