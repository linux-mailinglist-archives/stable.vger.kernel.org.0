Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B12E3E67DC
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732644AbfJ0VZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731619AbfJ0VZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:25:04 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1B7321D7F;
        Sun, 27 Oct 2019 21:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211503;
        bh=RZe3x2QMnBMoUTrxlqdl+QyaKmXRYQA/663XzT4czy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x6j89u02drSPV0ayy2LyGIJ28Qw5yi9txB8YKSeLJFpsGpHL9gli61q+z67omVThK
         f7SjqoahDHBlpc4JPIEdJFqyjf463/P+9k28Cfemgr/oIlWjnEOytMEcHuzXQ17RPF
         JmNoY08+uH/+wpVtQ1GAo/YhqRlqjv84NpLJZnXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Smits <jeff.smits@intel.com>,
        Doug Nelson <doug.nelson@intel.com>, Jan Kara <jack@suse.cz>,
        Jeff Moyer <jmoyer@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.3 172/197] fs/dax: Fix pmd vs pte conflict detection
Date:   Sun, 27 Oct 2019 22:01:30 +0100
Message-Id: <20191027203404.171724171@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 6370740e5f8ef12de7f9a9bf48a0393d202cd827 upstream.

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
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Link: https://lore.kernel.org/r/157167532455.3945484.11971474077040503994.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dax.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/dax.c
+++ b/fs/dax.c
@@ -220,10 +220,11 @@ static void *get_unlocked_entry(struct x
 
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


