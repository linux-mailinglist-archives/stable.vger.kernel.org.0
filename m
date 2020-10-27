Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0F929BC73
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802505AbgJ0Qcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802495AbgJ0Ptm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:49:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1E4D2065C;
        Tue, 27 Oct 2020 15:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813781;
        bh=+m6xu3aGhCkPp0WNGUiov9exqKq/HXvY0saNarZFAsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5klYYxbznFLEn/3S4xNL0xELm/2Lh3z9sZOE0g0GCbEwiPcVfkRul0XiXHN/S17G
         kB6ajr9hHnpRjCrecApYeVdknA9q5x3fJiVIZnjpfhjL79FaHGVgB/S1RmOZWRBiMy
         H0fsrI+K2F4P/1EBjm06w6FZRna0na5COv7ejVd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vikash Garodia <vgarodia@codeaurora.org>,
        Fritz Koenig <frkoenig@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 668/757] media: venus: fixes for list corruption
Date:   Tue, 27 Oct 2020 14:55:18 +0100
Message-Id: <20201027135521.881108348@linuxfoundation.org>
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

From: Vikash Garodia <vgarodia@codeaurora.org>

[ Upstream commit e1c69c4eef61ffe295b747992c6fd849e6cd747d ]

There are few list handling issues while adding and deleting
node in the registered buf list in the driver.
1. list addition - buffer added into the list during buf_init
while not deleted during cleanup.
2. list deletion - In capture streamoff, the list was reinitialized.
As a result, if any node was present in the list, it would
lead to issue while cleaning up that node during buf_cleanup.

Corresponding call traces below:
[  165.751014] Call trace:
[  165.753541]  __list_add_valid+0x58/0x88
[  165.757532]  venus_helper_vb2_buf_init+0x74/0xa8 [venus_core]
[  165.763450]  vdec_buf_init+0x34/0xb4 [venus_dec]
[  165.768271]  __buf_prepare+0x598/0x8a0 [videobuf2_common]
[  165.773820]  vb2_core_qbuf+0xb4/0x334 [videobuf2_common]
[  165.779298]  vb2_qbuf+0x78/0xb8 [videobuf2_v4l2]
[  165.784053]  v4l2_m2m_qbuf+0x80/0xf8 [v4l2_mem2mem]
[  165.789067]  v4l2_m2m_ioctl_qbuf+0x2c/0x38 [v4l2_mem2mem]
[  165.794624]  v4l_qbuf+0x48/0x58

[ 1797.556001] Call trace:
[ 1797.558516]  __list_del_entry_valid+0x88/0x9c
[ 1797.562989]  vdec_buf_cleanup+0x54/0x228 [venus_dec]
[ 1797.568088]  __buf_prepare+0x270/0x8a0 [videobuf2_common]
[ 1797.573625]  vb2_core_qbuf+0xb4/0x338 [videobuf2_common]
[ 1797.579082]  vb2_qbuf+0x78/0xb8 [videobuf2_v4l2]
[ 1797.583830]  v4l2_m2m_qbuf+0x80/0xf8 [v4l2_mem2mem]
[ 1797.588843]  v4l2_m2m_ioctl_qbuf+0x2c/0x38 [v4l2_mem2mem]
[ 1797.594389]  v4l_qbuf+0x48/0x58

Signed-off-by: Vikash Garodia <vgarodia@codeaurora.org>
Reviewed-by: Fritz Koenig <frkoenig@chromium.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 7c4c483d54389..76be14efbfb09 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -1088,8 +1088,6 @@ static int vdec_stop_capture(struct venus_inst *inst)
 		break;
 	}
 
-	INIT_LIST_HEAD(&inst->registeredbufs);
-
 	return ret;
 }
 
@@ -1189,6 +1187,14 @@ static int vdec_buf_init(struct vb2_buffer *vb)
 static void vdec_buf_cleanup(struct vb2_buffer *vb)
 {
 	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct venus_buffer *buf = to_venus_buffer(vbuf);
+
+	mutex_lock(&inst->lock);
+	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		if (!list_empty(&inst->registeredbufs))
+			list_del_init(&buf->reg_list);
+	mutex_unlock(&inst->lock);
 
 	inst->buf_count--;
 	if (!inst->buf_count)
-- 
2.25.1



