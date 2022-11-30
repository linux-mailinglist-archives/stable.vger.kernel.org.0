Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCBC63E038
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiK3Sys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiK3Syp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:54:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC1D63D71
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:54:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 164AEB81C9F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA00C433C1;
        Wed, 30 Nov 2022 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834481;
        bh=r7DISqQvnY14qRs9H5Qq+197aEEUQtzbfRvG+51nz/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1q2mMiE4bvA1XLjatjoBSUNDXIb+goz8U4X1Kf3NlP1A500TlW3T/+vbjchhUd1qw
         rMAyoxGoufpHRHPH6QIaDAfVoEAw4vYba0gx18LwgRJ+H9e+3R1gY0eawXFXvm8KGK
         TEqAFgeUn3d04UInTBHb+nKvLAWCDVrVpPkTAPVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Phil Turnbull <philipturnbull@github.com>,
        Ajay Kathat <ajay.kathat@microchip.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.0 270/289] wifi: wilc1000: validate number of channels
Date:   Wed, 30 Nov 2022 19:24:15 +0100
Message-Id: <20221130180550.219335132@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Phil Turnbull <philipturnbull@github.com>

commit 0cdfa9e6f0915e3d243e2393bfa8a22e12d553b0 upstream.

There is no validation of 'e->no_of_channels' which can trigger an
out-of-bounds write in the following 'memset' call. Validate that the
number of channels does not extends beyond the size of the channel list
element.

Signed-off-by: Phil Turnbull <philipturnbull@github.com>
Tested-by: Ajay Kathat <ajay.kathat@microchip.com>
Acked-by: Ajay Kathat <ajay.kathat@microchip.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221123153543.8568-5-philipturnbull@github.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |   22 +++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -978,19 +978,29 @@ static inline void wilc_wfi_cfg_parse_ch
 	}
 
 	if (ch_list_idx) {
-		u16 attr_size;
-		struct wilc_ch_list_elem *e;
-		int i;
+		u16 elem_size;
 
 		ch_list = (struct wilc_attr_ch_list *)&buf[ch_list_idx];
-		attr_size = le16_to_cpu(ch_list->attr_len);
-		for (i = 0; i < attr_size;) {
+		/* the number of bytes following the final 'elem' member */
+		elem_size = le16_to_cpu(ch_list->attr_len) -
+			(sizeof(*ch_list) - sizeof(struct wilc_attr_entry));
+		for (unsigned int i = 0; i < elem_size;) {
+			struct wilc_ch_list_elem *e;
+
 			e = (struct wilc_ch_list_elem *)(ch_list->elem + i);
+
+			i += sizeof(*e);
+			if (i > elem_size)
+				break;
+
+			i += e->no_of_channels;
+			if (i > elem_size)
+				break;
+
 			if (e->op_class == WILC_WLAN_OPERATING_CLASS_2_4GHZ) {
 				memset(e->ch_list, sta_ch, e->no_of_channels);
 				break;
 			}
-			i += e->no_of_channels;
 		}
 	}
 


