Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90DC36214A3
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiKHODd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbiKHODc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:03:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E387F214
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:03:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FE3A60025
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B84BC433C1;
        Tue,  8 Nov 2022 14:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916209;
        bh=w/gC/6zUY8iapEMXE+KpxAfAgiK1L2ZnV/zOgyoOhIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2hc8AOjWxKkeqFLx7KZo0YxzghhHdZbVOQRjqbYXaDWh73L7NAyk66XfT4fyiJzd
         DjiQcKikVoo8sXkLg0FA5HsMKRWELhoyVXEZkYqhoBTxa/2o+RO3si+g2m61/opcVd
         QaixoWD82FGgduhuV15/9jkg8xDCt020pnEpn0kw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Zhongjin <chenzhongjin@huawei.com>,
        Jean Delvare <jdelvare@suse.de>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/144] i2c: piix4: Fix adapter not be removed in piix4_remove()
Date:   Tue,  8 Nov 2022 14:39:32 +0100
Message-Id: <20221108133349.280942714@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 569bea74c94d37785682b11bab76f557520477cd ]

In piix4_probe(), the piix4 adapter will be registered in:

   piix4_probe()
     piix4_add_adapters_sb800() / piix4_add_adapter()
       i2c_add_adapter()

Based on the probed device type, piix4_add_adapters_sb800() or single
piix4_add_adapter() will be called.
For the former case, piix4_adapter_count is set as the number of adapters,
while for antoher case it is not set and kept default *zero*.

When piix4 is removed, piix4_remove() removes the adapters added in
piix4_probe(), basing on the piix4_adapter_count value.
Because the count is zero for the single adapter case, the adapter won't
be removed and makes the sources allocated for adapter leaked, such as
the i2c client and device.

These sources can still be accessed by i2c or bus and cause problems.
An easily reproduced case is that if a new adapter is registered, i2c
will get the leaked adapter and try to call smbus_algorithm, which was
already freed:

Triggered by: rmmod i2c_piix4 && modprobe max31730

 BUG: unable to handle page fault for address: ffffffffc053d860
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 Oops: 0000 [#1] PREEMPT SMP KASAN
 CPU: 0 PID: 3752 Comm: modprobe Tainted: G
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
 RIP: 0010:i2c_default_probe (drivers/i2c/i2c-core-base.c:2259) i2c_core
 RSP: 0018:ffff888107477710 EFLAGS: 00000246
 ...
 <TASK>
  i2c_detect (drivers/i2c/i2c-core-base.c:2302) i2c_core
  __process_new_driver (drivers/i2c/i2c-core-base.c:1336) i2c_core
  bus_for_each_dev (drivers/base/bus.c:301)
  i2c_for_each_dev (drivers/i2c/i2c-core-base.c:1823) i2c_core
  i2c_register_driver (drivers/i2c/i2c-core-base.c:1861) i2c_core
  do_one_initcall (init/main.c:1296)
  do_init_module (kernel/module/main.c:2455)
  ...
 </TASK>
 ---[ end trace 0000000000000000 ]---

Fix this problem by correctly set piix4_adapter_count as 1 for the
single adapter so it can be normally removed.

Fixes: 528d53a1592b ("i2c: piix4: Fix probing of reserved ports on AMD Family 16h Model 30h")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-piix4.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
index 39cb1b7bb865..809fbd014cd6 100644
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -1080,6 +1080,7 @@ static int piix4_probe(struct pci_dev *dev, const struct pci_device_id *id)
 					   "", &piix4_main_adapters[0]);
 		if (retval < 0)
 			return retval;
+		piix4_adapter_count = 1;
 	}
 
 	/* Check for auxiliary SMBus on some AMD chipsets */
-- 
2.35.1



