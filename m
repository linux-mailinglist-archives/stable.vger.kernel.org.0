Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674414997AB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449006AbiAXVOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446317AbiAXVHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:07:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E767CC055AAC;
        Mon, 24 Jan 2022 12:08:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 890CD6137C;
        Mon, 24 Jan 2022 20:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A158C340E5;
        Mon, 24 Jan 2022 20:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054899;
        bh=mi8szNe7SyfcyY24P0ioZ15zE0DHpA/xXv6Ss/mPiA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/VZefa/wvzrqxsSA+gHiFMJmTyxN8Vfr6UoGMvwNwRLsqg1c2/rlxiUTkbHCFJcu
         wNnECNDhR0pPbcpvIdoVEiVUCtKYAdqp2x9BZNEH2CqllKJ1fPnIJl7zwXNTwFjMdo
         MD7muXp5FbtECAW4QNve0hxbHeq852/OPNysz4Ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.10 532/563] virtio_ring: mark ring unused on error
Date:   Mon, 24 Jan 2022 19:44:57 +0100
Message-Id: <20220124184042.850338561@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -1124,8 +1124,10 @@ static inline int virtqueue_add_packed(s
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


