Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F265010CF
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348316AbiDNOER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346558AbiDNN5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:57:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9E3B0A4A;
        Thu, 14 Apr 2022 06:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D905612E6;
        Thu, 14 Apr 2022 13:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A6DC385A5;
        Thu, 14 Apr 2022 13:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944045;
        bh=IID6F9Ke4JqC9L6vJlF0luQUGFuNBiHgFrpgIgXi2P0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BHGkCIyOx+gQrHJ+W3W+o/TP1QLD7dLQMpdp6SRodRSSECnKoRH9CXYh1JeaRjvrM
         1vmfU6eoRFEqxCy9WyeNh85TpRtCLoiJJoYsgSrDkkZJ7TzTZfY4B4L6D2Zg7sMOfR
         J7bdl0jDvZL0h0uGZwKB48vx5/7XUds030ySnCVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brendan Dolan-Gavitt <brendandg@nyu.edu>,
        Zekun Shen <bruceshenzk@gmail.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 374/475] ath5k: fix OOB in ath5k_eeprom_read_pcal_info_5111
Date:   Thu, 14 Apr 2022 15:12:39 +0200
Message-Id: <20220414110905.542454280@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zekun Shen <bruceshenzk@gmail.com>

[ Upstream commit 564d4eceb97eaf381dd6ef6470b06377bb50c95a ]

The bug was found during fuzzing. Stacktrace locates it in
ath5k_eeprom_convert_pcal_info_5111.
When none of the curve is selected in the loop, idx can go
up to AR5K_EEPROM_N_PD_CURVES. The line makes pd out of bound.
pd = &chinfo[pier].pd_curves[idx];

There are many OOB writes using pd later in the code. So I
added a sanity check for idx. Checks for other loops involving
AR5K_EEPROM_N_PD_CURVES are not needed as the loop index is not
used outside the loops.

The patch is NOT tested with real device.

The following is the fuzzing report

BUG: KASAN: slab-out-of-bounds in ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
Write of size 1 at addr ffff8880174a4d60 by task modprobe/214

CPU: 0 PID: 214 Comm: modprobe Not tainted 5.6.0 #1
Call Trace:
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
 ? ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
 __kasan_report.cold+0x37/0x7c
 ? ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
 kasan_report+0xe/0x20
 ath5k_eeprom_read_pcal_info_5111+0x126a/0x1390 [ath5k]
 ? apic_timer_interrupt+0xa/0x20
 ? ath5k_eeprom_init_11a_pcal_freq+0xbc0/0xbc0 [ath5k]
 ? ath5k_pci_eeprom_read+0x228/0x3c0 [ath5k]
 ath5k_eeprom_init+0x2513/0x6290 [ath5k]
 ? ath5k_eeprom_init_11a_pcal_freq+0xbc0/0xbc0 [ath5k]
 ? usleep_range+0xb8/0x100
 ? apic_timer_interrupt+0xa/0x20
 ? ath5k_eeprom_read_pcal_info_2413+0x2f20/0x2f20 [ath5k]
 ath5k_hw_init+0xb60/0x1970 [ath5k]
 ath5k_init_ah+0x6fe/0x2530 [ath5k]
 ? kasprintf+0xa6/0xe0
 ? ath5k_stop+0x140/0x140 [ath5k]
 ? _dev_notice+0xf6/0xf6
 ? apic_timer_interrupt+0xa/0x20
 ath5k_pci_probe.cold+0x29a/0x3d6 [ath5k]
 ? ath5k_pci_eeprom_read+0x3c0/0x3c0 [ath5k]
 ? mutex_lock+0x89/0xd0
 ? ath5k_pci_eeprom_read+0x3c0/0x3c0 [ath5k]
 local_pci_probe+0xd3/0x160
 pci_device_probe+0x23f/0x3e0
 ? pci_device_remove+0x280/0x280
 ? pci_device_remove+0x280/0x280
 really_probe+0x209/0x5d0

Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/YckvDdj3mtCkDRIt@a-10-27-26-18.dynapool.vpn.nyu.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath5k/eeprom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 94d34ee02265..01163b333945 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -746,6 +746,9 @@ ath5k_eeprom_convert_pcal_info_5111(struct ath5k_hw *ah, int mode,
 			}
 		}
 
+		if (idx == AR5K_EEPROM_N_PD_CURVES)
+			goto err_out;
+
 		ee->ee_pd_gains[mode] = 1;
 
 		pd = &chinfo[pier].pd_curves[idx];
-- 
2.35.1



