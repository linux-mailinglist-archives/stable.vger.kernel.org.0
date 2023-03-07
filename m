Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA8B6AEB41
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjCGRl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbjCGRlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:41:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B7AA6BEB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:37:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9173B8191D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0A9C433A0;
        Tue,  7 Mar 2023 17:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210649;
        bh=GxxFSXMNTqKtNsSPRZSLW+3w8I9CBF/zqPlg4wgMPYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnARjzm8x3O4xFVdr/h8n2VcNVVn6yPW5/9r/HlDgiVfzQJ4eMRjQGsEWdT3tcOxA
         sQvdUvDtJeKxZ4FVnpx/dIVTdLOZThZVHQLvAIA5tJrdBiFiGusMJTYNPjQgEDi8Lr
         xaOL1CbezR/3YcIdv07egOtfJYApQ1E0qEAWjAj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dong Chuanjian <chuanjian@nfschina.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0609/1001] media: drivers/media/v4l2-core/v4l2-h264 : add detection of null pointers
Date:   Tue,  7 Mar 2023 17:56:21 +0100
Message-Id: <20230307170047.935274353@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dong Chuanjian <chuanjian@nfschina.com>

[ Upstream commit be3ae7cf4326e95bb1d5413b63baabc26f4a1324 ]

When the pointer variable is judged to be null, null is returned
directly.

[hverkuil: fix two checkpatch warnings]

Signed-off-by: Dong Chuanjian <chuanjian@nfschina.com>
Acked-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Fixes: d3f756ad629b ("media: v4l2: Trace calculated p/b0/b1 initial reflist")
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-h264.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-h264.c b/drivers/media/v4l2-core/v4l2-h264.c
index 72bd64f651981..c00197d095e75 100644
--- a/drivers/media/v4l2-core/v4l2-h264.c
+++ b/drivers/media/v4l2-core/v4l2-h264.c
@@ -305,6 +305,8 @@ static const char *format_ref_list_p(const struct v4l2_h264_reflist_builder *bui
 	int n = 0, i;
 
 	*out_str = kmalloc(tmp_str_size, GFP_KERNEL);
+	if (!(*out_str))
+		return NULL;
 
 	n += snprintf(*out_str + n, tmp_str_size - n, "|");
 
@@ -343,6 +345,8 @@ static const char *format_ref_list_b(const struct v4l2_h264_reflist_builder *bui
 	int n = 0, i;
 
 	*out_str = kmalloc(tmp_str_size, GFP_KERNEL);
+	if (!(*out_str))
+		return NULL;
 
 	n += snprintf(*out_str + n, tmp_str_size - n, "|");
 
-- 
2.39.2



