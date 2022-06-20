Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9E6551DFE
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbiFTOCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345720AbiFTNy6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:54:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5324E33377;
        Mon, 20 Jun 2022 06:21:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F025260FAD;
        Mon, 20 Jun 2022 13:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B567C3411C;
        Mon, 20 Jun 2022 13:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731270;
        bh=pHNUnVvFxgMHHtqeEJJweemAidY0jWCuaaOGMSlY6nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHOcrgUkLM412kNSseX+x2U9boFmdJvJC5HhuUnyC2peWUXkEXeIkLXpp9aB479T1
         2dwcajL6pVZSRTaNass4Hy77x5pJYFJ5mNUOCis1FMZYqY5GWqR/5JP00VZ6w+Eskc
         Qlc6V8uK8PkLADISKJYUfFGH56GN5V3s93CResOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 208/240] i40e: Fix calculating the number of queue pairs
Date:   Mon, 20 Jun 2022 14:51:49 +0200
Message-Id: <20220620124745.007503488@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>

[ Upstream commit 0bb050670ac90a167ecfa3f9590f92966c9a3677 ]

If ADQ is enabled for a VF, then actual number of queue pair
is a number of currently available traffic classes for this VF.

Without this change the configuration of the Rx/Tx queues
fails with error.

Fixes: d29e0d233e0d ("i40e: missing input validation on VF message handling by the PF")
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 4962e6193eec..4080fdacca4c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2149,7 +2149,7 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 	}
 
 	if (vf->adq_enabled) {
-		for (i = 0; i < I40E_MAX_VF_VSI; i++)
+		for (i = 0; i < vf->num_tc; i++)
 			num_qps_all += vf->ch[i].num_qps;
 		if (num_qps_all != qci->num_queue_pairs) {
 			aq_ret = I40E_ERR_PARAM;
-- 
2.35.1



