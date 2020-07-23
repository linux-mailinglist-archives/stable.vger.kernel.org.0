Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D5122AB21
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 10:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGWIwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 04:52:55 -0400
Received: from esa5.hc3370-68.iphmx.com ([216.71.155.168]:62077 "EHLO
        esa5.hc3370-68.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbgGWIwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 04:52:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1595494374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aDtTphrzz9VOwTJvjWtl31/5xlDEnj/EJHimWB6gA4o=;
  b=D/VYZLdYjukNjmc8VFC5FBc7y42ygm3Nh39AlQpYXNIrLNjkTwxS4duP
   kR1l4YFtT7mqybaw7VoP1NVKwbbokTQ4jfq7d2IJE8v7cUjzHycwK9Fhm
   xkXu5z1Kcz+HQ8bPO63BQxy90Oj5TT7gto9RV3XyHzvHnCWdbBLHWOdoq
   I=;
Authentication-Results: esa5.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
IronPort-SDR: FWgaZAI6RoWQ6RqerM/hehVavtzAH7kBf/6J3Itw9DAyS7asko2A0WA2QUDT8/3hNJsqelSZhx
 aGmvB+UAcjhoS8QAFOir6owrVHYiklIGssIJbF2bknAmpy3xPWKLguU8S9RRbMH3bf0+cva/3N
 uWbogJ0Gm1FH42uL71Ft0fG/1RAiD2Rw7MHlwe8wv+Cn7R/dGiTSxubqWMgwlXk5nExHTGmjb4
 pCwIbJGW/hdprKdJesLAO/DCcfjT/aOM9VhVGAf07YUdfu+XW0GCx/J8nODk0DNNXrGa4pMW2b
 11g=
X-SBRS: 2.7
X-MesageID: 23212752
X-Ironport-Server: esa5.hc3370-68.iphmx.com
X-Remote-IP: 162.221.158.21
X-Policy: $RELAYED
X-IronPort-AV: E=Sophos;i="5.75,386,1589256000"; 
   d="scan'208";a="23212752"
From:   Roger Pau Monne <roger.pau@citrix.com>
To:     <linux-kernel@vger.kernel.org>
CC:     Roger Pau Monne <roger.pau@citrix.com>, <stable@vger.kernel.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: [PATCH 1/3] xen/balloon: fix accounting in alloc_xenballooned_pages error path
Date:   Thu, 23 Jul 2020 10:45:21 +0200
Message-ID: <20200723084523.42109-2-roger.pau@citrix.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200723084523.42109-1-roger.pau@citrix.com>
References: <20200723084523.42109-1-roger.pau@citrix.com>
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

