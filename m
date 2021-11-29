Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E181A461F63
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379709AbhK2Sqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:46:42 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:57414 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379699AbhK2Sol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:44:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D0A62CE13BF;
        Mon, 29 Nov 2021 18:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED15C53FC7;
        Mon, 29 Nov 2021 18:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211279;
        bh=dnjeqmjEbIcxwEcmSCWY57Ld90ui8wdrpfMoXRepR2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LH8eHFBKG17ds/kB65wMj6+S1Z/jee8tf8RLvxCwAfUrL8ZHHq2pq/xBv1kBEIfap
         DkmhOR8ygFJgiAqbuXwofMXUgPqrIA8fKDVbfVJlS/H6C/2rWhMoLDfRpIpwlw3our
         VwCcCtjzPh5KV6fbpMoOHZraI2xQVocBTMJ9As1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Longpeng <longpeng2@huawei.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.15 167/179] vdpa_sim: avoid putting an uninitialized iova_domain
Date:   Mon, 29 Nov 2021 19:19:21 +0100
Message-Id: <20211129181724.428647725@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Longpeng <longpeng2@huawei.com>

commit bb93ce4b150dde79f58e34103cbd1fe829796649 upstream.

The system will crash if we put an uninitialized iova_domain, this
could happen when an error occurs before initializing the iova_domain
in vdpasim_create().

BUG: kernel NULL pointer dereference, address: 0000000000000000
...
RIP: 0010:__cpuhp_state_remove_instance+0x96/0x1c0
...
Call Trace:
 <TASK>
 put_iova_domain+0x29/0x220
 vdpasim_free+0xd1/0x120 [vdpa_sim]
 vdpa_release_dev+0x21/0x40 [vdpa]
 device_release+0x33/0x90
 kobject_release+0x63/0x160
 vdpasim_create+0x127/0x2a0 [vdpa_sim]
 vdpasim_net_dev_add+0x7d/0xfe [vdpa_sim_net]
 vdpa_nl_cmd_dev_add_set_doit+0xe1/0x1a0 [vdpa]
 genl_family_rcv_msg_doit+0x112/0x140
 genl_rcv_msg+0xdf/0x1d0
 ...

So we must make sure the iova_domain is already initialized before
put it.

In addition, we may get the following warning in this case:
WARNING: ... drivers/iommu/iova.c:344 iova_cache_put+0x58/0x70

So we must make sure the iova_cache_put() is invoked only if the
iova_cache_get() is already invoked. Let's fix it together.

Cc: stable@vger.kernel.org
Fixes: 4080fc106750 ("vdpa_sim: use iova module to allocate IOVA addresses")
Signed-off-by: Longpeng <longpeng2@huawei.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20211124015215.119-1-longpeng2@huawei.com
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_sim/vdpa_sim.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -591,8 +591,11 @@ static void vdpasim_free(struct vdpa_dev
 		vringh_kiov_cleanup(&vdpasim->vqs[i].in_iov);
 	}
 
-	put_iova_domain(&vdpasim->iova);
-	iova_cache_put();
+	if (vdpa_get_dma_dev(vdpa)) {
+		put_iova_domain(&vdpasim->iova);
+		iova_cache_put();
+	}
+
 	kvfree(vdpasim->buffer);
 	if (vdpasim->iommu)
 		vhost_iotlb_free(vdpasim->iommu);


