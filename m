Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66224B1E59
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388490AbfIMNJW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:09:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388485AbfIMNJV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:09:21 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1610C206A5;
        Fri, 13 Sep 2019 13:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380160;
        bh=Q8ubUf1wdWsRkefuO4WS0UqQPdMNKx296WdlCZg5/AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtIAcGhZL37WL3/D2ueAbnbMHAN9PG4E34eqQpbAbaResgE8m808RID8kDky6UDKh
         yT8zGCfzjXySIx2GGbOYBJ+R+5K7a4805rlxcPHjvUKHdOzSQ10JKjqq4u8nrr3znO
         w1obcHjg4CEq1/yjVMplIHGea27v3a2u2LJWSv68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH 4.9 13/14] vhost: block speculation of translated descriptors
Date:   Fri, 13 Sep 2019 14:07:06 +0100
Message-Id: <20190913130446.656909137@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130440.264749443@linuxfoundation.org>
References: <20190913130440.264749443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael S. Tsirkin <mst@redhat.com>

commit a89db445fbd7f1f8457b03759aa7343fa530ef6b upstream.

iovec addresses coming from vhost are assumed to be
pre-validated, but in fact can be speculated to a value
out of range.

Userspace address are later validated with array_index_nospec so we can
be sure kernel info does not leak through these addresses, but vhost
must also not leak userspace info outside the allowed memory table to
guests.

Following the defence in depth principle, make sure
the address is not validated out of node range.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: stable@vger.kernel.org
Acked-by: Jason Wang <jasowang@redhat.com>
Tested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/vhost.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1874,8 +1874,10 @@ static int translate_desc(struct vhost_v
 		_iov = iov + ret;
 		size = node->size - addr + node->start;
 		_iov->iov_len = min((u64)len - s, size);
-		_iov->iov_base = (void __user *)(unsigned long)
-			(node->userspace_addr + addr - node->start);
+		_iov->iov_base = (void __user *)
+			((unsigned long)node->userspace_addr +
+			 array_index_nospec((unsigned long)(addr - node->start),
+					    node->size));
 		s += size;
 		addr += size;
 		++ret;


