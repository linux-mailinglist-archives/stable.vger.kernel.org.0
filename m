Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678AA61585F
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbiKBCut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiKBCus (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:50:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B21209AB
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:50:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69051B82077
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E789C433D7;
        Wed,  2 Nov 2022 02:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357443;
        bh=4eSBhS12RcSUcl5NUR+lxde6sdmB/rvVU10dslYrZO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W81yJnGJztpksspVDe41B3esod3DTtswUU1FcKXG+dPdI7OiPivYVq83y+mqAwFMr
         FGaJl6DSyJpRNxFFGUOkmB+2h2/bzyvOJVvhfl8zr5T9DtZsQbLXTx/lDrGJ74x5v/
         7ZwbmPGEpq39z7bKe7K9hGmDzI4R5MGg7B7UElwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 170/240] nfc: virtual_ncidev: Fix memory leak in virtual_nci_send()
Date:   Wed,  2 Nov 2022 03:32:25 +0100
Message-Id: <20221102022115.229766489@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit e840d8f4a1b323973052a1af5ad4edafcde8ae3d ]

skb should be free in virtual_nci_send(), otherwise kmemleak will report
memleak.

Steps for reproduction (simulated in qemu):
	cd tools/testing/selftests/nci
	make
	./nci_dev

BUG: memory leak
unreferenced object 0xffff888107588000 (size 208):
  comm "nci_dev", pid 206, jiffies 4294945376 (age 368.248s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000008d94c8fd>] __alloc_skb+0x1da/0x290
    [<00000000278bc7f8>] nci_send_cmd+0xa3/0x350
    [<0000000081256a22>] nci_reset_req+0x6b/0xa0
    [<000000009e721112>] __nci_request+0x90/0x250
    [<000000005d556e59>] nci_dev_up+0x217/0x5b0
    [<00000000e618ce62>] nfc_dev_up+0x114/0x220
    [<00000000981e226b>] nfc_genl_dev_up+0x94/0xe0
    [<000000009bb03517>] genl_family_rcv_msg_doit.isra.14+0x228/0x2d0
    [<00000000b7f8c101>] genl_rcv_msg+0x35c/0x640
    [<00000000c94075ff>] netlink_rcv_skb+0x11e/0x350
    [<00000000440cfb1e>] genl_rcv+0x24/0x40
    [<0000000062593b40>] netlink_unicast+0x43f/0x640
    [<000000001d0b13cc>] netlink_sendmsg+0x73a/0xbf0
    [<000000003272487f>] __sys_sendto+0x324/0x370
    [<00000000ef9f1747>] __x64_sys_sendto+0xdd/0x1b0
    [<000000001e437841>] do_syscall_64+0x3f/0x90

Fixes: e624e6c3e777 ("nfc: Add a virtual nci device driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20221020030505.15572-1-shangxiaojing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/virtual_ncidev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
index f577449e4935..85c06dbb2c44 100644
--- a/drivers/nfc/virtual_ncidev.c
+++ b/drivers/nfc/virtual_ncidev.c
@@ -54,16 +54,19 @@ static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
 	mutex_lock(&nci_mutex);
 	if (state != virtual_ncidev_enabled) {
 		mutex_unlock(&nci_mutex);
+		kfree_skb(skb);
 		return 0;
 	}
 
 	if (send_buff) {
 		mutex_unlock(&nci_mutex);
+		kfree_skb(skb);
 		return -1;
 	}
 	send_buff = skb_copy(skb, GFP_KERNEL);
 	mutex_unlock(&nci_mutex);
 	wake_up_interruptible(&wq);
+	consume_skb(skb);
 
 	return 0;
 }
-- 
2.35.1



