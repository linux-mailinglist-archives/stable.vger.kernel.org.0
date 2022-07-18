Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C24578697
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 17:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiGRPod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 11:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiGRPoc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 11:44:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D55810FDE
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 08:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13811612DF
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 15:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD746C341CB;
        Mon, 18 Jul 2022 15:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658159070;
        bh=u26qM39Oc/RTdTDTRW2k3R2EYLqJyh27PcsDNhfFQN4=;
        h=Subject:To:Cc:From:Date:From;
        b=RUxV68oPZQSZ8N5Y3WFvk/jMb7ba5hW1E9sjmito8gOlQsl2qWYlIvNwttyUKDA6C
         j+nni/CoKzwDyjwzOvLudwMpTgmDqOJD3DSPHEQzAWJ1acP87+Mw7h1mFCVqDXZDwt
         gmP9g4jv86trHtTHRkvVgG0+J7HJ/yL5T+gXxJlc=
Subject: FAILED: patch "[PATCH] vt: fix memory overlapping when deleting chars in the buffer" failed to apply to 5.4-stable tree
To:     xyangxi5@gmail.com, gregkh@linuxfoundation.org, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Jul 2022 17:44:27 +0200
Message-ID: <16581590673858@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 39cdb68c64d84e71a4a717000b6e5de208ee60cc Mon Sep 17 00:00:00 2001
From: Yangxi Xiang <xyangxi5@gmail.com>
Date: Tue, 28 Jun 2022 17:33:22 +0800
Subject: [PATCH] vt: fix memory overlapping when deleting chars in the buffer

A memory overlapping copy occurs when deleting a long line. This memory
overlapping copy can cause data corruption when scr_memcpyw is optimized
to memcpy because memcpy does not ensure its behavior if the destination
buffer overlaps with the source buffer. The line buffer is not always
broken, because the memcpy utilizes the hardware acceleration, whose
result is not deterministic.

Fix this problem by using replacing the scr_memcpyw with scr_memmovew.

Fixes: 81732c3b2fed ("tty vt: Fix line garbage in virtual console on command line edition")
Cc: stable <stable@kernel.org>
Signed-off-by: Yangxi Xiang <xyangxi5@gmail.com>
Link: https://lore.kernel.org/r/20220628093322.5688-1-xyangxi5@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index f8c87c4d7399..dfc1f4b445f3 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -855,7 +855,7 @@ static void delete_char(struct vc_data *vc, unsigned int nr)
 	unsigned short *p = (unsigned short *) vc->vc_pos;
 
 	vc_uniscr_delete(vc, nr);
-	scr_memcpyw(p, p + nr, (vc->vc_cols - vc->state.x - nr) * 2);
+	scr_memmovew(p, p + nr, (vc->vc_cols - vc->state.x - nr) * 2);
 	scr_memsetw(p + vc->vc_cols - vc->state.x - nr, vc->vc_video_erase_char,
 			nr * 2);
 	vc->vc_need_wrap = 0;

