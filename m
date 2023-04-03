Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB196D47ED
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233227AbjDCOYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233231AbjDCOYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:24:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7F92B0DE
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:24:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CAB561D7D
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF93C433EF;
        Mon,  3 Apr 2023 14:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531857;
        bh=JjCUSGLq9ji0Ls5e4bdhoyRzopxIWySBanXY5M92eVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Siuz14tW1G3XN/cTcEyOPnhdXtWEVGq9O3WKNLvkK/3NyORsawxR1lBK5/7UpzfRN
         OhNhTweL9QBcFTOXhf01bikQF7YxOi1n24cthoJ/v1pK1a5IylJWMifthv9WvsQjmK
         dY94yNqmp0KbsCr6rDtnow1zX3arjqhiFKHqsh/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniil Tatianin <d-tatianin@yandex-team.ru>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/173] qed/qed_sriov: guard against NULL derefs from qed_iov_get_vf_info
Date:   Mon,  3 Apr 2023 16:07:28 +0200
Message-Id: <20230403140415.445317285@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
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
index 3541bc95493f0..b2a2beb84e54e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -4378,6 +4378,9 @@ qed_iov_configure_min_tx_rate(struct qed_dev *cdev, int vfid, u32 rate)
 	}
 
 	vf = qed_iov_get_vf_info(QED_LEADING_HWFN(cdev), (u16)vfid, true);
+	if (!vf)
+		return -EINVAL;
+
 	vport_id = vf->vport_id;
 
 	return qed_configure_vport_wfq(cdev, vport_id, rate);
@@ -5123,7 +5126,7 @@ static void qed_iov_handle_trust_change(struct qed_hwfn *hwfn)
 
 		/* Validate that the VF has a configured vport */
 		vf = qed_iov_get_vf_info(hwfn, i, true);
-		if (!vf->vport_instance)
+		if (!vf || !vf->vport_instance)
 			continue;
 
 		memset(&params, 0, sizeof(params));
-- 
2.39.2



