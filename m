Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B224E861A
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 07:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbiC0FxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 01:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiC0FxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 01:53:15 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D291B54692
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 22:51:37 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mp6-20020a17090b190600b001c6841b8a52so15821532pjb.5
        for <stable@vger.kernel.org>; Sat, 26 Mar 2022 22:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=7xvsh8FIV4X8qjBnU3ZR0V0Ttcm32tPDVRGj1HnLnug=;
        b=UPOm06GAUvzaybdgGXvA19c2r+REbrjc6OV8qaHvVnQ7T9YEGQckODDZF6w7oToRTi
         dWL8DDuqZpd1xD7ZqQhLpKz/oIIiGOBv91YMqz96xQIK6y4gZeVLWZq3G88w5cM7zCfl
         zAWDZ54z+Rh07z7yoBGW7+AdFpLLo0LiCzms+f7bqut8p3KXthl8QhrQk9o29N+TjoWu
         rAwDZqc9x+ZMi8iAG8PP1RqcKYOJHUmR/ezuWDH7+16Ck3roDOTgcmNvglMLU1ZCEAiR
         2AcAo39REnwov2/hZcQB9y8VRin7xLo1IUeXlbH8EIATl4Z+qr8Vg8OHfgPweFviniOW
         yrfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7xvsh8FIV4X8qjBnU3ZR0V0Ttcm32tPDVRGj1HnLnug=;
        b=smJUsmEDAVahhETdNaT5eqOUs+nTNeUWT4XbHVX4e2LMnduDmIle8k0bV4wHDQe2qD
         QCkRU249JKDMDPSkbjCMQZzSJWsKrOWi7ZEjN+Jxr9VwNdfzyARbWFFW3OgdVgGIvkb7
         B0AVee1EaMgewfmD0lpRFclyH8zn1+XPSLFY/2unDQ+MyKjASJkPs4JAJUVy/JJkLUB/
         87Zgn9oGR0SIsJrvEf0HJTzU1b4ZKvjt01rQIQb8EFHp7+WKYrEJbCat+Bx511fo2yOr
         Ft4Ty4BhtCGGtVpLondaxsOIHOsWVnpQoNOAVFyIBUnsIvhQHq4BjrCFhOpZnrkDvJne
         4D+g==
X-Gm-Message-State: AOAM530S9jVZgn1HO9hW1gtqM9HEq9FAtqsTldoSDTfyiMNoFNa0Pt2z
        /Bs7opQCQw9Ec70Qj9oN8oo=
X-Google-Smtp-Source: ABdhPJy+e/Vb3KP0AmrP9CCQkp2+jK+FzJpsn314qJSFIPIT753SYdRQ5bZkZhUtacUiWyLVGTXGiQ==
X-Received: by 2002:a17:90a:a017:b0:1c9:94bb:733d with SMTP id q23-20020a17090aa01700b001c994bb733dmr2009102pjp.42.1648360296939;
        Sat, 26 Mar 2022 22:51:36 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id nl17-20020a17090b385100b001c70883f6ccsm19529033pjb.36.2022.03.26.22.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:51:36 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     mchehab@kernel.org
Cc:     sakari.ailus@linux.intel.com, gregkh@linuxfoundation.org,
        hverkuil-cisco@xs4all.nl, kitakar@gmail.com,
        alinesantanacordeiro@gmail.com,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] pci: atomisp_cmd: fix three missing checks on list iterator
Date:   Sun, 27 Mar 2022 13:51:28 +0800
Message-Id: <20220327055128.3683-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Fixes: ad85094b293e4 ("Revert "media: staging: atomisp: Remove driver"")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 .../staging/media/atomisp/pci/atomisp_cmd.c   | 57 ++++++++++++-------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
index 97d5a528969b..0da0b69a4637 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
@@ -901,9 +901,9 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
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
@@ -942,60 +942,75 @@ void atomisp_buf_done(struct atomisp_sub_device *asd, int error,
 
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
-- 
2.17.1

