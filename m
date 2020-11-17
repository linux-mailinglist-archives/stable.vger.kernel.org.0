Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A918C2B601C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgKQNG2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:06:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:60724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728524AbgKQNG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:06:28 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEE03221EB;
        Tue, 17 Nov 2020 13:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618388;
        bh=MddSLBYcbaXtP9P+b3qIDkLK+VFb0iuT65m/hjZqtdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q+U1f9H46Y01wgBSsxa000vSQLKGP6wgV0BV378cWYzvqoMf2bIixDVfGSALH09B1
         SeTnaFH5abW3y6oSko7o+3n6jSJ6ai6rO4AycwBAK0ZhpBB9eCLQ5+yJlOGYVY4/OB
         tw1pcJBvf2tV1W9DlMZxFc5k9cIdIu37Lh+fbsZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grzegorz Siwik <grzegorz.siwik@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 16/64] i40e: Wrong truncation from u16 to u8
Date:   Tue, 17 Nov 2020 14:04:39 +0100
Message-Id: <20201117122106.934343679@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Siwik <grzegorz.siwik@intel.com>

commit c004804dceee9ca384d97d9857ea2e2795c2651d upstream.

In this patch fixed wrong truncation method from u16 to u8 during
validation.

It was changed by changing u8 to u32 parameter in method declaration
and arguments were changed to u32.

Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index cdb263875efb3..18e10357f1d0b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -203,7 +203,7 @@ static inline bool i40e_vc_isvalid_queue_id(struct i40e_vf *vf, u16 vsi_id,
  *
  * check for the valid vector id
  **/
-static inline bool i40e_vc_isvalid_vector_id(struct i40e_vf *vf, u8 vector_id)
+static inline bool i40e_vc_isvalid_vector_id(struct i40e_vf *vf, u32 vector_id)
 {
 	struct i40e_pf *pf = vf->pf;
 
-- 
2.27.0



