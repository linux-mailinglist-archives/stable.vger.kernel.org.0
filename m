Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B57453D0C7
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346493AbiFCSHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346729AbiFCSFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:05:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4352122B2C;
        Fri,  3 Jun 2022 10:58:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83F12615E3;
        Fri,  3 Jun 2022 17:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75AF5C385B8;
        Fri,  3 Jun 2022 17:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654279048;
        bh=k8dwY4UsBqEZIeUNq0npNOB1aRN/HTu4O5GznizTuIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXNmc5cVJZwLxupz1V1v7oLjo3Zcjc8ZhVFD90F27bedTjopSsZvOb2+vU0bjXItM
         KeiodrPY4Qu06JR4UAxi7pee6rcw+jfQy9+/iLgBIjq8ST16kcV1VIAK+MBdgoL6iO
         kTT3kzGgIZRds5tepgEgq7yGsTt9pSHEgbuU+J3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andr=C3=A9=20Kapelrud?= <a.kapelrud@gmail.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.18 35/67] ALSA: usb-audio: Add missing ep_idx in fixed EP quirks
Date:   Fri,  3 Jun 2022 19:43:36 +0200
Message-Id: <20220603173821.742858262@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
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


