Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE9F6578C4
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbiL1Ox6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbiL1Ox4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:53:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D55B95
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:53:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E7DB61540
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:53:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FA7C433D2;
        Wed, 28 Dec 2022 14:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239235;
        bh=tUsVKxn27BdMvYIkmS7RoEiAmmkFH3wvzkSJd7B0bGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ls0pqjd9/NzckJcx28/SkpZxICn2Y/paxyWZCVA9i3SLIRFekDNtRfpvuIbb07YBp
         n/O8AKA86ABKDXcUvGS3KcwMGrckFzTopLYjrvuT6Sp2wK//KPDeWpamaEoBLhDF1F
         ztHlx4i3zEi1XxMQcQVpInNGANQsfLZHmrW47uFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Shixin <liushixin2@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 180/731] media: vivid: fix compose size exceed boundary
Date:   Wed, 28 Dec 2022 15:34:47 +0100
Message-Id: <20221228144301.780762077@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
 drivers/media/test-drivers/vivid/vivid-vid-cap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
index 99139a8cd4c4..331a3f4286d2 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -961,6 +961,7 @@ int vivid_vid_cap_s_selection(struct file *file, void *fh, struct v4l2_selection
 			if (dev->has_compose_cap) {
 				v4l2_rect_set_min_size(compose, &min_rect);
 				v4l2_rect_set_max_size(compose, &max_rect);
+				v4l2_rect_map_inside(compose, &fmt);
 			}
 			dev->fmt_cap_rect = fmt;
 			tpg_s_buf_height(&dev->tpg, fmt.height);
-- 
2.35.1



