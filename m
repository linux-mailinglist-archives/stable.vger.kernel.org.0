Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BAD1FB84B
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgFPPzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:55:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733036AbgFPPy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:54:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DAF921527;
        Tue, 16 Jun 2020 15:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322897;
        bh=VwSN0YU9Oj7OXqaDGPp3XR8cYu0IhWpaSJ1/3foAwJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEs3GbwXW1tuC4AcnxdI/wR1rVcOE3TcOkMyZrFhl3KE8m4kHI91vn+zGr+SJWCjL
         YMuZwA9N5qYndSogM0YZUFzhsAoPRfBALHjw/7NvpmcYXi/otTX6E3+dxR4nbCb4Uw
         hNLqtjfVHZgSOaj9aNYTfHeacql/apx9B7mPLwjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Andi Shyti <andi.shyti@intel.com>
Subject: [PATCH 5.6 147/161] agp/intel: Reinforce the barrier after GTT updates
Date:   Tue, 16 Jun 2020 17:35:37 +0200
Message-Id: <20200616153113.345397960@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit f30d3ced9fafa03e4855508929b5b6334907f45e upstream.

After changing the timing between GTT updates and execution on the GPU,
we started seeing sporadic failures on Ironlake. These were narrowed
down to being an insufficiently strong enough barrier/delay after
updating the GTT and scheduling execution on the GPU. By forcing the
uncached read, and adding the missing barrier for the singular
insert_page (relocation paths), the sporadic failures go away.

Fixes: 983d308cb8f6 ("agp/intel: Serialise after GTT updates")
Fixes: 3497971a71d8 ("agp/intel: Flush chipset writes after updating a single PTE")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Andi Shyti <andi.shyti@intel.com>
Cc: stable@vger.kernel.org # v4.0+
Link: https://patchwork.freedesktop.org/patch/msgid/20200410083535.25464-1-chris@chris-wilson.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/agp/intel-gtt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -846,6 +846,7 @@ void intel_gtt_insert_page(dma_addr_t ad
 			   unsigned int flags)
 {
 	intel_private.driver->write_entry(addr, pg, flags);
+	readl(intel_private.gtt + pg);
 	if (intel_private.driver->chipset_flush)
 		intel_private.driver->chipset_flush();
 }
@@ -871,7 +872,7 @@ void intel_gtt_insert_sg_entries(struct
 			j++;
 		}
 	}
-	wmb();
+	readl(intel_private.gtt + j - 1);
 	if (intel_private.driver->chipset_flush)
 		intel_private.driver->chipset_flush();
 }
@@ -1105,6 +1106,7 @@ static void i9xx_cleanup(void)
 
 static void i9xx_chipset_flush(void)
 {
+	wmb();
 	if (intel_private.i9xx_flush_page)
 		writel(1, intel_private.i9xx_flush_page);
 }


