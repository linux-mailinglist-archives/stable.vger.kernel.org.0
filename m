Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA647201800
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbgFSOlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387470AbgFSOlf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:41:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FAF12070A;
        Fri, 19 Jun 2020 14:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577695;
        bh=AoCJP4443lKj4hyl1GTi/yV8cWeVgsfTrVCN5IgjCE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qw6JWJreidvE1Kd2g2GT0T08FxtpjbAVJOzUlEinGNu2xfkHrLkkLmmqEeBmXN8Bk
         0ZgtYefhDHzmdpgFwaIF29L4Oyg7QKePQBsPn/ceNC5wX/5wbH3dlULfEf3oEveJM7
         wuP95CKRKlVKrdea/uDACx1mt43eIry2axh5H5ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Andi Shyti <andi.shyti@intel.com>
Subject: [PATCH 4.9 051/128] agp/intel: Reinforce the barrier after GTT updates
Date:   Fri, 19 Jun 2020 16:32:25 +0200
Message-Id: <20200619141622.889134311@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
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
@@ -845,6 +845,7 @@ void intel_gtt_insert_page(dma_addr_t ad
 			   unsigned int flags)
 {
 	intel_private.driver->write_entry(addr, pg, flags);
+	readl(intel_private.gtt + pg);
 	if (intel_private.driver->chipset_flush)
 		intel_private.driver->chipset_flush();
 }
@@ -870,7 +871,7 @@ void intel_gtt_insert_sg_entries(struct
 			j++;
 		}
 	}
-	wmb();
+	readl(intel_private.gtt + j - 1);
 	if (intel_private.driver->chipset_flush)
 		intel_private.driver->chipset_flush();
 }
@@ -1104,6 +1105,7 @@ static void i9xx_cleanup(void)
 
 static void i9xx_chipset_flush(void)
 {
+	wmb();
 	if (intel_private.i9xx_flush_page)
 		writel(1, intel_private.i9xx_flush_page);
 }


