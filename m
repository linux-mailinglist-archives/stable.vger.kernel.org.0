Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBDA608B4B
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiJVKK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiJVKKj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:10:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAA530F9DB;
        Sat, 22 Oct 2022 02:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34D06B82E24;
        Sat, 22 Oct 2022 07:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B31AC433C1;
        Sat, 22 Oct 2022 07:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424719;
        bh=Vozqve6uz0M1YkzgDdcf8XEiQm+jmQXPx46GgpjETVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AtRqtR+f9jN3C1CFjU5BJFgyqBKq0PhnvIvrAjSagNaMPUiFTyg6iOPnOPJylrfaL
         iW7W1IbXsMU+qH+XCpZ1mfKgiqlypaDSz8cf8unxiJtfUUt+UtyjJRQFntyiB6IqbV
         1C8Bwp23hOj5DZAY7/rqmNEei+G4tBbAwyT78RD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Deren Wu <deren.wu@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 250/717] wifi: mt76: mt7921e: fix rmmod crash in driver reload test
Date:   Sat, 22 Oct 2022 09:22:09 +0200
Message-Id: <20221022072459.104520548@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit b5a62d612b7baf6e09884e4de94decb6391d6a9d ]

In insmod/rmmod stress test, the following crash dump shows up immediately.
The problem is caused by missing mt76_dev in mt7921_pci_remove(). We
should make sure the drvdata is ready before probe() finished.

[168.862789] ==================================================================
[168.862797] BUG: KASAN: user-memory-access in try_to_grab_pending+0x59/0x480
[168.862805] Write of size 8 at addr 0000000000006df0 by task rmmod/5361
[168.862812] CPU: 7 PID: 5361 Comm: rmmod Tainted: G           OE     5.19.0-rc6 #1
[168.862816] Hardware name: Intel(R) Client Systems NUC8i7BEH/NUC8BEB, 05/04/2020
[168.862820] Call Trace:
[168.862822]  <TASK>
[168.862825]  dump_stack_lvl+0x49/0x63
[168.862832]  print_report.cold+0x493/0x6b7
[168.862845]  kasan_report+0xa7/0x120
[168.862857]  kasan_check_range+0x163/0x200
[168.862861]  __kasan_check_write+0x14/0x20
[168.862866]  try_to_grab_pending+0x59/0x480
[168.862870]  __cancel_work_timer+0xbb/0x340
[168.862898]  cancel_work_sync+0x10/0x20
[168.862902]  mt7921_pci_remove+0x61/0x1c0 [mt7921e]
[168.862909]  pci_device_remove+0xa3/0x1d0
[168.862914]  device_remove+0xc4/0x170
[168.862920]  device_release_driver_internal+0x163/0x300
[168.862925]  driver_detach+0xc7/0x1a0
[168.862930]  bus_remove_driver+0xeb/0x2d0
[168.862935]  driver_unregister+0x71/0xb0
[168.862939]  pci_unregister_driver+0x30/0x230
[168.862944]  mt7921_pci_driver_exit+0x10/0x1b [mt7921e]
[168.862949]  __x64_sys_delete_module+0x2f9/0x4b0
[168.862968]  do_syscall_64+0x38/0x90
[168.862973]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Test steps:
1. insmode
2. do not ifup
3. rmmod quickly (within 1 second)

Fixes: 1c71e03afe4b ("mt76: mt7921: move mt7921_init_hw in a dedicated work")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 295c21586273..d8347b33641e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -289,6 +289,8 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 		goto err_free_pci_vec;
 	}
 
+	pci_set_drvdata(pdev, mdev);
+
 	dev = container_of(mdev, struct mt7921_dev, mt76);
 	dev->hif_ops = &mt7921_pcie_ops;
 
-- 
2.35.1



