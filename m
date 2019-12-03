Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E5F111F84
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbfLCWnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:43:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728062AbfLCWnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:43:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CCB520803;
        Tue,  3 Dec 2019 22:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412988;
        bh=r8RD+TSm9031sECWo8nDnwzU0EStJIFqQDq83ZJfoHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gt8IbxeNjcvr94q9u1ilwzGrIiFygN7B5/Qu1hf+ckuFgNESMMppRKdyqe9JKO3wW
         wvbgGI1quzkklYhffQ/VjNtpJPtpWueWG7PuewACa00TCcktZOgLuePa32CicBCJLa
         zid9F0Kj/4DHQk5MQ87a4ULZxaH0OM+ssQBEk2oE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 094/135] ice: fix potential infinite loop because loop counter being too small
Date:   Tue,  3 Dec 2019 23:35:34 +0100
Message-Id: <20191203213037.340554510@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 615457a226f042bffc3a1532afb244cab37460d4 ]

Currently the for-loop counter i is a u8 however it is being checked
against a maximum value hw->num_tx_sched_layers which is a u16. Hence
there is a potential wrap-around of counter i back to zero if
hw->num_tx_sched_layers is greater than 255.  Fix this by making i
a u16.

Addresses-Coverity: ("Infinite loop")
Fixes: b36c598c999c ("ice: Updates to Tx scheduler code")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 2a232504379d2..602b0fd84c29e 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1052,7 +1052,7 @@ enum ice_status ice_sched_query_res_alloc(struct ice_hw *hw)
 	struct ice_aqc_query_txsched_res_resp *buf;
 	enum ice_status status = 0;
 	__le16 max_sibl;
-	u8 i;
+	u16 i;
 
 	if (hw->layer_info)
 		return status;
-- 
2.20.1



