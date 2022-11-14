Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA30562804D
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237774AbiKNNEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237766AbiKNNEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:04:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C9D29CB3
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:04:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 015216117E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1235DC433D7;
        Mon, 14 Nov 2022 13:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431087;
        bh=rwsDboeCnPhTRajjLjMINmOWY6vQgX+WtdXiFP26C8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIRDwoowGVEFycpTAa/LzfqbI/nF2H7TvA0Q/nCxPYoUIIZpFvefhsR9tuIc25NUB
         Qt81CfJMpBdukkP74bTwcEkfwJ2DCTb2zYed6/awZzg9KEmRjHsHPZ7lR6ozC4sSzm
         UoFSqzRzvtXkX48AQUzoxlUV8p9WqiONiKI4HRxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>,
        Michal Jaron <michalx.jaron@intel.com>,
        Kamil Maziarz <kamil.maziarz@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 095/190] iavf: Fix VF driver counting VLAN 0 filters
Date:   Mon, 14 Nov 2022 13:45:19 +0100
Message-Id: <20221114124502.854728082@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Jaron <michalx.jaron@intel.com>

[ Upstream commit 0e710a3ffd0caaf23b8791b041e8792f252f8e4f ]

VF driver mistakenly counts VLAN 0 filters, when no PF driver
counts them.
Do not count VLAN 0 filters, when VLAN_V2 is engaged.
Counting those filters in, will affect filters size by -1, when
sending batched VLAN addition message.

Fixes: 968996c070ef ("iavf: Fix VLAN_V2 addition/rejection")
Signed-off-by: Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 5a9e6563923e..24a701fd140e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -2438,6 +2438,8 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
 			if (f->is_new_vlan) {
 				f->is_new_vlan = false;
+				if (!f->vlan.vid)
+					continue;
 				if (f->vlan.tpid == ETH_P_8021Q)
 					set_bit(f->vlan.vid,
 						adapter->vsi.active_cvlans);
-- 
2.35.1



