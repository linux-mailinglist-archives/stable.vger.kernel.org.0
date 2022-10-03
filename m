Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41BB15F2989
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiJCHVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiJCHUP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D30474F3;
        Mon,  3 Oct 2022 00:15:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DCB360FA7;
        Mon,  3 Oct 2022 07:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F137C433C1;
        Mon,  3 Oct 2022 07:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781291;
        bh=eMVD5vPmyzguqMoRJC/4QF+/CMCuXrg6Wt+trtOEB+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akf6TT1v6/a5PaB4fJF98cfEpzVxVtdgQNpWlAtx88AKwQL/RBknePy25uk8jKyWc
         7P8tFxeaR2BIIeb9tK7jrUYNV3U8Fvee3X2zkIEP8SVeH6CaIA/24CNa6P8A8cWD2M
         QLxUVO8MyJ2z1Ni6qyyZDR3+2ksjqqk9rVaAEixw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+ff18193ff05f3f87f226@syzkaller.appspotmail.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.19 050/101] media: v4l2-compat-ioctl32.c: zero buffer passed to v4l2_compat_get_array_args()
Date:   Mon,  3 Oct 2022 09:10:46 +0200
Message-Id: <20221003070725.704303593@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 4e768c8e34e639cff66a0f175bc4aebf472e4305 upstream.

The v4l2_compat_get_array_args() function can leave uninitialized memory in the
buffer it is passed. So zero it before copying array elements from userspace
into the buffer.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: syzbot+ff18193ff05f3f87f226@syzkaller.appspotmail.com
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -1040,6 +1040,8 @@ int v4l2_compat_get_array_args(struct fi
 {
 	int err = 0;
 
+	memset(mbuf, 0, array_size);
+
 	switch (cmd) {
 	case VIDIOC_G_FMT32:
 	case VIDIOC_S_FMT32:


