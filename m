Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5AE122C56E
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 14:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbgGXMmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 08:42:53 -0400
Received: from esa4.hc3370-68.iphmx.com ([216.71.155.144]:26861 "EHLO
        esa4.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgGXMmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 08:42:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1595594572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aDtTphrzz9VOwTJvjWtl31/5xlDEnj/EJHimWB6gA4o=;
  b=deiS7u4XhPpWcyrTBguRa/HFybY2oT+527j9v9hDZYTj5QajGP0eDFIf
   e1sQ+lNHIXbFlx2ROI87387Q4aePbqj0QV1UOdE2rXSEJC29D3E+/qB+1
   GGH+UiStNhEGpK7mKKCNQCvRSRrUc6kDbgbeYrtTshSp8kPd6IczNqZH0
   U=;
Authentication-Results: esa4.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: KJCsrxedNsP6PXR2GRxBdY4JBtMMaZKb/2iWqx70jsyhvQVs2mJ4a6ODJl6e5Ze0n71njR8l7V
 9U+neT0HVYP3POae1Ostbc3PyXtJbBN2r4zxUF0cQs6LBnJFr0VNVu/tNCJc9T1E4naoIb331o
 PnI7RkHi0XdVA2g0geZOyiF6+NKoWClGj8G1fo1E2jxpTrVvVikRzuiGwbtXCIN56qO7yeEIjv
 kh6FrSOIHklNuDPUeb45cpzlQ/2JrbYLIt+iJwQswgcnxS7Z13OFRECZhFNlp6l07ZlfxwhxDd
 Xyk=
X-SBRS: 2.7
X-MesageID: 23987140
X-Ironport-Server: esa4.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,390,1589256000"; 
   d="scan'208";a="23987140"
From:   Roger Pau Monne <roger.pau@citrix.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Roger Pau Monne <roger.pau@citrix.com>, <stable@vger.kernel.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: [PATCH v2 1/4] xen/balloon: fix accounting in alloc_xenballooned_pages error path
Date:   Fri, 24 Jul 2020 14:42:38 +0200
Message-ID: <20200724124241.48208-2-roger.pau@citrix.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200724124241.48208-1-roger.pau@citrix.com>
References: <20200724124241.48208-1-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

target_unpopulated is incremented with nr_pages at the start of the
function, but the call to free_xenballooned_pages will only subtract
pgno number of pages, and thus the rest need to be subtracted before
returning or else accounting will be skewed.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Cc: stable@vger.kernel.org
---
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: xen-devel@lists.xenproject.org
---
 drivers/xen/balloon.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 77c57568e5d7..3cb10ed32557 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -630,6 +630,12 @@ int alloc_xenballooned_pages(int nr_pages, struct page **pages)
  out_undo:
 	mutex_unlock(&balloon_mutex);
 	free_xenballooned_pages(pgno, pages);
+	/*
+	 * NB: free_xenballooned_pages will only subtract pgno pages, but since
+	 * target_unpopulated is incremented with nr_pages at the start we need
+	 * to remove the remaining ones also, or accounting will be screwed.
+	 */
+	balloon_stats.target_unpopulated -= nr_pages - pgno;
 	return ret;
 }
 EXPORT_SYMBOL(alloc_xenballooned_pages);
-- 
2.27.0

