Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29915497220
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbiAWO2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:28:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38620 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236742AbiAWO2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:28:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1491F60C79
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D5CC340E2;
        Sun, 23 Jan 2022 14:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642948097;
        bh=oRREflgtcKAqIFgrDLgSCyRB8UBUvCBLxNPdpqW0uGY=;
        h=Subject:To:Cc:From:Date:From;
        b=RUEFUlroWUv6y32+MFhph+tgW7XDXA43l+aSguxHq6Rz23LjJd7yAUSM98EH9Xhtp
         abiOqjBfpeFQp+VKDXDw8rRDXJ5uet1EZGwG+NAVLxT7YokdHPldwY10X6/nEidA3F
         n9ZkeB9jIl3Ae5bXe6CCp/IpdeKxLh3vfNoQUTy4=
Subject: FAILED: patch "[PATCH] virtio/virtio_mem: handle a possible NULL as a memcpy" failed to apply to 5.10-stable tree
To:     flyingpenghao@gmail.com, flyingpeng@tencent.com, mst@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:28:14 +0100
Message-ID: <164294809413620@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cf4a4493ff70874f8af26d75d4346c591c298e89 Mon Sep 17 00:00:00 2001
From: Peng Hao <flyingpenghao@gmail.com>
Date: Wed, 22 Dec 2021 09:12:25 +0800
Subject: [PATCH] virtio/virtio_mem: handle a possible NULL as a memcpy
 parameter

There is a check for vm->sbm.sb_states before, and it should check
it here as well.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
Link: https://lore.kernel.org/r/20211222011225.40573-1-flyingpeng@tencent.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: 5f1f79bbc9e2 ("virtio-mem: Paravirtualized memory hotplug")
Cc: stable@vger.kernel.org # v5.8+

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index a6a78685cfbe..38becd8d578c 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -593,7 +593,7 @@ static int virtio_mem_sbm_sb_states_prepare_next_mb(struct virtio_mem *vm)
 		return -ENOMEM;
 
 	mutex_lock(&vm->hotplug_mutex);
-	if (new_bitmap)
+	if (vm->sbm.sb_states)
 		memcpy(new_bitmap, vm->sbm.sb_states, old_pages * PAGE_SIZE);
 
 	old_bitmap = vm->sbm.sb_states;

