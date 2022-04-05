Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8ED4F3291
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343605AbiDEJMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244839AbiDEIwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:52:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EED2251F;
        Tue,  5 Apr 2022 01:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA95C609D0;
        Tue,  5 Apr 2022 08:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BBCC385A1;
        Tue,  5 Apr 2022 08:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148274;
        bh=F/KAOxakQmLnxmxXmFlfNx4PoySsMtATiBduHkH+C5g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kSoi1w1mWy0pHLTaX3L8SE6OolbMd+dRIme8SIL9rvPCd7uoJtbOQHVMXxGNa+Ku4
         dypXM5sqWhQDzVQraH77Uu4zD5/bEsRKDuW84IjPDisdFduirVtxY2JKuS29Z5z7rE
         GBKkdaZm7B3CEupTSBXsrWL35yNhC3UoDt+a6o5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0296/1017] media: meson: vdec: potential dereference of null pointer
Date:   Tue,  5 Apr 2022 09:20:09 +0200
Message-Id: <20220405070403.061171859@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit c8c80c996182239ff9b05eda4db50184cf3b2e99 ]

As the possible failure of the kzalloc(), the 'new_ts' could be NULL
pointer.
Therefore, it should be better to check it in order to avoid the
dereference of the NULL pointer.
Also, the caller esparser_queue() needs to deal with the return value of
the amvdec_add_ts().

Fixes: 876f123b8956 ("media: meson: vdec: bring up to compliance")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Suggested-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/meson/vdec/esparser.c     | 7 ++++++-
 drivers/staging/media/meson/vdec/vdec_helpers.c | 8 ++++++--
 drivers/staging/media/meson/vdec/vdec_helpers.h | 4 ++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/media/meson/vdec/esparser.c b/drivers/staging/media/meson/vdec/esparser.c
index db7022707ff8..86ccc8937afc 100644
--- a/drivers/staging/media/meson/vdec/esparser.c
+++ b/drivers/staging/media/meson/vdec/esparser.c
@@ -328,7 +328,12 @@ esparser_queue(struct amvdec_session *sess, struct vb2_v4l2_buffer *vbuf)
 
 	offset = esparser_get_offset(sess);
 
-	amvdec_add_ts(sess, vb->timestamp, vbuf->timecode, offset, vbuf->flags);
+	ret = amvdec_add_ts(sess, vb->timestamp, vbuf->timecode, offset, vbuf->flags);
+	if (ret) {
+		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_ERROR);
+		return ret;
+	}
+
 	dev_dbg(core->dev, "esparser: ts = %llu pld_size = %u offset = %08X flags = %08X\n",
 		vb->timestamp, payload_size, offset, vbuf->flags);
 
diff --git a/drivers/staging/media/meson/vdec/vdec_helpers.c b/drivers/staging/media/meson/vdec/vdec_helpers.c
index b9125c295d1d..06fd66539797 100644
--- a/drivers/staging/media/meson/vdec/vdec_helpers.c
+++ b/drivers/staging/media/meson/vdec/vdec_helpers.c
@@ -227,13 +227,16 @@ int amvdec_set_canvases(struct amvdec_session *sess,
 }
 EXPORT_SYMBOL_GPL(amvdec_set_canvases);
 
-void amvdec_add_ts(struct amvdec_session *sess, u64 ts,
-		   struct v4l2_timecode tc, u32 offset, u32 vbuf_flags)
+int amvdec_add_ts(struct amvdec_session *sess, u64 ts,
+		  struct v4l2_timecode tc, u32 offset, u32 vbuf_flags)
 {
 	struct amvdec_timestamp *new_ts;
 	unsigned long flags;
 
 	new_ts = kzalloc(sizeof(*new_ts), GFP_KERNEL);
+	if (!new_ts)
+		return -ENOMEM;
+
 	new_ts->ts = ts;
 	new_ts->tc = tc;
 	new_ts->offset = offset;
@@ -242,6 +245,7 @@ void amvdec_add_ts(struct amvdec_session *sess, u64 ts,
 	spin_lock_irqsave(&sess->ts_spinlock, flags);
 	list_add_tail(&new_ts->list, &sess->timestamps);
 	spin_unlock_irqrestore(&sess->ts_spinlock, flags);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(amvdec_add_ts);
 
diff --git a/drivers/staging/media/meson/vdec/vdec_helpers.h b/drivers/staging/media/meson/vdec/vdec_helpers.h
index 88137d15aa3a..4bf3e61d081b 100644
--- a/drivers/staging/media/meson/vdec/vdec_helpers.h
+++ b/drivers/staging/media/meson/vdec/vdec_helpers.h
@@ -56,8 +56,8 @@ void amvdec_dst_buf_done_offset(struct amvdec_session *sess,
  * @offset: offset in the VIFIFO where the associated packet was written
  * @flags: the vb2_v4l2_buffer flags
  */
-void amvdec_add_ts(struct amvdec_session *sess, u64 ts,
-		   struct v4l2_timecode tc, u32 offset, u32 flags);
+int amvdec_add_ts(struct amvdec_session *sess, u64 ts,
+		  struct v4l2_timecode tc, u32 offset, u32 flags);
 void amvdec_remove_ts(struct amvdec_session *sess, u64 ts);
 
 /**
-- 
2.34.1



