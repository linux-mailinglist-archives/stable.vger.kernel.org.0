Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C7359C01B
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 15:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiHVNFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 09:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbiHVNFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 09:05:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065CDE03F
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 06:05:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B35ECB81132
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 13:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5DCC433D6;
        Mon, 22 Aug 2022 13:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661173541;
        bh=CBWRvCsBM+K9NY7EqwNANeUEorZljIX9BP/QCTvZdRI=;
        h=Subject:To:Cc:From:Date:From;
        b=SZ4mvL56ZmAjsFNGLZ3A+wRZH8arPfTy70/LRNiaHVl07H/IPf2TqqAF2+EOJQVVn
         kw3a3Y/as1aDOGglUtkWeftDunUBeQqP7PvqgwXPSC8n2c50kqeLn38y022T46W4bc
         Y6A8o5gs3UjyK/Tr0QnmeQLlsy5Hn+ZkJ1bxH5us=
Subject: FAILED: patch "[PATCH] net: dsa: mv88e6060: prevent crash on an unused port" failed to apply to 4.19-stable tree
To:     saproj@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        olteanv@gmail.com, vivien.didelot@savoirfairelinux.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 15:05:38 +0200
Message-ID: <166117353817177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 246bbf2f977ea36aaf41f5d24370fef433250728 Mon Sep 17 00:00:00 2001
From: Sergei Antonov <saproj@gmail.com>
Date: Thu, 11 Aug 2022 10:09:39 +0300
Subject: [PATCH] net: dsa: mv88e6060: prevent crash on an unused port

If the port isn't a CPU port nor a user port, 'cpu_dp'
is a null pointer and a crash happened on dereferencing
it in mv88e6060_setup_port():

[    9.575872] Unable to handle kernel NULL pointer dereference at virtual address 00000014
...
[    9.942216]  mv88e6060_setup from dsa_register_switch+0x814/0xe84
[    9.948616]  dsa_register_switch from mdio_probe+0x2c/0x54
[    9.954433]  mdio_probe from really_probe.part.0+0x98/0x2a0
[    9.960375]  really_probe.part.0 from driver_probe_device+0x30/0x10c
[    9.967029]  driver_probe_device from __device_attach_driver+0xb8/0x13c
[    9.973946]  __device_attach_driver from bus_for_each_drv+0x90/0xe0
[    9.980509]  bus_for_each_drv from __device_attach+0x110/0x184
[    9.986632]  __device_attach from bus_probe_device+0x8c/0x94
[    9.992577]  bus_probe_device from deferred_probe_work_func+0x78/0xa8
[    9.999311]  deferred_probe_work_func from process_one_work+0x290/0x73c
[   10.006292]  process_one_work from worker_thread+0x30/0x4b8
[   10.012155]  worker_thread from kthread+0xd4/0x10c
[   10.017238]  kthread from ret_from_fork+0x14/0x3c

Fixes: 0abfd494deef ("net: dsa: use dedicated CPU port")
CC: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
CC: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sergei Antonov <saproj@gmail.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20220811070939.1717146-1-saproj@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/dsa/mv88e6060.c b/drivers/net/dsa/mv88e6060.c
index a4c6eb9a52d0..83dca9179aa0 100644
--- a/drivers/net/dsa/mv88e6060.c
+++ b/drivers/net/dsa/mv88e6060.c
@@ -118,6 +118,9 @@ static int mv88e6060_setup_port(struct mv88e6060_priv *priv, int p)
 	int addr = REG_PORT(p);
 	int ret;
 
+	if (dsa_is_unused_port(priv->ds, p))
+		return 0;
+
 	/* Do not force flow control, disable Ingress and Egress
 	 * Header tagging, disable VLAN tunneling, and set the port
 	 * state to Forwarding.  Additionally, if this is the CPU

