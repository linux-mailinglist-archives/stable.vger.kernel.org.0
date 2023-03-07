Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C686AEB56
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjCGRna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231933AbjCGRm5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:42:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B2497FE7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:38:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55356B818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828C6C433EF;
        Tue,  7 Mar 2023 17:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210734;
        bh=QioM45GSu6RlvuZ3KG0MQZMzy2hWYn1NtDAf7zdVdq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A18e4K9HZjeHmrDGGqjrDLvnSS+7vI4g3t3YuGLDt2vC07b7AxRhK/gh3gzld87zp
         guxprHnbv6+XnUrIBlC1lK/3VGuzFLw7b5B+qdcxXsiruBQMrPpz+iM8EGry9XAaGR
         e8RaybNR7sO4skTfprVAS6Ve0FvCaSCrE60S9f1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Schmidt <florian@fls.name>,
        Nagarajan Maran <quic_nmaran@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0637/1001] wifi: ath11k: fix monitor mode bringup crash
Date:   Tue,  7 Mar 2023 17:56:49 +0100
Message-Id: <20230307170049.234219198@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Nagarajan Maran <quic_nmaran@quicinc.com>

[ Upstream commit 950b43f8bd8a4d476d2da6d2a083a89bcd3c90d7 ]

When the interface is brought up in monitor mode, it leads
to NULL pointer dereference crash. This crash happens when
the packet type is extracted for a SKB. This extraction
which is present in the received msdu delivery path,is
not needed for the monitor ring packets since they are
all RAW packets. Hence appending the flags with
"RX_FLAG_ONLY_MONITOR" to skip that extraction.

Observed calltrace:

Unable to handle kernel NULL pointer dereference at virtual address
0000000000000064
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004
  CM = 0, WnR = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=0000000048517000
[0000000000000064] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
Modules linked in: ath11k_pci ath11k qmi_helpers
CPU: 2 PID: 1781 Comm: napi/-271 Not tainted
6.1.0-rc5-wt-ath-656295-gef907406320c-dirty #6
Hardware name: Qualcomm Technologies, Inc. IPQ8074/AP-HK10-C2 (DT)
pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : ath11k_hw_qcn9074_rx_desc_get_decap_type+0x34/0x60 [ath11k]
lr : ath11k_hw_qcn9074_rx_desc_get_decap_type+0x5c/0x60 [ath11k]
sp : ffff80000ef5bb10
x29: ffff80000ef5bb10 x28: 0000000000000000 x27: ffff000007baafa0
x26: ffff000014a91ed0 x25: 0000000000000000 x24: 0000000000000000
x23: ffff800002b77378 x22: ffff000014a91ec0 x21: ffff000006c8d600
x20: 0000000000000000 x19: ffff800002b77740 x18: 0000000000000006
x17: 736564203634343a x16: 656e694c20657079 x15: 0000000000000143
x14: 00000000ffffffea x13: ffff80000ef5b8b8 x12: ffff80000ef5b8c8
x11: ffff80000a591d30 x10: ffff80000a579d40 x9 : c0000000ffffefff
x8 : 0000000000000003 x7 : 0000000000017fe8 x6 : ffff80000a579ce8
x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
x2 : 3a35ec12ed7f8900 x1 : 0000000000000000 x0 : 0000000000000052
Call trace:
 ath11k_hw_qcn9074_rx_desc_get_decap_type+0x34/0x60 [ath11k]
 ath11k_dp_rx_deliver_msdu.isra.42+0xa4/0x3d0 [ath11k]
 ath11k_dp_rx_mon_deliver.isra.43+0x2f8/0x458 [ath11k]
 ath11k_dp_rx_process_mon_rings+0x310/0x4c0 [ath11k]
 ath11k_dp_service_srng+0x234/0x338 [ath11k]
 ath11k_pcic_ext_grp_napi_poll+0x30/0xb8 [ath11k]
 __napi_poll+0x5c/0x190
 napi_threaded_poll+0xf0/0x118
 kthread+0xf4/0x110
 ret_from_fork+0x10/0x20

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.7.0.1-01744-QCAHKSWPL_SILICONZ-1
Reported-by: Florian Schmidt <florian@fls.name>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216573
Signed-off-by: Nagarajan Maran <quic_nmaran@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221129142532.23421-1-quic_nmaran@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 0c53d88293eb7..e964e1b722871 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -5023,6 +5023,7 @@ static int ath11k_dp_rx_mon_deliver(struct ath11k *ar, u32 mac_id,
 		} else {
 			rxs->flag |= RX_FLAG_ALLOW_SAME_PN;
 		}
+		rxs->flag |= RX_FLAG_ONLY_MONITOR;
 		ath11k_update_radiotap(ar, ppduinfo, mon_skb, rxs);
 
 		ath11k_dp_rx_deliver_msdu(ar, napi, mon_skb, rxs);
-- 
2.39.2



