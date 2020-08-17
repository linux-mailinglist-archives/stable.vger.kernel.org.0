Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C331F247589
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731992AbgHQTY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:38672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729556AbgHQPeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:34:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F195208B3;
        Mon, 17 Aug 2020 15:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678463;
        bh=YdWU+OC7HwpMZ2Qxoo3a1t4tkGl4iN6BYJQOodDcjnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDgMqsP8CzDwBuBgScYSiueGeAjrLxUAWf580Y26boWUb2yEAEpxhZJ8wWpuoCAU+
         UQF07Y7KbICaI2Ih5OjIzaOJAnOLAfjWFiNZA1lOSkybwq3ODkbDvWwSM6I/74c78w
         IAES3zirxD5AAeJntddRSRMJ0249BRcoGa5tDzXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vignesh Sridhar <vignesh.sridhar@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 342/464] ice: Clear and free XLT entries on reset
Date:   Mon, 17 Aug 2020 17:14:55 +0200
Message-Id: <20200817143850.155765628@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
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
index 4420fc02f7e7a..6698612048625 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -2922,6 +2922,8 @@ static void ice_free_flow_profs(struct ice_hw *hw, u8 blk_idx)
 					   ICE_FLOW_ENTRY_HNDL(e));
 
 		list_del(&p->l_entry);
+
+		mutex_destroy(&p->entries_lock);
 		devm_kfree(ice_hw_to_dev(hw), p);
 	}
 	mutex_unlock(&hw->fl_profs_locks[blk_idx]);
@@ -3039,7 +3041,7 @@ void ice_clear_hw_tbls(struct ice_hw *hw)
 		memset(prof_redir->t, 0,
 		       prof_redir->count * sizeof(*prof_redir->t));
 
-		memset(es->t, 0, es->count * sizeof(*es->t));
+		memset(es->t, 0, es->count * sizeof(*es->t) * es->fvw);
 		memset(es->ref_count, 0, es->count * sizeof(*es->ref_count));
 		memset(es->written, 0, es->count * sizeof(*es->written));
 	}
-- 
2.25.1



