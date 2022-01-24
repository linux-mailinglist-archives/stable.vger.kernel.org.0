Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AD6499623
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348488AbiAXU7Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:59:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51914 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443036AbiAXU4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:56:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 893E0B810A8;
        Mon, 24 Jan 2022 20:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54BEC340E5;
        Mon, 24 Jan 2022 20:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057767;
        bh=d8KuQaMMEpwfYk41SbyDZxgaCrp6MyVMmi879u70yiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+G1ba2FVRaqCyOx4Nizi4mIacyXnMCR8I1hd8PlpxaY1K5KwSEiVAWmnesqVHARY
         n7dv4d1QkzLYytpq2NlUQqtr3YMOyQNGNem/E6PI9QBXCMsks3Eow1ws1S9k7WXnUr
         voV3JAIuaeojuigjB6vrJ+uFerkvLYxGZP7eVzmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Hao <flyingpeng@tencent.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.16 0072/1039] virtio/virtio_mem: handle a possible NULL as a memcpy parameter
Date:   Mon, 24 Jan 2022 19:31:01 +0100
Message-Id: <20220124184127.597119023@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -592,7 +592,7 @@ static int virtio_mem_sbm_sb_states_prep
 		return -ENOMEM;
 
 	mutex_lock(&vm->hotplug_mutex);
-	if (new_bitmap)
+	if (vm->sbm.sb_states)
 		memcpy(new_bitmap, vm->sbm.sb_states, old_pages * PAGE_SIZE);
 
 	old_bitmap = vm->sbm.sb_states;


