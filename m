Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DC1579E26
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239887AbiGSM6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242481AbiGSM5q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:57:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7811B459B8;
        Tue, 19 Jul 2022 05:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E568D61632;
        Tue, 19 Jul 2022 12:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB4FC341C6;
        Tue, 19 Jul 2022 12:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233394;
        bh=rxlbLmPe2RGO+1IlEcnh73vt9heuUv2J9NYtvApGj6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZCVeGaNrSkxBbl8CuRTapX5HZj833RERxXH6GCKqgrRBjweo0XDii2gPR5/eVbyB
         Dap/dKS5MNYI8x5w3c3r4H12/mliFbUs0udFDTK8y8DNOh21WqiHalb9iCqQpPLuBj
         bHOrBM/tzIt//v+iFf+7CWa3rC3QcfIDHk3thHeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 107/231] bnxt_en: fix livepatch query
Date:   Tue, 19 Jul 2022 13:53:12 +0200
Message-Id: <20220719114723.621691392@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit 619b9b1622c283cc5ca86f4c487db266a8f55dab ]

In the livepatch query fw_target BNXT_FW_SRT_PATCH is
applicable for P5 chips only.

Fixes: 3c4153394e2c ("bnxt_en: implement firmware live patching")
Reviewed-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 0c17f90d44a2..3a9441fe4fd1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -979,9 +979,11 @@ static int bnxt_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
 	if (rc)
 		return rc;
 
-	rc = bnxt_dl_livepatch_info_put(bp, req, BNXT_FW_SRT_PATCH);
-	if (rc)
-		return rc;
+	if (BNXT_CHIP_P5(bp)) {
+		rc = bnxt_dl_livepatch_info_put(bp, req, BNXT_FW_SRT_PATCH);
+		if (rc)
+			return rc;
+	}
 	return bnxt_dl_livepatch_info_put(bp, req, BNXT_FW_CRT_PATCH);
 
 }
-- 
2.35.1



