Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13BC06AF35B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbjCGTED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:04:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjCGTDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:03:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B66AA72A9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:49:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18060B819CA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5028DC433EF;
        Tue,  7 Mar 2023 18:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214959;
        bh=sUZm+FyBMYJ6zyPvw9griu/YdHdoy8TRddoR0u202i4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQ7EGBJpZmZD0/3vT5DVLe7pxxfJ0gVuyA949z7mDbCsrNy1x0/LvfnEZJGVViUvp
         RK8lHy8V2GA8uW5hCSanR9/6YjuUJK2Gan9+qhorm0xsbnFRsfiFoWMNEAUJX0T6Ls
         g3LekHaDQMIsXgyJI6TVw7n/aMXY4mYoQh60QHwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/567] wifi: ath9k: Fix potential stack-out-of-bounds write in ath9k_wmi_rsp_callback()
Date:   Tue,  7 Mar 2023 17:57:21 +0100
Message-Id: <20230307165910.432236508@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index f315c54bd3ac0..19345b8f7bfd5 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -341,6 +341,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	if (!time_left) {
 		ath_dbg(common, WMI, "Timeout waiting for WMI command: %s\n",
 			wmi_cmd_to_name(cmd_id));
+		wmi->last_seq_id = 0;
 		mutex_unlock(&wmi->op_mutex);
 		return -ETIMEDOUT;
 	}
-- 
2.39.2



