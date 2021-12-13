Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941024728B7
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhLMKOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240137AbhLMKE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:04:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23BEC0A885A;
        Mon, 13 Dec 2021 01:50:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D252B80E30;
        Mon, 13 Dec 2021 09:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CABC00446;
        Mon, 13 Dec 2021 09:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389030;
        bh=FWQ78MABC4XfQ0S5Odt4RPhgyYRQNMSB7PhITCvUCm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMcnFs9x16pgmoL0LdxJCTs206zzVwL0aVxK6vPhE/w+zdEE4rMWE3o96QBsWgjx0
         rn6KA7xYsO8JnjRUeQ1+S7dZfEHeZa+GCAWFr2Kcnm4PktGsHmKltN3Kp5fT6LpeHF
         H1GvFTkhOlmRAxe9VW/B+DGKWSb1q1Bf4Gv1VZTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        Lee Jones <lee.jones@linaro.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 094/132] net: cdc_ncm: Allow for dwNtbOutMaxSize to be unset or zero
Date:   Mon, 13 Dec 2021 10:30:35 +0100
Message-Id: <20211213092942.333629931@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lee Jones <lee.jones@linaro.org>

commit 2be6d4d16a0849455a5c22490e3c5983495fed00 upstream.

Currently, due to the sequential use of min_t() and clamp_t() macros,
in cdc_ncm_check_tx_max(), if dwNtbOutMaxSize is not set, the logic
sets tx_max to 0.  This is then used to allocate the data area of the
SKB requested later in cdc_ncm_fill_tx_frame().

This does not cause an issue presently because when memory is
allocated during initialisation phase of SKB creation, more memory
(512b) is allocated than is required for the SKB headers alone (320b),
leaving some space (512b - 320b = 192b) for CDC data (172b).

However, if more elements (for example 3 x u64 = [24b]) were added to
one of the SKB header structs, say 'struct skb_shared_info',
increasing its original size (320b [320b aligned]) to something larger
(344b [384b aligned]), then suddenly the CDC data (172b) no longer
fits in the spare SKB data area (512b - 384b = 128b).

Consequently the SKB bounds checking semantics fails and panics:

  skbuff: skb_over_panic: text:ffffffff830a5b5f len:184 put:172   \
     head:ffff888119227c00 data:ffff888119227c00 tail:0xb8 end:0x80 dev:<NULL>

  ------------[ cut here ]------------
  kernel BUG at net/core/skbuff.c:110!
  RIP: 0010:skb_panic+0x14f/0x160 net/core/skbuff.c:106
  <snip>
  Call Trace:
   <IRQ>
   skb_over_panic+0x2c/0x30 net/core/skbuff.c:115
   skb_put+0x205/0x210 net/core/skbuff.c:1877
   skb_put_zero include/linux/skbuff.h:2270 [inline]
   cdc_ncm_ndp16 drivers/net/usb/cdc_ncm.c:1116 [inline]
   cdc_ncm_fill_tx_frame+0x127f/0x3d50 drivers/net/usb/cdc_ncm.c:1293
   cdc_ncm_tx_fixup+0x98/0xf0 drivers/net/usb/cdc_ncm.c:1514

By overriding the max value with the default CDC_NCM_NTB_MAX_SIZE_TX
when not offered through the system provided params, we ensure enough
data space is allocated to handle the CDC data, meaning no crash will
occur.

Cc: Oliver Neukum <oliver@neukum.org>
Fixes: 289507d3364f9 ("net: cdc_ncm: use sysfs for rx/tx aggregation tuning")
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Bjørn Mork <bjorn@mork.no>
Link: https://lore.kernel.org/r/20211202143437.1411410-1-lee.jones@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ncm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -181,6 +181,8 @@ static u32 cdc_ncm_check_tx_max(struct u
 		min = ctx->max_datagram_size + ctx->max_ndp_size + sizeof(struct usb_cdc_ncm_nth32);
 
 	max = min_t(u32, CDC_NCM_NTB_MAX_SIZE_TX, le32_to_cpu(ctx->ncm_parm.dwNtbOutMaxSize));
+	if (max == 0)
+		max = CDC_NCM_NTB_MAX_SIZE_TX; /* dwNtbOutMaxSize not set */
 
 	/* some devices set dwNtbOutMaxSize too low for the above default */
 	min = min(min, max);


