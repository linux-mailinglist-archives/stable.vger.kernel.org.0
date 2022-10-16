Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3A7600169
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 18:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJPQgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 12:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiJPQgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 12:36:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FB53684E
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 09:36:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57F0860C35
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 16:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A77C433D6;
        Sun, 16 Oct 2022 16:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665938171;
        bh=691BvC7BC7JEK343KsdN1l+C0l97t5wL2WQFSZzn+K4=;
        h=Subject:To:Cc:From:Date:From;
        b=hIhm7FC18i4qXsZLWobHxXczlpNir7usrrwv7Jn5l39FPKzXnmIsgUNWzBzV1MfQk
         Almg/Jb7TDdv6v37oLtwC25gjn7GGlem8Ld3fmU2XTCrstOoPml6DpGH35DnLM3jTB
         CJezFiXe363uxq8X+Ll42VT2Zak4fICuL1YHAHZo=
Subject: FAILED: patch "[PATCH] media: cedrus: Fix endless loop in cedrus_h265_skip_bits()" failed to apply to 5.10-stable tree
To:     dmitry.osipenko@collabora.com, hverkuil-cisco@xs4all.nl,
        mchehab@kernel.org, nicolas.dufresne@collabora.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 18:36:58 +0200
Message-ID: <1665938218132118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

91db7a3fc7fe ("media: cedrus: Fix endless loop in cedrus_h265_skip_bits()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 91db7a3fc7fe670cf1770a398a43bb4a1f776bf1 Mon Sep 17 00:00:00 2001
From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Date: Thu, 18 Aug 2022 22:33:08 +0200
Subject: [PATCH] media: cedrus: Fix endless loop in cedrus_h265_skip_bits()

The busy status bit may never de-assert if number of programmed skip
bits is incorrect, resulting in a kernel hang because the bit is polled
endlessly in the code. Fix it by adding timeout for the bit-polling.
This problem is reproducible by setting the data_bit_offset field of
the HEVC slice params to a wrong value by userspace.

Cc: stable@vger.kernel.org
Fixes: 7678c5462680 (media: cedrus: Fix decoding for some HEVC videos)
Reported-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
index f703c585d91c..4952fc17f3e6 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
@@ -234,8 +234,9 @@ static void cedrus_h265_skip_bits(struct cedrus_dev *dev, int num)
 		cedrus_write(dev, VE_DEC_H265_TRIGGER,
 			     VE_DEC_H265_TRIGGER_FLUSH_BITS |
 			     VE_DEC_H265_TRIGGER_TYPE_N_BITS(tmp));
-		while (cedrus_read(dev, VE_DEC_H265_STATUS) & VE_DEC_H265_STATUS_VLD_BUSY)
-			udelay(1);
+
+		if (cedrus_wait_for(dev, VE_DEC_H265_STATUS, VE_DEC_H265_STATUS_VLD_BUSY))
+			dev_err_ratelimited(dev->dev, "timed out waiting to skip bits\n");
 
 		count += tmp;
 	}

