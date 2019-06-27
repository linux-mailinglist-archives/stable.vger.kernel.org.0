Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48D757586
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfF0AaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:30:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:1257 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfF0AaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:30:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 17:30:02 -0700
X-IronPort-AV: E=Sophos;i="5.63,421,1557212400"; 
   d="scan'208";a="152848892"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 17:30:02 -0700
Subject: [PATCH] filesystem-dax: Disable PMD support
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-nvdimm@lists.01.org
Cc:     Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org, Robert Barror <robert.barror@intel.com>,
        Seema Pandit <seema.pandit@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 26 Jun 2019 17:15:45 -0700
Message-ID: <156159454541.2964018.7466991316059381921.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Ever since the conversion of DAX to the Xarray a RocksDB benchmark has
been encountering intermittent lockups. The backtraces always include
the filesystem-DAX PMD path, multi-order entries have been a source of
bugs in the past, and disabling the PMD path allows a test that fails in
minutes to run for an hour.

The regression has been bisected to "dax: Convert page fault handlers to
XArray", but little progress has been made on the root cause debug.
Unless / until root cause can be identified mark CONFIG_FS_DAX_PMD
broken to preclude intermittent lockups. Reverting the Xarray conversion
also works, but that change is too big to backport. The implementation
is committed to Xarray at this point.

Link: https://lore.kernel.org/linux-fsdevel/CAPcyv4hwHpX-MkUEqxwdTj7wCCZCN4RV-L4jsnuwLGyL_UEG4A@mail.gmail.com/
Fixes: b15cd800682f ("dax: Convert page fault handlers to XArray")
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>
Reported-by: Robert Barror <robert.barror@intel.com>
Reported-by: Seema Pandit <seema.pandit@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/Kconfig b/fs/Kconfig
index f1046cf6ad85..85eecd0d4c5d 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -66,6 +66,9 @@ config FS_DAX_PMD
 	depends on FS_DAX
 	depends on ZONE_DEVICE
 	depends on TRANSPARENT_HUGEPAGE
+	# intermittent lockups since commit b15cd800682f "dax: Convert
+	# page fault handlers to XArray"
+	depends on BROKEN
 
 # Selected by DAX drivers that do not expect filesystem DAX to support
 # get_user_pages() of DAX mappings. I.e. "limited" indicates no support

