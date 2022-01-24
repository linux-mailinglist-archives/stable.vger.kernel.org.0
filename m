Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292E0499B45
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1574947AbiAXVut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:50:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52408 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457859AbiAXVmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:42:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAE16B811A9;
        Mon, 24 Jan 2022 21:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A74C340E4;
        Mon, 24 Jan 2022 21:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060541;
        bh=Gl0jy4PB5R5wa6o52whfL1Em2AKbbEFdXHfbPfhrtME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K49rSfobpH8tJuU7To1ke4zDHyldQjk99jmZ0hcpUfXMIw8Y4jA846+2ZvGjBHiRW
         zKROg6rw1iklVmejWfugQpI9JE496I3SDOSkShj4oJIXBN/wRzLaJtyAE83vOhMXmc
         GzTIzcZNyi+ua65jvuZgq1KmPNgQ3wmfx2U2+ylw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.16 0983/1039] virtio_ring: mark ring unused on error
Date:   Mon, 24 Jan 2022 19:46:12 +0100
Message-Id: <20220124184158.318703837@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

commit 1861ba626ae9b98136f3e504208cdef6b29cd3ec upstream.

A recently added error path does not mark ring unused when exiting on
OOM, which will lead to BUG on the next entry in debug builds.

TODO: refactor code so we have START_USE and END_USE in the same function.

Fixes: fc6d70f40b3d ("virtio_ring: check desc == NULL when using indirect with packed")
Cc: "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>
Cc: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/virtio_ring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1197,8 +1197,10 @@ static inline int virtqueue_add_packed(s
 	if (virtqueue_use_indirect(_vq, total_sg)) {
 		err = virtqueue_add_indirect_packed(vq, sgs, total_sg, out_sgs,
 						    in_sgs, data, gfp);
-		if (err != -ENOMEM)
+		if (err != -ENOMEM) {
+			END_USE(vq);
 			return err;
+		}
 
 		/* fall back on direct */
 	}


