Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED17B5F2A4F
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiJCHfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbiJCHe2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:34:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EAC52DFC;
        Mon,  3 Oct 2022 00:22:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E07C1CE0B19;
        Mon,  3 Oct 2022 07:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2581C433C1;
        Mon,  3 Oct 2022 07:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781483;
        bh=V38LlX0q8zKlpeuuZ8af615SwKazMoTeMAv5NP354dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvKew4cJ+tK3rkbqstBDJNsdc2a4jAsqPPIuFYBCqoRIEOn/bbTBbbN8bsg4wYR8C
         AOauNAb6SvBKDa5OA2knGzSJA5dJ2ebMZ/FmhrJvOufd6j85mxeNjgtkD/3kVXs0TD
         y5inYD4JQprBHxtc69ayzb5q1+riX3l/RP0ovRe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        syzbot+ff18193ff05f3f87f226@syzkaller.appspotmail.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 37/83] media: v4l2-compat-ioctl32.c: zero buffer passed to v4l2_compat_get_array_args()
Date:   Mon,  3 Oct 2022 09:11:02 +0200
Message-Id: <20221003070722.926248909@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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
@@ -1033,6 +1033,8 @@ int v4l2_compat_get_array_args(struct fi
 {
 	int err = 0;
 
+	memset(mbuf, 0, array_size);
+
 	switch (cmd) {
 	case VIDIOC_G_FMT32:
 	case VIDIOC_S_FMT32:


