Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E9E60868C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 09:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbiJVHux (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 03:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiJVHsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:48:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C93C199F6B;
        Sat, 22 Oct 2022 00:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0D0660B90;
        Sat, 22 Oct 2022 07:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3E9C433C1;
        Sat, 22 Oct 2022 07:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424469;
        bh=BMhRM4nqWbjmRpKYBjSHNb+WOA6zO/H96SN3tqK7YGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mzblqz1cmdf6/pW4s7ZSdzBrX2jRSMu7u5ZmQN2EXgK7nZM0Js6CoK1oxt8PPUWAv
         oMpAH2J3uIb0uLTAaOiuKvqyY3fottfxNRKckoq8gx1loxI3b6bAO92Qn1ahpaguhE
         BNvtZ8LWFTMI9cVrCrL2XBIkzSXSfjORL1Q9OTug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.19 157/717] media: cedrus: Fix endless loop in cedrus_h265_skip_bits()
Date:   Sat, 22 Oct 2022 09:20:36 +0200
Message-Id: <20221022072443.234474692@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit 91db7a3fc7fe670cf1770a398a43bb4a1f776bf1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus_h265.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
@@ -234,8 +234,9 @@ static void cedrus_h265_skip_bits(struct
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


