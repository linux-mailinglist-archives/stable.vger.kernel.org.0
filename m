Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E342FFBF8
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 06:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbhAVFDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 00:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbhAVFDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 00:03:09 -0500
X-Greylist: delayed 426 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Jan 2021 21:02:28 PST
Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [IPv6:2a0b:5c81:1c1::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B540C06174A
        for <stable@vger.kernel.org>; Thu, 21 Jan 2021 21:02:28 -0800 (PST)
Received: from localhost.localdomain (85-76-102-71-nat.elisa-mobile.fi [85.76.102.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jks)
        by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 1C1C21B00122;
        Fri, 22 Jan 2021 06:55:18 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
        t=1611291318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nNVxmo79M/DbkplsImyEU/4ta1S8HjST/vF+5w3BUro=;
        b=bApYgMfGnowH12xNOk3khZI+4f8HKWD+cElB8LQbri4ybddPRpMNhDYUMIACoPumWXutT7
        h+8R5Pl+GXsIMAFXU1aXqog1QbDpp6H8ZRI5VgPZhEUPa90ylXCb1EEvewG6Fd83JmlTWW
        UCAk6CtzblJdDWjQ0tBE86toK1eODBMjvC5tPxwU/bsaPJyZRsTS36k2sz/SjA69ISPRdD
        ZtPw3OH+xJr6WL/epx0HNL49tuiOXS9SYWwh0RQRPuIJ68yNf6Jvu/lDepYo6GhZA7goKC
        RigrsimOTGD+F+0+PEsJqfJIYZDs15fQCYms6iqDWh27ACIQVnUc1isFQxsEGg==
From:   =?UTF-8?q?Jouni=20Sepp=C3=A4nen?= <jks@iki.fi>
To:     stable@vger.kernel.org
Cc:     =?UTF-8?q?Jouni=20K=2E=20Sepp=C3=A4nen?= <jks@iki.fi>,
        kernel test robot <lkp@intel.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>
Subject: [BACKPORT 4.4.y, 4.9.y] net: cdc_ncm: correct overhead in delayed_ndp_size
Date:   Fri, 22 Jan 2021 06:54:57 +0200
Message-Id: <20210122045457.50289-1-jks@iki.fi>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <161070228139179@kroah.com>
References: <161070228139179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1611291318; a=rsa-sha256;
        cv=none;
        b=krgUNPzMExn5424gANkg5G8+Y6oXGkquEF1Ln01WZWwJvrgKLitm/On+6ZysptB5yGBCvg
        5UkNnZ79pvtJzOUukxVLU4JtVAV2BE/ouZnfVbhOfEVpEBjW+iCminYhLSD6GE7WVKwCrd
        Oo2T4oB29IC/bIBsbKB0ojPXSILGEiyRrJdkU6eHLpndhOXdCZjA0JSmNl11SIe7ukH4Y5
        x8OiZ2o76lqgY3psJ3nZniD9UcSSTGTOrFxLvG7ixBanXN+vuyTfolWUamR3L2ba0MTWbm
        iGz3U4W12WMotmOfkfxml+C8vLC+i8lR1+BLN6hWvVyy2/YVm8Gv5rRPtXxBbA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=jks smtp.mailfrom=jks@iki.fi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=lahtoruutu; t=1611291318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nNVxmo79M/DbkplsImyEU/4ta1S8HjST/vF+5w3BUro=;
        b=JhCyLRRQCCjxZu0djvCoOE2fLwaknrnZmvqgJptBqmMVgApBWQeoPF0E1cO+pY7Ly5Ym1n
        bAGn0yGhyO4jkcWYMtkQDQARWd37ulLQl4Vbp0gnRrRzGPn51F27nWoWdTTh7JF7lh1r1w
        KYeNiyshmPbJzfOtj6WHOjiiLpZAqDQ/sogpOnZ8pDTjb4KvuYa84d0sNu2FMTZcgPfg1h
        9QIvhsTw6WQ168zba/il3nY00eJB/SaSyY7l7u1bj2LJYSbPfTVQJzoraUE+b5W0M2dk01
        mLh3vY0GEhOmwdxO0JEKYFU7sTURvXxI+Q9xOAcZw3pmREva6y/EwMBYj7XVhQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni K. Seppänen <jks@iki.fi>

commit 7a68d725e4ea384977445e0bcaed3d7de83ab5b3 upstream.

Aligning to tx_ndp_modulus is not sufficient because the next align
call can be cdc_ncm_align_tail, which can add up to ctx->tx_modulus +
ctx->tx_remainder - 1 bytes. This used to lead to occasional crashes
on a Huawei 909s-120 LTE module as follows:

- the condition marked /* if there is a remaining skb [...] */ is true
  so the swaps happen
- skb_out is set from ctx->tx_curr_skb
- skb_out->len is exactly 0x3f52
- ctx->tx_curr_size is 0x4000 and delayed_ndp_size is 0xac
  (note that the sum of skb_out->len and delayed_ndp_size is 0x3ffe)
- the for loop over n is executed once
- the cdc_ncm_align_tail call marked /* align beginning of next frame */
  increases skb_out->len to 0x3f56 (the sum is now 0x4002)
- the condition marked /* check if we had enough room left [...] */ is
  false so we break out of the loop
- the condition marked /* If requested, put NDP at end of frame. */ is
  true so the NDP is written into skb_out
- now skb_out->len is 0x4002, so padding_count is minus two interpreted
  as an unsigned number, which is used as the length argument to memset,
  leading to a crash with various symptoms but usually including

> Call Trace:
>  <IRQ>
>  cdc_ncm_fill_tx_frame+0x83a/0x970 [cdc_ncm]
>  cdc_mbim_tx_fixup+0x1d9/0x240 [cdc_mbim]
>  usbnet_start_xmit+0x5d/0x720 [usbnet]

The cdc_ncm_align_tail call first aligns on a ctx->tx_modulus
boundary (adding at most ctx->tx_modulus-1 bytes), then adds
ctx->tx_remainder bytes. Alternatively, the next alignment call can
occur in cdc_ncm_ndp16 or cdc_ncm_ndp32, in which case at most
ctx->tx_ndp_modulus-1 bytes are added.

A similar problem has occurred before, and the code is nontrivial to
reason about, so add a guard before the crashing call. By that time it
is too late to prevent any memory corruption (we'll have written past
the end of the buffer already) but we can at least try to get a warning
written into an on-disk log by avoiding the hard crash caused by padding
past the buffer with a huge number of zeros.

Signed-off-by: Jouni K. Seppänen <jks@iki.fi>
Fixes: 4a0e3e989d66 ("cdc_ncm: Add support for moving NDP to end of NCM frame")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=209407
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
[jks@iki.fi: backport to 4.4.y, 4.9.y]
Signed-off-by: Jouni K. Seppänen <jks@iki.fi>
---
Backport to 4.4.y and 4.9.y: there is no skb_put_zero or ctx->tx_curr_size
so use memset(skb_put(...)) and ctx->tx_max, respectively.

 drivers/net/usb/cdc_ncm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index e9f82b67c7ed..8de7797ea7e7 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1079,7 +1079,10 @@ cdc_ncm_fill_tx_frame(struct usbnet *dev, struct sk_buff *skb, __le32 sign)
 	 * accordingly. Otherwise, we should check here.
 	 */
 	if (ctx->drvflags & CDC_NCM_FLAG_NDP_TO_END)
-		delayed_ndp_size = ALIGN(ctx->max_ndp_size, ctx->tx_ndp_modulus);
+		delayed_ndp_size = ctx->max_ndp_size +
+			max_t(u32,
+			      ctx->tx_ndp_modulus,
+			      ctx->tx_modulus + ctx->tx_remainder) - 1;
 	else
 		delayed_ndp_size = 0;

@@ -1232,7 +1235,8 @@ cdc_ncm_fill_tx_frame(struct usbnet *dev, struct sk_buff *skb, __le32 sign)
 	if (!(dev->driver_info->flags & FLAG_SEND_ZLP) &&
 	    skb_out->len > ctx->min_tx_pkt) {
 		padding_count = ctx->tx_max - skb_out->len;
-		memset(skb_put(skb_out, padding_count), 0, padding_count);
+		if (!WARN_ON(padding_count > ctx->tx_max))
+			memset(skb_put(skb_out, padding_count), 0, padding_count);
 	} else if (skb_out->len < ctx->tx_max &&
 		   (skb_out->len % dev->maxpacket) == 0) {
 		*skb_put(skb_out, 1) = 0;	/* force short packet */
--
2.20.1
