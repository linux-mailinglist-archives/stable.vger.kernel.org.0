Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE13ADD9A9
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 18:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfJSQki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Oct 2019 12:40:38 -0400
Received: from mga14.intel.com ([192.55.52.115]:32566 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfJSQki (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Oct 2019 12:40:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Oct 2019 09:40:37 -0700
X-IronPort-AV: E=Sophos;i="5.67,316,1566889200"; 
   d="scan'208";a="201001939"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Oct 2019 09:40:37 -0700
Subject: [PATCH] fs/dax: Fix pmd vs pte conflict detection
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     Jeff Smits <jeff.smits@intel.com>,
        Doug Nelson <doug.nelson@intel.com>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>,
        "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Date:   Sat, 19 Oct 2019 09:26:19 -0700
Message-ID: <157150237973.3940076.12626102230619807187.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Check for NULL entries before checking the entry order, otherwise NULL
is misinterpreted as a present pte conflict. The 'order' check needs to
happen before the locked check as an unlocked entry at the wrong order
must fallback to lookup the correct order.

Reported-by: Jeff Smits <jeff.smits@intel.com>
Reported-by: Doug Nelson <doug.nelson@intel.com>
Cc: <stable@vger.kernel.org>
Fixes: 23c84eb78375 ("dax: Fix missed wakeup with PMD faults")
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index a71881e77204..08160011d94c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -221,10 +221,11 @@ static void *get_unlocked_entry(struct xa_state *xas, unsigned int order)
 
 	for (;;) {
 		entry = xas_find_conflict(xas);
+		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)))
+			return entry;
 		if (dax_entry_order(entry) < order)
 			return XA_RETRY_ENTRY;
-		if (!entry || WARN_ON_ONCE(!xa_is_value(entry)) ||
-				!dax_is_locked(entry))
+		if (!dax_is_locked(entry))
 			return entry;
 
 		wq = dax_entry_waitqueue(xas, entry, &ewait.key);

