Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C515635597
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237408AbiKWJSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237411AbiKWJSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:18:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CA11C910
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:17:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E64661B4C
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796C6C433C1;
        Wed, 23 Nov 2022 09:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195066;
        bh=jdepuo9T4awDM7oIK5MRYrYymrclLBoyMtuB7F+7Lyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEPYeF+bItYpgtmM/pLs/01xYADi2zNzDZYgKFkMbfenJQC9mbT4HOiwJsG+vtUR+
         fzLNJVBBAwBfxrPl/aTFAJP//3UmJLGEIKu5sLA7UZSioBZkISrOpQjzZ4UbEE1dBR
         Lt4MfGghpHXt2NRoPJEDU7dMBKDCpgl4KN9fTZRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+39be4da489ed2493ba25@syzkaller.appspotmail.com,
        stable <stable@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Vishnu Dasa <vdasa@vmware.com>
Subject: [PATCH 5.4 138/156] misc/vmw_vmci: fix an infoleak in vmci_host_do_receive_datagram()
Date:   Wed, 23 Nov 2022 09:51:35 +0100
Message-Id: <20221123084602.895955049@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

From: Alexander Potapenko <glider@google.com>

commit e5b0d06d9b10f5f43101bd6598b076c347f9295f upstream.

`struct vmci_event_qp` allocated by qp_notify_peer() contains padding,
which may carry uninitialized data to the userspace, as observed by
KMSAN:

  BUG: KMSAN: kernel-infoleak in instrument_copy_to_user ./include/linux/instrumented.h:121
   instrument_copy_to_user ./include/linux/instrumented.h:121
   _copy_to_user+0x5f/0xb0 lib/usercopy.c:33
   copy_to_user ./include/linux/uaccess.h:169
   vmci_host_do_receive_datagram drivers/misc/vmw_vmci/vmci_host.c:431
   vmci_host_unlocked_ioctl+0x33d/0x43d0 drivers/misc/vmw_vmci/vmci_host.c:925
   vfs_ioctl fs/ioctl.c:51
  ...

  Uninit was stored to memory at:
   kmemdup+0x74/0xb0 mm/util.c:131
   dg_dispatch_as_host drivers/misc/vmw_vmci/vmci_datagram.c:271
   vmci_datagram_dispatch+0x4f8/0xfc0 drivers/misc/vmw_vmci/vmci_datagram.c:339
   qp_notify_peer+0x19a/0x290 drivers/misc/vmw_vmci/vmci_queue_pair.c:1479
   qp_broker_attach drivers/misc/vmw_vmci/vmci_queue_pair.c:1662
   qp_broker_alloc+0x2977/0x2f30 drivers/misc/vmw_vmci/vmci_queue_pair.c:1750
   vmci_qp_broker_alloc+0x96/0xd0 drivers/misc/vmw_vmci/vmci_queue_pair.c:1940
   vmci_host_do_alloc_queuepair drivers/misc/vmw_vmci/vmci_host.c:488
   vmci_host_unlocked_ioctl+0x24fd/0x43d0 drivers/misc/vmw_vmci/vmci_host.c:927
  ...

  Local variable ev created at:
   qp_notify_peer+0x54/0x290 drivers/misc/vmw_vmci/vmci_queue_pair.c:1456
   qp_broker_attach drivers/misc/vmw_vmci/vmci_queue_pair.c:1662
   qp_broker_alloc+0x2977/0x2f30 drivers/misc/vmw_vmci/vmci_queue_pair.c:1750

  Bytes 28-31 of 48 are uninitialized
  Memory access of size 48 starts at ffff888035155e00
  Data copied to user address 0000000020000100

Use memset() to prevent the infoleaks.

Also speculatively fix qp_notify_peer_local(), which may suffer from the
same problem.

Reported-by: syzbot+39be4da489ed2493ba25@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Fixes: 06164d2b72aa ("VMCI: queue pairs implementation.")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
Link: https://lore.kernel.org/r/20221104175849.2782567-1-glider@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/vmw_vmci/vmci_queue_pair.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -852,6 +852,7 @@ static int qp_notify_peer_local(bool att
 	u32 context_id = vmci_get_context_id();
 	struct vmci_event_qp ev;
 
+	memset(&ev, 0, sizeof(ev));
 	ev.msg.hdr.dst = vmci_make_handle(context_id, VMCI_EVENT_HANDLER);
 	ev.msg.hdr.src = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
 					  VMCI_CONTEXT_RESOURCE_ID);
@@ -1465,6 +1466,7 @@ static int qp_notify_peer(bool attach,
 	 * kernel.
 	 */
 
+	memset(&ev, 0, sizeof(ev));
 	ev.msg.hdr.dst = vmci_make_handle(peer_id, VMCI_EVENT_HANDLER);
 	ev.msg.hdr.src = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
 					  VMCI_CONTEXT_RESOURCE_ID);


