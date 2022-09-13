Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E3E5B7203
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiIMOuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234575AbiIMOtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:49:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0515B71714;
        Tue, 13 Sep 2022 07:25:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15001B80F2B;
        Tue, 13 Sep 2022 14:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8212EC433C1;
        Tue, 13 Sep 2022 14:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078389;
        bh=SyFQie/gvul2pEjKKXd4UsW6X9h5wZm0EQz3P2BT5Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hsk82jr9PzoQC3iiHoySOKwJvBaPfElmCNf79eFLP6lRy7s2w11dnZoSJj0UWMdKl
         FH6m4ZJ7jNajIGHQQis4XKRv7HolZTVxXrDGlTkJQLYS8ZLx2i9EudSCpJRDllWrnk
         wP8A88Pkf8kkWp+L1KZtJjUXmAvjQ7GGqHRLFFZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH 5.19 120/192] ice: use bitmap_free instead of devm_kfree
Date:   Tue, 13 Sep 2022 16:03:46 +0200
Message-Id: <20220913140415.962205784@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

[ Upstream commit 59ac325557b6c14f1f793b90d3946bc145ffa085 ]

pf->avail_txqs was allocated using bitmap_zalloc, bitmap_free should be
used to free this memory.

Fixes: 78b5713ac1241 ("ice: Alloc queue management bitmaps and arrays dynamically")
Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index abc5d2b91f32b..4c6bb7482b362 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3912,7 +3912,7 @@ static int ice_init_pf(struct ice_pf *pf)
 
 	pf->avail_rxqs = bitmap_zalloc(pf->max_pf_rxqs, GFP_KERNEL);
 	if (!pf->avail_rxqs) {
-		devm_kfree(ice_pf_to_dev(pf), pf->avail_txqs);
+		bitmap_free(pf->avail_txqs);
 		pf->avail_txqs = NULL;
 		return -ENOMEM;
 	}
-- 
2.35.1



