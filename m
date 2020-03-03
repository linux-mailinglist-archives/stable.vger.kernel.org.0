Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8CDF17809D
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732730AbgCCR5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:57:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:40390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731494AbgCCR5q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:57:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CF302072D;
        Tue,  3 Mar 2020 17:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258266;
        bh=dqrT8K5dSe7kcnOo2B8k5AI5QeDsvr7KeDs/jhUI4V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kU8AdIN8RBkKICtCPctfE5fy08Z/3cGwt0KFUfIJitjWF2hRCuWcisABvsZZ2eu8o
         th1U+6E/wBPioyHvCi8FakcMVCFEBp7fezB9GUZxk/DnlnqAGtN+obGgfyxFt51T/2
         XNIXKolWjCjEaSC905s0IVNilWzcbqpu/VHB+r74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tina Zhang <tina.zhang@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [PATCH 5.4 097/152] drm/i915/gvt: Fix orphan vgpu dmabuf_objs lifetime
Date:   Tue,  3 Mar 2020 18:43:15 +0100
Message-Id: <20200303174313.592482501@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tina Zhang <tina.zhang@intel.com>

commit b549c252b1292aea959cd9b83537fcb9384a6112 upstream.

Deleting dmabuf item's list head after releasing its container can lead
to KASAN-reported issue:

  BUG: KASAN: use-after-free in __list_del_entry_valid+0x15/0xf0
  Read of size 8 at addr ffff88818a4598a8 by task kworker/u8:3/13119

So fix this issue by puting deleting dmabuf_objs ahead of releasing its
container.

Fixes: dfb6ae4e14bd6 ("drm/i915/gvt: Handle orphan dmabuf_objs")
Signed-off-by: Tina Zhang <tina.zhang@intel.com>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200225053527.8336-2-tina.zhang@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gvt/dmabuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gvt/dmabuf.c
+++ b/drivers/gpu/drm/i915/gvt/dmabuf.c
@@ -96,12 +96,12 @@ static void dmabuf_gem_object_free(struc
 			dmabuf_obj = container_of(pos,
 					struct intel_vgpu_dmabuf_obj, list);
 			if (dmabuf_obj == obj) {
+				list_del(pos);
 				intel_gvt_hypervisor_put_vfio_device(vgpu);
 				idr_remove(&vgpu->object_idr,
 					   dmabuf_obj->dmabuf_id);
 				kfree(dmabuf_obj->info);
 				kfree(dmabuf_obj);
-				list_del(pos);
 				break;
 			}
 		}


