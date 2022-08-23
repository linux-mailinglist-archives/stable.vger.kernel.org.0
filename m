Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A1F59DFB1
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351888AbiHWMO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351906AbiHWMO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:14:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032CC19280;
        Tue, 23 Aug 2022 02:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 910A7B81C9A;
        Tue, 23 Aug 2022 09:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E46C433C1;
        Tue, 23 Aug 2022 09:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247579;
        bh=RVt6G3W9mdbfkIy7nW8MAcnxPBPOKSh1h3YBa/FUnjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8y5P1Z5M0WD7hL0vilUQGgKT5ajRUfoeL1fIN0BRf4cyUFZh4qfCnmF9h2CIYlOz
         NzLbi/Xy0EbQIPZisJ+BLXIEek3ek4IWjU7E0Qi8z05kEIW7t1eehox8rpKGYNiNIz
         Ph7YhDcebbiwjY6l9pXzJ/qL+eBSFwo/lO1A9Vqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sergei Antonov <saproj@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 080/158] net: dsa: mv88e6060: prevent crash on an unused port
Date:   Tue, 23 Aug 2022 10:26:52 +0200
Message-Id: <20220823080049.274585314@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

From: Sergei Antonov <saproj@gmail.com>

commit 246bbf2f977ea36aaf41f5d24370fef433250728 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6060.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/dsa/mv88e6060.c
+++ b/drivers/net/dsa/mv88e6060.c
@@ -118,6 +118,9 @@ static int mv88e6060_setup_port(struct m
 	int addr = REG_PORT(p);
 	int ret;
 
+	if (dsa_is_unused_port(priv->ds, p))
+		return 0;
+
 	/* Do not force flow control, disable Ingress and Egress
 	 * Header tagging, disable VLAN tunneling, and set the port
 	 * state to Forwarding.  Additionally, if this is the CPU


