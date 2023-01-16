Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AB666CC81
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbjAPR0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbjAPR0P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:26:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B7323C5C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:03:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47530B810A0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6756C433D2;
        Mon, 16 Jan 2023 17:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888609;
        bh=jb/m2nC2WC8+JiP2lZASJi8wSAv6a843YibRZrMItWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SwnTpZsezZENgKWnd+yUNaV9WSyPPKn9Kc5eo9XRzpnS95bPXLfX6E0ClRUPJsEoR
         bQ8HWz4sqHWawupt413+oqNP51Ke/ZMl6wbk8B2rMvi5OVthrjUhIztGzSaR45Ylp5
         UV3HhOwtMph4mC29XgzXIE8GwFYptfAxFmezFio4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Shixin <liushixin2@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 070/338] media: vivid: fix compose size exceed boundary
Date:   Mon, 16 Jan 2023 16:49:03 +0100
Message-Id: <20230116154823.919063562@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit 94a7ad9283464b75b12516c5512541d467cefcf8 ]

syzkaller found a bug:

 BUG: unable to handle page fault for address: ffffc9000a3b1000
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 100000067 P4D 100000067 PUD 10015f067 PMD 1121ca067 PTE 0
 Oops: 0002 [#1] PREEMPT SMP
 CPU: 0 PID: 23489 Comm: vivid-000-vid-c Not tainted 6.1.0-rc1+ #512
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
 RIP: 0010:memcpy_erms+0x6/0x10
[...]
 Call Trace:
  <TASK>
  ? tpg_fill_plane_buffer+0x856/0x15b0
  vivid_fillbuff+0x8ac/0x1110
  vivid_thread_vid_cap_tick+0x361/0xc90
  vivid_thread_vid_cap+0x21a/0x3a0
  kthread+0x143/0x180
  ret_from_fork+0x1f/0x30
  </TASK>

This is because we forget to check boundary after adjust compose->height
int V4L2_SEL_TGT_CROP case. Add v4l2_rect_map_inside() to fix this problem
for this case.

Fixes: ef834f7836ec ("[media] vivid: add the video capture and output parts")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vivid/vivid-vid-cap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 459cff1626a6..bcc2170f2dff 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -938,6 +938,7 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 			if (dev->has_compose_cap) {
 				v4l2_rect_set_min_size(compose, &min_rect);
 				v4l2_rect_set_max_size(compose, &max_rect);
+				v4l2_rect_map_inside(compose, &fmt);
 			}
 			dev->fmt_cap_rect = fmt;
 			tpg_s_buf_height(&dev->tpg, fmt.height);
-- 
2.35.1



