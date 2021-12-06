Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B31AB469F2F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391501AbhLFPpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390691AbhLFPmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F3FC0698E4;
        Mon,  6 Dec 2021 07:29:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5FB461322;
        Mon,  6 Dec 2021 15:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B2EDC34900;
        Mon,  6 Dec 2021 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804568;
        bh=n8V+UayL874nh+QL2WUkvqJ7PtJp9nFyGmUjTT8SLW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VX6fA4QCJXdYQeH+4Hhc8SHl5FMhIwDYHlmFm9ttf/X+AD1VEBeDh2f5tt0J+kqhU
         IgTIo8XaVlgu9FwYHtwUGB2e/p/n+SL+4AjFaxrV6eaF+PS1pbksXT34C7Vw9k78BX
         0oQO98yMdkaxS8zlRr9yC5jan0L03XOg3jBNDXd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@kernel.org>,
        Zhou Qingyang <zhou1615@umn.edu>
Subject: [PATCH 5.15 193/207] usb: cdnsp: Fix a NULL pointer dereference in cdnsp_endpoint_init()
Date:   Mon,  6 Dec 2021 15:57:27 +0100
Message-Id: <20211206145616.961913284@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Qingyang <zhou1615@umn.edu>

commit 37307f7020ab38dde0892a578249bf63d00bca64 upstream.

In cdnsp_endpoint_init(), cdnsp_ring_alloc() is assigned to pep->ring
and there is a dereference of it in cdnsp_endpoint_init(), which could
lead to a NULL pointer dereference on failure of cdnsp_ring_alloc().

Fix this bug by adding a check of pep->ring.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_USB_CDNSP_GADGET=y show no new warnings,
and our static analyzer no longer warns about this code.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Cc: stable <stable@vger.kernel.org>
Acked-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Link: https://lore.kernel.org/r/20211130172700.206650-1-zhou1615@umn.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-mem.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/cdns3/cdnsp-mem.c
+++ b/drivers/usb/cdns3/cdnsp-mem.c
@@ -987,6 +987,9 @@ int cdnsp_endpoint_init(struct cdnsp_dev
 
 	/* Set up the endpoint ring. */
 	pep->ring = cdnsp_ring_alloc(pdev, 2, ring_type, max_packet, mem_flags);
+	if (!pep->ring)
+		return -ENOMEM;
+
 	pep->skip = false;
 
 	/* Fill the endpoint context */


