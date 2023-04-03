Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8EBA6D4742
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbjDCOSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233019AbjDCOSo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:18:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E592C9DB
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:18:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DD5661CE8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F36C433EF;
        Mon,  3 Apr 2023 14:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531520;
        bh=Q9x5Kde58VKF6BpxpNMbI4yLxu0G7kji2W/H/sd1o8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F+hUgUYLLj0xyxGsNxSFkC6jhi9vThUjRgeu2BtCJ/cyBp6mKNVCNEdDjtQzSnUuk
         R3ldN2hmhLdS53mr4T1MAqRoISsvn41xLjPnpWp9aZiGX4SAJn4yv++sGDVQuSIh7b
         In2j3yXMCCASXg+QjWhOvS8u2++wfhn3SOwLKwH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/104] qed/qed_sriov: guard against NULL derefs from qed_iov_get_vf_info
Date:   Mon,  3 Apr 2023 16:08:02 +0200
Message-Id: <20230403140404.539136588@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniil Tatianin <d-tatianin@yandex-team.ru>

[ Upstream commit 25143b6a01d0cc5319edd3de22ffa2578b045550 ]

We have to make sure that the info returned by the helper is valid
before using it.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: f990c82c385b ("qed*: Add support for ndo_set_vf_trust")
Fixes: 733def6a04bf ("qed*: IOV link control")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 20f840ea05030..caa0468df4b53 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -4404,6 +4404,9 @@ qed_iov_configure_min_tx_rate(struct qed_dev *cdev, int vfid, u32 rate)
 	}
 
 	vf = qed_iov_get_vf_info(QED_LEADING_HWFN(cdev), (u16)vfid, true);
+	if (!vf)
+		return -EINVAL;
+
 	vport_id = vf->vport_id;
 
 	return qed_configure_vport_wfq(cdev, vport_id, rate);
@@ -5150,7 +5153,7 @@ static void qed_iov_handle_trust_change(struct qed_hwfn *hwfn)
 
 		/* Validate that the VF has a configured vport */
 		vf = qed_iov_get_vf_info(hwfn, i, true);
-		if (!vf->vport_instance)
+		if (!vf || !vf->vport_instance)
 			continue;
 
 		memset(&params, 0, sizeof(params));
-- 
2.39.2



