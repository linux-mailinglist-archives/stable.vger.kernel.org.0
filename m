Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E957059434B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347869AbiHOWUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350797AbiHOWSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:18:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69E5419BB;
        Mon, 15 Aug 2022 12:41:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93219B80EA7;
        Mon, 15 Aug 2022 19:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1B8AC433D6;
        Mon, 15 Aug 2022 19:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592514;
        bh=sJwBtXUrD47c4QQvixP6qvX5NK11LGGDAI+blx1in/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tXvu4NAFpgLQ16AYq4ELJyGlNMi9IG0P8GZTDgm+/M5A6aszNrBlT1X7S0dSMqKmO
         alNBTuWWav0lbFC47mEKkdUHClzN015mnOxfN1mzdnmUUzFjZQynSArIq2Jh4Pdzpx
         ni5miGsaM5onC4dB/aD913abI7YDeTALcgjv4ios=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.19 0123/1157] media: [PATCH] pci: atomisp_cmd: fix three missing checks on list iterator
Date:   Mon, 15 Aug 2022 19:51:19 +0200
Message-Id: <20220815180444.522818934@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit 09b204eb9de9fdf07d028c41c4331b5cfeb70dd7 upstream.

The three bugs are here:
	__func__, s3a_buf->s3a_data->exp_id);
	__func__, md_buf->metadata->exp_id);
	__func__, dis_buf->dis_data->exp_id);

The list iterator 's3a_buf/md_buf/dis_buf' will point to a bogus
position containing HEAD if the list is empty or no element is found.
This case must be checked before any use of the iterator, otherwise
it will lead to a invalid memory access.

To fix this bug, add an check. Use a new variable '*_iter' as the
list iterator, while use the old variable '*_buf' as a dedicated
pointer to point to the found element.

Link: https://lore.kernel.org/linux-media/20220414041415.3342-1-xiam0nd.tong@gmail.com
Cc: stable@vger.kernel.org
Fixes: ad85094b293e4 ("Revert "media: staging: atomisp: Remove driver"")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/atomisp/pci/atomisp_cmd.c |   57 +++++++++++++++---------
 1 file changed, 36 insertions(+), 21 deletions(-)

