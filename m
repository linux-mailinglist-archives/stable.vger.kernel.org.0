Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0AF344111
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbhCVMaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230495AbhCVMaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B5FC61990;
        Mon, 22 Mar 2021 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416212;
        bh=INZn+spgDtcSebvDoX56qZXki7UYzQVzAWBrBqmE8ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q/8nZAx6L6nCuiNOqCnULMJwvZVg64vk9JTERSPIjG5NWE8SmQoKVCWImKaUL2Ttu
         RXk8kzG8RucX5d+dc8uVwQSwstezH0C8uLpWbhBSpxRsT0R4iwr7UwWVOSQFbq0i7M
         1vThKgekHdlRZaSDo6DeFVqdjgVuxU7607TimlBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, lingshan.zhu@intel.com,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5.11 021/120] vhost-vdpa: fix use-after-free of v->config_ctx
Date:   Mon, 22 Mar 2021 13:26:44 +0100
Message-Id: <20210322121930.373280190@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefano Garzarella <sgarzare@redhat.com>

commit f6bbf0010ba004f5e90c7aefdebc0ee4bd3283b9 upstream.

When the 'v->config_ctx' eventfd_ctx reference is released we didn't
set it to NULL. So if the same character device (e.g. /dev/vhost-vdpa-0)
is re-opened, the 'v->config_ctx' is invalid and calling again
vhost_vdpa_config_put() causes use-after-free issues like the
following refcount_t underflow:

    refcount_t: underflow; use-after-free.
    WARNING: CPU: 2 PID: 872 at lib/refcount.c:28 refcount_warn_saturate+0xae/0xf0
    RIP: 0010:refcount_warn_saturate+0xae/0xf0
    Call Trace:
     eventfd_ctx_put+0x5b/0x70
     vhost_vdpa_release+0xcd/0x150 [vhost_vdpa]
     __fput+0x8e/0x240
     ____fput+0xe/0x10
     task_work_run+0x66/0xa0
     exit_to_user_mode_prepare+0x118/0x120
     syscall_exit_to_user_mode+0x21/0x50
     ? __x64_sys_close+0x12/0x40
     do_syscall_64+0x45/0x50
     entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")
Cc: lingshan.zhu@intel.com
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20210311135257.109460-2-sgarzare@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Zhu Lingshan <lingshan.zhu@intel.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vdpa.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -308,8 +308,10 @@ static long vhost_vdpa_get_vring_num(str
 
 static void vhost_vdpa_config_put(struct vhost_vdpa *v)
 {
-	if (v->config_ctx)
+	if (v->config_ctx) {
 		eventfd_ctx_put(v->config_ctx);
+		v->config_ctx = NULL;
+	}
 }
 
 static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)


