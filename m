Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12F4378551
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235108AbhEJLAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234094AbhEJKzw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B6836162F;
        Mon, 10 May 2021 10:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643428;
        bh=e5Txl+1zqtYFWgxFlUuai+DrMzmZGEbycvdoUp51PyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b05REMv9hivTg2XFcxMtnQF9OJ1rhX3NitjWl85Au0E9IJ4s46fjMdbBiMhosXm6q
         pwrSkK2jwMEtWAO3056RbvJuAuVGs38I1whTulcS/clI4ym+zMBlZcQydc7xMBwsVG
         spYp71rfulqj8CVoEDysUc9TRq9J+illvwzT8lbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.11 012/342] vhost-vdpa: fix vm_flags for virtqueue doorbell mapping
Date:   Mon, 10 May 2021 12:16:42 +0200
Message-Id: <20210510102010.510047610@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

commit 3a3e0fad16d40a2aa68ddf7eea4acdf48b22dd44 upstream.

The virtqueue doorbell is usually implemented via registeres but we
don't provide the necessary vma->flags like VM_PFNMAP. This may cause
several issues e.g when userspace tries to map the doorbell via vhost
IOTLB, kernel may panic due to the page is not backed by page
structure. This patch fixes this by setting the necessary
vm_flags. With this patch, try to map doorbell via IOTLB will fail
with bad address.

Cc: stable@vger.kernel.org
Fixes: ddd89d0a059d ("vhost_vdpa: support doorbell mapping via mmap")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Link: https://lore.kernel.org/r/20210413091557.29008-1-jasowang@redhat.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vdpa.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -993,6 +993,7 @@ static int vhost_vdpa_mmap(struct file *
 	if (vma->vm_end - vma->vm_start != notify.size)
 		return -ENOTSUPP;
 
+	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
 	vma->vm_ops = &vhost_vdpa_vm_ops;
 	return 0;
 }


