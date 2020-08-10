Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570EE240948
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgHJPa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:30:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728622AbgHJPa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:30:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7B4420791;
        Mon, 10 Aug 2020 15:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073457;
        bh=unHX8a/jW92snIToUjOuWFq1WAuVmtWd2MRdQGFa8oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1GEB97nba/qdnhQEoPNdjOy7C8hurtAd0OxT7mPTURA6uKSvebKIPreZqYor931m8
         ddWR1xeWUVwFaiqx8W8DFqniV6IRd4RcA0j/H9XWXQ6mF+LiaeOYdjDYyldcIZw9V5
         eTZDlhHAHuCQION008IiXD/mMfR+sLsB6JIOxVII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grzegorz Siwik <grzegorz.siwik@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH 4.19 45/48] i40e: Wrong truncation from u16 to u8
Date:   Mon, 10 Aug 2020 17:22:07 +0200
Message-Id: <20200810151806.435542438@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
References: <20200810151804.199494191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Siwik <grzegorz.siwik@intel.com>

[ Upstream commit c004804dceee9ca384d97d9857ea2e2795c2651d ]

In this patch fixed wrong truncation method from u16 to u8 during
validation.

It was changed by changing u8 to u32 parameter in method declaration
and arguments were changed to u32.

Fixes: 5c3c48ac6bf56 ("i40e: implement virtual device interface")
Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -196,7 +196,7 @@ static inline bool i40e_vc_isvalid_queue
  *
  * check for the valid vector id
  **/
-static inline bool i40e_vc_isvalid_vector_id(struct i40e_vf *vf, u8 vector_id)
+static inline bool i40e_vc_isvalid_vector_id(struct i40e_vf *vf, u32 vector_id)
 {
 	struct i40e_pf *pf = vf->pf;
 


