Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44B0353CF8E
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345706AbiFCRyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347267AbiFCRwK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:52:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC92812AAC;
        Fri,  3 Jun 2022 10:51:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73F7EB82189;
        Fri,  3 Jun 2022 17:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A565EC385B8;
        Fri,  3 Jun 2022 17:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278710;
        bh=k8dwY4UsBqEZIeUNq0npNOB1aRN/HTu4O5GznizTuIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olCYCKnAmKbKRQrp4JbJ/RcMfMHq2bfsV52Szyv2OPGkf/VA3yXZKbfF3nWAIvhCE
         zsHJc5PLrkCD5MydxrvnGnnGwZOePnolN53Lkj5fVg297W821LCry8rM3QMy5sN6iy
         aBz4lwdf4GfXr/ibLA8PevDSCBxlePtM0m++yGRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andr=C3=A9=20Kapelrud?= <a.kapelrud@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 38/66] ALSA: usb-audio: Add missing ep_idx in fixed EP quirks
Date:   Fri,  3 Jun 2022 19:43:18 +0200
Message-Id: <20220603173821.775056441@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
References: <20220603173820.663747061@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 7b0efea4baf02f5e2f89e5f9b75ef891571b45f1 upstream.

The quirk entry for Focusrite Saffire 6 had no proper ep_idx for the
capture endpoint, and this confused the driver, resulting in the
broken sound.  This patch adds the missing ep_idx in the entry.

While we are at it, a couple of other entries (for Digidesign MBox and
MOTU MicroBook II) seem to have the same problem, and those are
covered as well.

Fixes: bf6313a0ff76 ("ALSA: usb-audio: Refactor endpoint management")
Reported-by: André Kapelrud <a.kapelrud@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220521065325.426-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks-table.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2672,6 +2672,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.altset_idx = 1,
 					.attributes = 0,
 					.endpoint = 0x82,
+					.ep_idx = 1,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC,
 					.datainterval = 1,
 					.maxpacksize = 0x0126,
@@ -2875,6 +2876,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.altset_idx = 1,
 					.attributes = 0x4,
 					.endpoint = 0x81,
+					.ep_idx = 1,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						USB_ENDPOINT_SYNC_ASYNC,
 					.maxpacksize = 0x130,
@@ -3391,6 +3393,7 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.altset_idx = 1,
 					.attributes = 0,
 					.endpoint = 0x03,
+					.ep_idx = 1,
 					.rates = SNDRV_PCM_RATE_96000,
 					.ep_attr = USB_ENDPOINT_XFER_ISOC |
 						   USB_ENDPOINT_SYNC_ASYNC,


