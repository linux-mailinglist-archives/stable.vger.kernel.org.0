Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947102B601E
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbgKQNGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:06:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:60770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728524AbgKQNGc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:06:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FD03238E6;
        Tue, 17 Nov 2020 13:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618391;
        bh=XZgKa9sLT+bkLqnqpU2cXilc5PX73Yer78389k18gC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yMpQ52FejGXqQVIHRDiwnDIKpF7owUAHWxsQ2Lzt5BnFlSwKgHIyDUSDPxNxCrxAQ
         BCI01OAT/F5Ss+CgGuize0rT/HxuRAViVR4xjuQLqLeCf147E90lC89vmzW9guvv/Z
         CvuCxD8UDhViUHDu0yKK9qxfSQ3s9Nnao4OI7ggs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martyna Szapar <martyna.szapar@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 17/64] i40e: Fix of memory leak and integer truncation in i40e_virtchnl.c
Date:   Tue, 17 Nov 2020 14:04:40 +0100
Message-Id: <20201117122106.976231505@linuxfoundation.org>
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

From: Martyna Szapar <martyna.szapar@intel.com>

commit 24474f2709af6729b9b1da1c5e160ab62e25e3a4 upstream.

Fixed possible memory leak in i40e_vc_add_cloud_filter function:
cfilter is being allocated and in some error conditions
the function returns without freeing the memory.

Fix of integer truncation from u16 (type of queue_id value) to u8
when calling i40e_vc_isvalid_queue_id function.

Signed-off-by: Martyna Szapar <martyna.szapar@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
[bwh: Backported to 4.4: i40e_vc_add_cloud_filter() does not exist
 but the integer truncation is still possible]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 18e10357f1d0b..b4b4d46da1734 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -188,7 +188,7 @@ static inline bool i40e_vc_isvalid_vsi_id(struct i40e_vf *vf, u16 vsi_id)
  * check for the valid queue id
  **/
 static inline bool i40e_vc_isvalid_queue_id(struct i40e_vf *vf, u16 vsi_id,
-					    u8 qid)
+					    u16 qid)
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = i40e_find_vsi_from_id(pf, vsi_id);
-- 
2.27.0



