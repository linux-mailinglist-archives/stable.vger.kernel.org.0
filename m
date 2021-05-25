Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2246D390727
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 19:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhEYRMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 13:12:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:33956 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232224AbhEYRMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 13:12:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1621962664; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c0AWVkLbJndfL91y/7FrlmsRe9upgcIAJ1Xmpv1SCnA=;
        b=kTkUSleaaWPm5sGIsgiW/QyU1NAUCsXyLgExGU76Qz503nPaGKfvBAmsSUqR4ufm5Gm4NB
        KUeyFQLKDW5zqf5jKCLqBYzi2m7Lkzd5Th6xrBIiKB8nMQ1uW4xZtLzpGa+ELt1fZ6oXgz
        bvgtt5CsW+INcG7vck06/F7SFIaEgLA=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 520E5AF37;
        Tue, 25 May 2021 17:11:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C8558DA70B; Tue, 25 May 2021 19:08:27 +0200 (CEST)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Subject: [PATCH 2/9] btrfs: clear defrag status of a root if starting transaction fails
Date:   Tue, 25 May 2021 19:08:27 +0200
Message-Id: <183259751d20f64fa45dab806b7083923e718ceb.1621961965.git.dsterba@suse.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1621961965.git.dsterba@suse.com>
References: <cover.1621961965.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The defrag loop processes leaves in batches and starting transaction for
each. The whole defragmentation on a given root is protected by a bit
but in case the transaction fails, the bit is not cleared

In case the transaction fails the bit would prevent starting
defragmentation again, so make sure it's cleared.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/transaction.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index e0a82aa7da89..22951621363f 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1406,8 +1406,10 @@ int btrfs_defrag_root(struct btrfs_root *root)
 
 	while (1) {
 		trans = btrfs_start_transaction(root, 0);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			break;
+		}
 
 		ret = btrfs_defrag_leaves(trans, root);
 
-- 
2.29.2

