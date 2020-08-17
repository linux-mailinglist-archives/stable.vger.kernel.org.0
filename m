Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE6C247300
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403883AbgHQSt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:49:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387963AbgHQPyC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:54:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2A1C2063A;
        Mon, 17 Aug 2020 15:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679642;
        bh=ciMy4Lc0X7f/X4FmvZ8YQPigCmj7iTZ3Q6YvqEQEMxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2lX5Ne8Jtr1SL1JXgJFbWbULQcMkWvBSJDmD3ljHORaImt5WwARbcvQz4xtXFwhF1
         GTLxqYeJW359+LbmW0gfurlES4R6sQ/R2HPU/Zd3jXtEN4uf0CXDumuiVDreYxjzin
         s8r3KIUzwZ2euGv8MaHxE6JpIFXsmEe/zCHNy8zI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vignesh Sridhar <vignesh.sridhar@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 283/393] ice: Clear and free XLT entries on reset
Date:   Mon, 17 Aug 2020 17:15:33 +0200
Message-Id: <20200817143833.347121771@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Sridhar <vignesh.sridhar@intel.com>

[ Upstream commit ec1d1d2302067e3ccbc4d0adcd36d72410933b70 ]

This fix has been added to address memory leak issues resulting from
triggering a sudden driver reset which does not allow us to follow our
normal removal flows for SW XLT entries for advanced features.

- Adding call to destroy flow profile locks when clearing SW XLT tables.

- Extraction sequence entries were not correctly cleared previously
which could cause ownership conflicts for repeated reset-replay calls.

Fixes: 31ad4e4ee1e4 ("ice: Allocate flow profile")
Signed-off-by: Vignesh Sridhar <vignesh.sridhar@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index abfec38bb4831..d60e31f65749f 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -2291,6 +2291,8 @@ static void ice_free_flow_profs(struct ice_hw *hw, u8 blk_idx)
 	mutex_lock(&hw->fl_profs_locks[blk_idx]);
 	list_for_each_entry_safe(p, tmp, &hw->fl_profs[blk_idx], l_entry) {
 		list_del(&p->l_entry);
+
+		mutex_destroy(&p->entries_lock);
 		devm_kfree(ice_hw_to_dev(hw), p);
 	}
 	mutex_unlock(&hw->fl_profs_locks[blk_idx]);
@@ -2408,7 +2410,7 @@ void ice_clear_hw_tbls(struct ice_hw *hw)
 		memset(prof_redir->t, 0,
 		       prof_redir->count * sizeof(*prof_redir->t));
 
-		memset(es->t, 0, es->count * sizeof(*es->t));
+		memset(es->t, 0, es->count * sizeof(*es->t) * es->fvw);
 		memset(es->ref_count, 0, es->count * sizeof(*es->ref_count));
 		memset(es->written, 0, es->count * sizeof(*es->written));
 	}
-- 
2.25.1



