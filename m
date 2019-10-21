Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E9BDF369
	for <lists+stable@lfdr.de>; Mon, 21 Oct 2019 18:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfJUQnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Oct 2019 12:43:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:59354 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727582AbfJUQnj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Oct 2019 12:43:39 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 09:43:38 -0700
X-IronPort-AV: E=Sophos;i="5.67,324,1566889200"; 
   d="scan'208";a="187595740"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 09:43:38 -0700
Subject: [PATCH v2] fs/dax: Fix pmd vs pte conflict detection
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-fsdevel@vger.kernel.org
Cc:     Jeff Smits <jeff.smits@intel.com>,
        Doug Nelson <doug.nelson@intel.com>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
        linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
Date:   Mon, 21 Oct 2019 09:29:20 -0700
Message-ID: <157167532455.3945484.11971474077040503994.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Users reported a v5.3 performance regression and inability to establish
huge page mappings. A revised version of the ndctl "dax.sh" huge page
unit test identifies commit 23c84eb78375 "dax: Fix missed wakeup with
PMD faults" as the source.

Update get_unlocked_entry() to check for NULL entries before checking
the entry order, otherwise NULL is misinterpreted as a present pte
conflict. The 'order' check needs to happen before the locked check as
an unlocked entry at the wrong order must fallback to lookup the correct
order.

Reported-by: Jeff Smits <jeff.smits@intel.com>
Reported-by: Doug Nelson <doug.nelson@intel.com>
Cc: <stable@vger.kernel.org>
Fixes: 23c84eb78375 ("dax: Fix missed wakeup with PMD faults")
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Changes in v2:
- Update the changelog to reflect the user visible effects of the bug
  (Jeff)

 fs/dax.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 6bf81f931de3..2cc43cd914eb 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -220,10 +220,11 @@ static void *get_unlocked_entry(struct xa_state *xas, unsigned int order)
 
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