--- a/drivers/staging/media/atomisp/pci/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
@@ -901,9 +901,9 @@ void atomisp_buf_done(struct atomisp_sub
 	int err;
 	unsigned long irqflags;
 	struct ia_css_frame *frame = NULL;
-	struct atomisp_s3a_buf *s3a_buf = NULL, *_s3a_buf_tmp;
-	struct atomisp_dis_buf *dis_buf = NULL, *_dis_buf_tmp;
-	struct atomisp_metadata_buf *md_buf = NULL, *_md_buf_tmp;
+	struct atomisp_s3a_buf *s3a_buf = NULL, *_s3a_buf_tmp, *s3a_iter;
+	struct atomisp_dis_buf *dis_buf = NULL, *_dis_buf_tmp, *dis_iter;
+	struct atomisp_metadata_buf *md_buf = NULL, *_md_buf_tmp, *md_iter;
 	enum atomisp_metadata_type md_type;
 	struct atomisp_device *isp = asd->isp;
 	struct v4l2_control ctrl;
@@ -942,60 +942,75 @@ void atomisp_buf_done(struct atomisp_sub
 
 	switch (buf_type) {
 	case IA_CSS_BUFFER_TYPE_3A_STATISTICS:
-		list_for_each_entry_safe(s3a_buf, _s3a_buf_tmp,
+		list_for_each_entry_safe(s3a_iter, _s3a_buf_tmp,
 					 &asd->s3a_stats_in_css, list) {
-			if (s3a_buf->s3a_data ==
+			if (s3a_iter->s3a_data ==
 			    buffer.css_buffer.data.stats_3a) {
-				list_del_init(&s3a_buf->list);
-				list_add_tail(&s3a_buf->list,
+				list_del_init(&s3a_iter->list);
+				list_add_tail(&s3a_iter->list,
 					      &asd->s3a_stats_ready);
+				s3a_buf = s3a_iter;
 				break;
 			}
 		}
 
 		asd->s3a_bufs_in_css[css_pipe_id]--;
 		atomisp_3a_stats_ready_event(asd, buffer.css_buffer.exp_id);
-		dev_dbg(isp->dev, "%s: s3a stat with exp_id %d is ready\n",
-			__func__, s3a_buf->s3a_data->exp_id);
+		if (s3a_buf)
+			dev_dbg(isp->dev, "%s: s3a stat with exp_id %d is ready\n",
+				__func__, s3a_buf->s3a_data->exp_id);
+		else
+			dev_dbg(isp->dev, "%s: s3a stat is ready with no exp_id found\n",
+				__func__);
 		break;
 	case IA_CSS_BUFFER_TYPE_METADATA:
 		if (error)
 			break;
 
 		md_type = atomisp_get_metadata_type(asd, css_pipe_id);
-		list_for_each_entry_safe(md_buf, _md_buf_tmp,
+		list_for_each_entry_safe(md_iter, _md_buf_tmp,
 					 &asd->metadata_in_css[md_type], list) {
-			if (md_buf->metadata ==
+			if (md_iter->metadata ==
 			    buffer.css_buffer.data.metadata) {
-				list_del_init(&md_buf->list);
-				list_add_tail(&md_buf->list,
+				list_del_init(&md_iter->list);
+				list_add_tail(&md_iter->list,
 					      &asd->metadata_ready[md_type]);
+				md_buf = md_iter;
 				break;
 			}
 		}
 		asd->metadata_bufs_in_css[stream_id][css_pipe_id]--;
 		atomisp_metadata_ready_event(asd, md_type);
-		dev_dbg(isp->dev, "%s: metadata with exp_id %d is ready\n",
-			__func__, md_buf->metadata->exp_id);
+		if (md_buf)
+			dev_dbg(isp->dev, "%s: metadata with exp_id %d is ready\n",
+				__func__, md_buf->metadata->exp_id);
+		else
+			dev_dbg(isp->dev, "%s: metadata is ready with no exp_id found\n",
+				__func__);
 		break;
 	case IA_CSS_BUFFER_TYPE_DIS_STATISTICS:
-		list_for_each_entry_safe(dis_buf, _dis_buf_tmp,
+		list_for_each_entry_safe(dis_iter, _dis_buf_tmp,
 					 &asd->dis_stats_in_css, list) {
-			if (dis_buf->dis_data ==
+			if (dis_iter->dis_data ==
 			    buffer.css_buffer.data.stats_dvs) {
 				spin_lock_irqsave(&asd->dis_stats_lock,
 						  irqflags);
-				list_del_init(&dis_buf->list);
-				list_add(&dis_buf->list, &asd->dis_stats);
+				list_del_init(&dis_iter->list);
+				list_add(&dis_iter->list, &asd->dis_stats);
 				asd->params.dis_proj_data_valid = true;
 				spin_unlock_irqrestore(&asd->dis_stats_lock,
 						       irqflags);
+				dis_buf = dis_iter;
 				break;
 			}
 		}
 		asd->dis_bufs_in_css--;
-		dev_dbg(isp->dev, "%s: dis stat with exp_id %d is ready\n",
-			__func__, dis_buf->dis_data->exp_id);
+		if (dis_buf)
+			dev_dbg(isp->dev, "%s: dis stat with exp_id %d is ready\n",
+				__func__, dis_buf->dis_data->exp_id);
+		else
+			dev_dbg(isp->dev, "%s: dis stat is ready with no exp_id found\n",
+				__func__);
 		break;
 	case IA_CSS_BUFFER_TYPE_VF_OUTPUT_FRAME:
 	case IA_CSS_BUFFER_TYPE_SEC_VF_OUTPUT_FRAME:


