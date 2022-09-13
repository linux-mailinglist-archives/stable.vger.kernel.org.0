Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344A15B6F3B
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbiIMOJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbiIMOIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:08:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DECF1C127;
        Tue, 13 Sep 2022 07:08:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 548CDB80EFB;
        Tue, 13 Sep 2022 14:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28C4C433D6;
        Tue, 13 Sep 2022 14:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078102;
        bh=6XLVkgbhH9LiAzia+LeGYpu4iOK1WJoj3fX3+guZWwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qluVKl4iCfQkb1knqK8kkWqlNuKpegRSdyosMDkkciqUYBDJ5GsxvP/XvUzs7ZlQn
         qqmh9RINrORDas84fZGObBG6sGmjQEFo2rg7K/dIeV3AsREvKyY6CMD0wGs96zbcq9
         LqwF2P4l1c7k53D1OQblvlbq6n/0iz8MI1e72PGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deren Wu <deren.wu@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.19 003/192] wifi: mt76: mt7921e: fix crash in chip reset fail
Date:   Tue, 13 Sep 2022 16:01:49 +0200
Message-Id: <20220913140410.191607524@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Deren Wu <deren.wu@mediatek.com>

commit fa3fbe64037839f448dc569212bafc5a495d8219 upstream.

In case of drv own fail in reset, we may need to run mac_reset several
times. The sequence would trigger system crash as the log below.

Because we do not re-enable/schedule "tx_napi" before disable it again,
the process would keep waiting for state change in napi_diable(). To
avoid the problem and keep status synchronize for each run, goto final
resource handling if drv own failed.

[ 5857.353423] mt7921e 0000:3b:00.0: driver own failed
[ 5858.433427] mt7921e 0000:3b:00.0: Timeout for driver own
[ 5859.633430] mt7921e 0000:3b:00.0: driver own failed
[ 5859.633444] ------------[ cut here ]------------
[ 5859.633446] WARNING: CPU: 6 at kernel/kthread.c:659 kthread_park+0x11d
[ 5859.633717] Workqueue: mt76 mt7921_mac_reset_work [mt7921_common]
[ 5859.633728] RIP: 0010:kthread_park+0x11d/0x150
[ 5859.633736] RSP: 0018:ffff8881b676fc68 EFLAGS: 00010202
......
[ 5859.633766] Call Trace:
[ 5859.633768]  <TASK>
[ 5859.633771]  mt7921e_mac_reset+0x176/0x6f0 [mt7921e]
[ 5859.633778]  mt7921_mac_reset_work+0x184/0x3a0 [mt7921_common]
[ 5859.633785]  ? mt7921_mac_set_timing+0x520/0x520 [mt7921_common]
[ 5859.633794]  ? __kasan_check_read+0x11/0x20
[ 5859.633802]  process_one_work+0x7ee/0x1320
[ 5859.633810]  worker_thread+0x53c/0x1240
[ 5859.633818]  kthread+0x2b8/0x370
[ 5859.633824]  ? process_one_work+0x1320/0x1320
[ 5859.633828]  ? kthread_complete_and_exit+0x30/0x30
[ 5859.633834]  ret_from_fork+0x1f/0x30
[ 5859.633842]  </TASK>

Cc: stable@vger.kernel.org
Fixes: 0efaf31dec57 ("mt76: mt7921: fix MT7921E reset failure")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Link: https://lore.kernel.org/r/727eb5ffd3c7c805245e512da150ecf0a7154020.1659452909.git.deren.wu@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
@@ -345,7 +345,7 @@ int mt7921e_mac_reset(struct mt7921_dev
 
 	err = mt7921e_driver_own(dev);
 	if (err)
-		return err;
+		goto out;
 
 	err = mt7921_run_firmware(dev);
 	if (err)


