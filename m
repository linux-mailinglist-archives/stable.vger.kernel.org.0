Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B449F593CB8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbiHOURg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347042AbiHOUQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:16:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C977896FE4;
        Mon, 15 Aug 2022 12:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF86DB8110A;
        Mon, 15 Aug 2022 19:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361FDC433D6;
        Mon, 15 Aug 2022 19:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590010;
        bh=0LWknksfOpS8e6YkW3M3ixXPi6jwfA7UCN/Od+f5rkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LW4WNO0JqQg4GqzQ3/TODac2zUDzjipazqWdK0XkebA5kPWxID4+gST7+z5wj+SXc
         cZ5C3aNSBL31pjamMn3eAJ6gIBRN1uJyV20X0Y/yCrwbUwQB3/4DBsi+tKJSqPyI2s
         LcFoPnoEiqeH7AcIsf0cEtXBc9iaq8YM2RkrXbRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.18 0121/1095] coresight: Clear the connection field properly
Date:   Mon, 15 Aug 2022 19:52:00 +0200
Message-Id: <20220815180434.591880012@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 2af89ebacf299b7fba5f3087d35e8a286ec33706 upstream.

coresight devices track their connections (output connections) and
hold a reference to the fwnode. When a device goes away, we walk through
the devices on the coresight bus and make sure that the references
are dropped. This happens both ways:
 a) For all output connections from the device, drop the reference to
    the target device via coresight_release_platform_data()

b) Iterate over all the devices on the coresight bus and drop the
   reference to fwnode if *this* device is the target of the output
   connection, via coresight_remove_conns()->coresight_remove_match().

However, the coresight_remove_match() doesn't clear the fwnode field,
after dropping the reference, this causes use-after-free and
additional refcount drops on the fwnode.

e.g., if we have two devices, A and B, with a connection, A -> B.
If we remove B first, B would clear the reference on B, from A
via coresight_remove_match(). But when A is removed, it still has
a connection with fwnode still pointing to B. Thus it tries to  drops
the reference in coresight_release_platform_data(), raising the bells
like :

[   91.990153] ------------[ cut here ]------------
[   91.990163] refcount_t: addition on 0; use-after-free.
[   91.990212] WARNING: CPU: 0 PID: 461 at lib/refcount.c:25 refcount_warn_saturate+0xa0/0x144
[   91.990260] Modules linked in: coresight_funnel coresight_replicator coresight_etm4x(-)
 crct10dif_ce coresight ip_tables x_tables ipv6 [last unloaded: coresight_cpu_debug]
[   91.990398] CPU: 0 PID: 461 Comm: rmmod Tainted: G        W       T 5.19.0-rc2+ #53
[   91.990418] Hardware name: ARM LTD ARM Juno Development Platform/ARM Juno Development Platform, BIOS EDK II Feb  1 2019
[   91.990434] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   91.990454] pc : refcount_warn_saturate+0xa0/0x144
[   91.990476] lr : refcount_warn_saturate+0xa0/0x144
[   91.990496] sp : ffff80000c843640
[   91.990509] x29: ffff80000c843640 x28: ffff800009957c28 x27: ffff80000c8439a8
[   91.990560] x26: ffff00097eff1990 x25: ffff8000092b6ad8 x24: ffff00097eff19a8
[   91.990610] x23: ffff80000c8439a8 x22: 0000000000000000 x21: ffff80000c8439c2
[   91.990659] x20: 0000000000000000 x19: ffff00097eff1a10 x18: ffff80000ab99c40
[   91.990708] x17: 0000000000000000 x16: 0000000000000000 x15: ffff80000abf6fa0
[   91.990756] x14: 000000000000001d x13: 0a2e656572662d72 x12: 657466612d657375
[   91.990805] x11: 203b30206e6f206e x10: 6f69746964646120 x9 : ffff8000081aba28
[   91.990854] x8 : 206e6f206e6f6974 x7 : 69646461203a745f x6 : 746e756f63666572
[   91.990903] x5 : ffff00097648ec58 x4 : 0000000000000000 x3 : 0000000000000027
[   91.990952] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff00080260ba00
[   91.991000] Call trace:
[   91.991012]  refcount_warn_saturate+0xa0/0x144
[   91.991034]  kobject_get+0xac/0xb0
[   91.991055]  of_node_get+0x2c/0x40
[   91.991076]  of_fwnode_get+0x40/0x60
[   91.991094]  fwnode_handle_get+0x3c/0x60
[   91.991116]  fwnode_get_nth_parent+0xf4/0x110
[   91.991137]  fwnode_full_name_string+0x48/0xc0
[   91.991158]  device_node_string+0x41c/0x530
[   91.991178]  pointer+0x320/0x3ec
[   91.991198]  vsnprintf+0x23c/0x750
[   91.991217]  vprintk_store+0x104/0x4b0
[   91.991238]  vprintk_emit+0x8c/0x360
[   91.991257]  vprintk_default+0x44/0x50
[   91.991276]  vprintk+0xcc/0xf0
[   91.991295]  _printk+0x68/0x90
[   91.991315]  of_node_release+0x13c/0x14c
[   91.991334]  kobject_put+0x98/0x114
[   91.991354]  of_node_put+0x24/0x34
[   91.991372]  of_fwnode_put+0x40/0x5c
[   91.991390]  fwnode_handle_put+0x38/0x50
[   91.991411]  coresight_release_platform_data+0x74/0xb0 [coresight]
[   91.991472]  coresight_unregister+0x64/0xcc [coresight]
[   91.991525]  etm4_remove_dev+0x64/0x78 [coresight_etm4x]
[   91.991563]  etm4_remove_amba+0x1c/0x2c [coresight_etm4x]
[   91.991598]  amba_remove+0x3c/0x19c

Reproducible by: (Build all coresight components as modules):

  #!/bin/sh
  while true
  do
     for m in tmc stm cpu_debug etm4x replicator funnel
     do
     	modprobe coresight_${m}
     done

     for m in tmc stm cpu_debug etm4x replicator funnel
     do
     	rmmode coresight_${m}
     done
  done

Cc: stable@vger.kernel.org
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Fixes: 37ea1ffddffa ("coresight: Use fwnode handle instead of device names")
Link: https://lore.kernel.org/r/20220614214024.3005275-1-suzuki.poulose@arm.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -1424,6 +1424,7 @@ static int coresight_remove_match(struct
 			 * platform data.
 			 */
 			fwnode_handle_put(conn->child_fwnode);
+			conn->child_fwnode = NULL;
 			/* No need to continue */
 			break;
 		}


