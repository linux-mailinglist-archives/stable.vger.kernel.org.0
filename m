Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232CD4124E6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381646AbhITSjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381244AbhITShB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 554EC63313;
        Mon, 20 Sep 2021 17:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158976;
        bh=f6D9i/fpwHzNTa4IRWLZh6SapM96QDsmr4fwG9XetUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EIWIuLeTNAX2KR+mLKA4Y2UbLB+lnDPd4oUDeW4wHRegfc7yhvzy2C+yTe8UqDwio
         TEQvDQOHpB73T/7MUGvO0gBqpzGqUQNBFnpSZImkbd+aiYkymQ7o3/wr6yK0BYl9yi
         7aYOKTFxQZ3VANUPpkuY3hVtDgN199AncWnnqPTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Christoph Hellwig <hch@lst.de>, Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.14 002/168] swiotlb-xen: avoid double free
Date:   Mon, 20 Sep 2021 18:42:20 +0200
Message-Id: <20210920163921.724284878@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit ce6a80d1b2f923b1839655a1cda786293feaa085 upstream.

Of the two paths leading to the "error" label in xen_swiotlb_init() one
didn't allocate anything, while the other did already free what was
allocated.

Fixes: b82776005369 ("xen/swiotlb: Use the swiotlb_late_init_with_tbl to init Xen-SWIOTLB late when PV PCI is used")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/ce9c2adb-8a52-6293-982a-0d6ece943ac6@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/swiotlb-xen.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -216,7 +216,6 @@ error:
 		goto retry;
 	}
 	pr_err("%s (rc:%d)\n", xen_swiotlb_error(m_ret), rc);
-	free_pages((unsigned long)start, order);
 	return rc;
 }
 


