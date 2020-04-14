Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653071A79CA
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 13:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439490AbgDNLmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 07:42:38 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:37603 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439481AbgDNLmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 07:42:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id B5CA59B4;
        Tue, 14 Apr 2020 07:42:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 14 Apr 2020 07:42:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wG13IX
        B5Qp6VOasvsR6q3x2BjfUnCQB2DJ6RpuSm7w4=; b=IsnBQL3Mp9FdPF4F5kcjsC
        t7Qo0WyHwWiNChyG6nVq1re6tKD/MAlJO6jEA34cPXYfckKQms5A/r3xgXhzNRUe
        utBMU684r4rDjtRI4DT6Wmlrj/RlNZH6BFbIJVTRYq45FDZCCK1XhdtDYY4Uoldu
        d56oCMCdVbyPWd7ZjNlBDyg5W5WazLfyuKYmGX6m9eedul8fX6ic4ynLbfwzCEr2
        2a6VbCLI0cNDSJM8vTgdphwaNRVAsLWgrKWtphVmM6lXzRudeVMtOHMtZavIBn19
        ImAzZ4S63tKkI1/HRxyRTCCdbJxDlrc1LXGeRDfYEvshW9P3n1L7N4LNzB4Z1IZA
        ==
X-ME-Sender: <xms:qqGVXhFLWKiJs5woPr7JdoBz5F2whlqqad7x63yOWHwGh9M7SWq1TA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfedugdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:qqGVXsw-HQKDpgR99Zu0Wb8JhImETb9-gpqVtm1Rf7pEfSDYO-Un0g>
    <xmx:qqGVXr87HsdzrMsWJUC4tVT4zBEoSiMoR4GKunSEdpmn52sQFJo2Lw>
    <xmx:qqGVXmX-UBjT_i6_a8qAkhX5lMiA9e_7_yM43ldzhw6WQ3Gk9MZmaQ>
    <xmx:qqGVXuvc14qWp9WO_YNGJt4Q6XDbHIDxoBOq1HNwr-oN6ZnSJvxN4w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F2304306005B;
        Tue, 14 Apr 2020 07:42:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] erofs: correct the remaining shrink objects" failed to apply to 5.4-stable tree
To:     xiang@kernel.org, gaoxiang25@huawei.com, stable@vger.kernel.org,
        yuchao0@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Apr 2020 13:42:25 +0200
Message-ID: <1586864545119140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9d5a09c6f3b5fb85af20e3a34827b5d27d152b34 Mon Sep 17 00:00:00 2001
From: Gao Xiang <xiang@kernel.org>
Date: Wed, 26 Feb 2020 16:10:06 +0800
Subject: [PATCH] erofs: correct the remaining shrink objects

The remaining count should not include successful
shrink attempts.

Fixes: e7e9a307be9d ("staging: erofs: introduce workstation for decompression")
Cc: <stable@vger.kernel.org> # 4.19+
Link: https://lore.kernel.org/r/20200226081008.86348-1-gaoxiang25@huawei.com
Reviewed-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Gao Xiang <gaoxiang25@huawei.com>

diff --git a/fs/erofs/utils.c b/fs/erofs/utils.c
index 4396b424373f..52d0be10f1aa 100644
--- a/fs/erofs/utils.c
+++ b/fs/erofs/utils.c
@@ -262,7 +262,7 @@ static unsigned long erofs_shrink_scan(struct shrinker *shrink,
 		spin_unlock(&erofs_sb_list_lock);
 		sbi->shrinker_run_no = run_no;
 
-		freed += erofs_shrink_workstation(sbi, nr);
+		freed += erofs_shrink_workstation(sbi, nr - freed);
 
 		spin_lock(&erofs_sb_list_lock);
 		/* Get the next list element before we move this one */

