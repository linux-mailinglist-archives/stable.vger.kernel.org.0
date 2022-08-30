Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481ED5A6575
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 15:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbiH3Nt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 09:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbiH3NtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 09:49:13 -0400
X-Greylist: delayed 1066 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 Aug 2022 06:47:03 PDT
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9073C633F
        for <stable@vger.kernel.org>; Tue, 30 Aug 2022 06:47:03 -0700 (PDT)
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1oT1Io-005To5-CS; Tue, 30 Aug 2022 13:29:14 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Tue, 30 Aug 2022 12:48:45 +0000
Subject: [git:media_stage/master] media: cedrus: Fix endless loop in cedrus_h265_skip_bits()
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1oT1Io-005To5-CS@www.linuxtv.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: cedrus: Fix endless loop in cedrus_h265_skip_bits()
Author:  Dmitry Osipenko <dmitry.osipenko@collabora.com>
Date:    Thu Aug 18 22:33:08 2022 +0200

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

 drivers/staging/media/sunxi/cedrus/cedrus_h265.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

---

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
