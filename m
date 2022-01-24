Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C3949922C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348812AbiAXURv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:17:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37336 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346307AbiAXUNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:13:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8465E6090A;
        Mon, 24 Jan 2022 20:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E94C340E5;
        Mon, 24 Jan 2022 20:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055180;
        bh=uwnNQ8+gL5Px1mLCB6XCmWKrCo2atGyRJwY5yIi3pNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOcWqydEh41D9gsjhpp7s/kylf/Mmbb9hh4fWSXVwKQK3swa4reJf97B/kB33IMU/
         s96sIHCf3aLGIMuUa5gR2qG3eTghciHs0fKAZqgBgDWMwkCzPXuGtQSMiOE11+wDkE
         ZAUYEjBG/iLTM3pYnmVOkU3EolqnioRJgVMcu2nM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Hao <flyingpeng@tencent.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.15 067/846] virtio/virtio_mem: handle a possible NULL as a memcpy parameter
Date:   Mon, 24 Jan 2022 19:33:04 +0100
Message-Id: <20220124184103.280002812@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Hao <flyingpenghao@gmail.com>

commit cf4a4493ff70874f8af26d75d4346c591c298e89 upstream.

There is a check for vm->sbm.sb_states before, and it should check
it here as well.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
Link: https://lore.kernel.org/r/20211222011225.40573-1-flyingpeng@tencent.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: 5f1f79bbc9e2 ("virtio-mem: Paravirtualized memory hotplug")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio_mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -577,7 +577,7 @@ static int virtio_mem_sbm_sb_states_prep
 		return -ENOMEM;
 
 	mutex_lock(&vm->hotplug_mutex);
-	if (new_bitmap)
+	if (vm->sbm.sb_states)
 		memcpy(new_bitmap, vm->sbm.sb_states, old_pages * PAGE_SIZE);
 
 	old_bitmap = vm->sbm.sb_states;


