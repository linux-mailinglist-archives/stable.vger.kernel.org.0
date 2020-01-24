Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9B80147AEC
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731634AbgAXJj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:39:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731650AbgAXJj0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:39:26 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6B262070A;
        Fri, 24 Jan 2020 09:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858766;
        bh=ByzrQ0XKL20qdgX7okrxaHNwoOEa8K1TGk4AHtUPjzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWivkt/QFydxSGrADTXgcPG6d11nYKEXad/SJ5AT/6FQ9Z/BAKAPMV/PRYON1c5He
         YQ8SYxWcRd7PvAeYxOxNl/le0tLjISbT5fNanKLzD5Ct7V6pQrTcrEjxJVENBrzOb2
         TZXUE4IvP0S+aMnsRxfT/+NB5pNzuoQBDUrklLg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 5.4 034/102] ice: fix stack leakage
Date:   Fri, 24 Jan 2020 10:30:35 +0100
Message-Id: <20200124092811.402830222@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

commit 949375de945f7042df2b6488228a1a2b36e69f35 upstream.

In the case of an invalid virtchannel request the driver
would return uninitialized data to the VF from the PF stack
which is a bug.  Fix by initializing the stack variable
earlier in the function before any return paths can be taken.

Fixes: 1071a8358a28 ("ice: Implement virtchnl commands for AVF support")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -1873,8 +1873,8 @@ static int ice_vc_get_stats_msg(struct i
 	enum virtchnl_status_code v_ret = VIRTCHNL_STATUS_SUCCESS;
 	struct virtchnl_queue_select *vqs =
 		(struct virtchnl_queue_select *)msg;
+	struct ice_eth_stats stats = { 0 };
 	struct ice_pf *pf = vf->pf;
-	struct ice_eth_stats stats;
 	struct ice_vsi *vsi;
 
 	if (!test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states)) {
@@ -1893,7 +1893,6 @@ static int ice_vc_get_stats_msg(struct i
 		goto error_param;
 	}
 
-	memset(&stats, 0, sizeof(struct ice_eth_stats));
 	ice_update_eth_stats(vsi);
 
 	stats = vsi->eth_stats;


