Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0A74FD8D5
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353523AbiDLHdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353676AbiDLHZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7572717D;
        Tue, 12 Apr 2022 00:03:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DB91B81B4D;
        Tue, 12 Apr 2022 07:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDAC2C385A1;
        Tue, 12 Apr 2022 07:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747014;
        bh=yFy9U19sXHN41q82kKN50sXNb/tbKR+J5nGyLCB4Wqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ROcjGT5hUlG1rckGrl9of1cGAMhOEedvXBbQKHRVkpuR4yL1I7nzU05NU8vEKQHmW
         5svCEoT9hcuVwPkNSIwrdi8eOI8X9G340OzIO6i1Dij/V09leRS4T7FIPtWu6zCE+D
         /8pjzijyNUri4mMn6YOAFkFXMUqXkFDxy5x/eiUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 213/285] scsi: mpt3sas: Fix use after free in _scsih_expander_node_remove()
Date:   Tue, 12 Apr 2022 08:31:10 +0200
Message-Id: <20220412062949.805433258@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit 87d663d40801dffc99a5ad3b0188ad3e2b4d1557 upstream.

The function mpt3sas_transport_port_remove() called in
_scsih_expander_node_remove() frees the port field of the sas_expander
structure, leading to the following use-after-free splat from KASAN when
the ioc_info() call following that function is executed (e.g. when doing
rmmod of the driver module):

[ 3479.371167] ==================================================================
[ 3479.378496] BUG: KASAN: use-after-free in _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
[ 3479.386936] Read of size 1 at addr ffff8881c037691c by task rmmod/1531
[ 3479.393524]
[ 3479.395035] CPU: 18 PID: 1531 Comm: rmmod Not tainted 5.17.0-rc8+ #1436
[ 3479.401712] Hardware name: Supermicro Super Server/H12SSL-NT, BIOS 2.1 06/02/2021
[ 3479.409263] Call Trace:
[ 3479.411743]  <TASK>
[ 3479.413875]  dump_stack_lvl+0x45/0x59
[ 3479.417582]  print_address_description.constprop.0+0x1f/0x120
[ 3479.423389]  ? _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
[ 3479.429469]  kasan_report.cold+0x83/0xdf
[ 3479.433438]  ? _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
[ 3479.439514]  _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
[ 3479.445411]  ? _raw_spin_unlock_irqrestore+0x2d/0x40
[ 3479.452032]  scsih_remove+0x525/0xc90 [mpt3sas]
[ 3479.458212]  ? mpt3sas_expander_remove+0x1d0/0x1d0 [mpt3sas]
[ 3479.465529]  ? down_write+0xde/0x150
[ 3479.470746]  ? up_write+0x14d/0x460
[ 3479.475840]  ? kernfs_find_ns+0x137/0x310
[ 3479.481438]  pci_device_remove+0x65/0x110
[ 3479.487013]  __device_release_driver+0x316/0x680
[ 3479.493180]  driver_detach+0x1ec/0x2d0
[ 3479.498499]  bus_remove_driver+0xe7/0x2d0
[ 3479.504081]  pci_unregister_driver+0x26/0x250
[ 3479.510033]  _mpt3sas_exit+0x2b/0x6cf [mpt3sas]
[ 3479.516144]  __x64_sys_delete_module+0x2fd/0x510
[ 3479.522315]  ? free_module+0xaa0/0xaa0
[ 3479.527593]  ? __cond_resched+0x1c/0x90
[ 3479.532951]  ? lockdep_hardirqs_on_prepare+0x273/0x3e0
[ 3479.539607]  ? syscall_enter_from_user_mode+0x21/0x70
[ 3479.546161]  ? trace_hardirqs_on+0x1c/0x110
[ 3479.551828]  do_syscall_64+0x35/0x80
[ 3479.556884]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 3479.563402] RIP: 0033:0x7f1fc482483b
...
[ 3479.943087] ==================================================================

Fix this by introducing the local variable port_id to store the port ID
value before executing mpt3sas_transport_port_remove(). This local variable
is then used in the call to ioc_info() instead of dereferencing the freed
port structure.

Link: https://lore.kernel.org/r/20220322055702.95276-1-damien.lemoal@opensource.wdc.com
Fixes: 7d310f241001 ("scsi: mpt3sas: Get device objects using sas_address & portID")
Cc: stable@vger.kernel.org
Acked-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11035,6 +11035,7 @@ _scsih_expander_node_remove(struct MPT3S
 {
 	struct _sas_port *mpt3sas_port, *next;
 	unsigned long flags;
+	int port_id;
 
 	/* remove sibling ports attached to this expander */
 	list_for_each_entry_safe(mpt3sas_port, next,
@@ -11055,6 +11056,8 @@ _scsih_expander_node_remove(struct MPT3S
 			    mpt3sas_port->hba_port);
 	}
 
+	port_id = sas_expander->port->port_id;
+
 	mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
 	    sas_expander->sas_address_parent, sas_expander->port);
 
@@ -11062,7 +11065,7 @@ _scsih_expander_node_remove(struct MPT3S
 	    "expander_remove: handle(0x%04x), sas_addr(0x%016llx), port:%d\n",
 	    sas_expander->handle, (unsigned long long)
 	    sas_expander->sas_address,
-	    sas_expander->port->port_id);
+	    port_id);
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	list_del(&sas_expander->list);


