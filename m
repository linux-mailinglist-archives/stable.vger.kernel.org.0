Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632746B4508
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbjCJOaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjCJOaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:30:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5746DF710
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:29:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 216F8616F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A081C4339B;
        Fri, 10 Mar 2023 14:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458539;
        bh=/io6TGBZ0C0utETNcgrk2PLzNbjahNUth7FUQQL6F2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhz2lvbJt6caUiNGMZhTss+0rcsasvYSv6MtJBlaLpyOiw0YkS5EyohcB7ZsAWWTY
         5tO1CFGlw/qohwhZ33frgqCkytjqYXiB5iDbv7ygav+xWzE18UnouPVhIvLQn1aHWt
         YxEESGRcVnK2Xh0GTTyg04biT5JX4wZcn8FO0tM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/357] wifi: ath9k: Fix potential stack-out-of-bounds write in ath9k_wmi_rsp_callback()
Date:   Fri, 10 Mar 2023 14:35:50 +0100
Message-Id: <20230310133736.668861898@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minsuk Kang <linuxlovemin@yonsei.ac.kr>

[ Upstream commit 8a2f35b9830692f7a616f2f627f943bc748af13a ]

Fix a stack-out-of-bounds write that occurs in a WMI response callback
function that is called after a timeout occurs in ath9k_wmi_cmd().
The callback writes to wmi->cmd_rsp_buf, a stack-allocated buffer that
could no longer be valid when a timeout occurs. Set wmi->last_seq_id to
0 when a timeout occurred.

Found by a modified version of syzkaller.

BUG: KASAN: stack-out-of-bounds in ath9k_wmi_ctrl_rx
Write of size 4
Call Trace:
 memcpy
 ath9k_wmi_ctrl_rx
 ath9k_htc_rx_msg
 ath9k_hif_usb_reg_in_cb
 __usb_hcd_giveback_urb
 usb_hcd_giveback_urb
 dummy_timer
 call_timer_fn
 run_timer_softirq
 __do_softirq
 irq_exit_rcu
 sysvec_apic_timer_interrupt

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230104124130.10996-1-linuxlovemin@yonsei.ac.kr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index e7a3127395be9..deb22b8c2065f 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -338,6 +338,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	if (!time_left) {
 		ath_dbg(common, WMI, "Timeout waiting for WMI command: %s\n",
 			wmi_cmd_to_name(cmd_id));
+		wmi->last_seq_id = 0;
 		mutex_unlock(&wmi->op_mutex);
 		return -ETIMEDOUT;
 	}
-- 
2.39.2



