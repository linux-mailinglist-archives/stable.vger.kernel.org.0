Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1244726B8
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbhLMJyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:54:05 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42600 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237633AbhLMJvm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:51:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4880ECE0E86;
        Mon, 13 Dec 2021 09:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20F5C00446;
        Mon, 13 Dec 2021 09:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389099;
        bh=fXR2igRIPaMZ/u1LUJxUYkheQ7XdH1H0uGeN/3Vs8pE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2DszApeKCIjNUb6cFmBof3AIWnj5Qa9P0f6rCLtYGUXYvjifYB79N/WJlrvvjjT2
         Hoda514pVPls1hMLJvhtJg5bumC2NJHy0E92BU3KYBwFImGnzlV///sSIMMXDhbBMJ
         P+XR2CU6jE3I9NgZvRHXmyYo6bE/zil/aDymdFUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Bindushree P <Bindushree.p@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 085/132] i40e: Fix pre-set max number of queues for VF
Date:   Mon, 13 Dec 2021 10:30:26 +0100
Message-Id: <20211213092942.033154090@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

commit 8aa55ab422d9d0d825ebfb877702ed661e96e682 upstream.

After setting pre-set combined to 16 queues and reserving 16 queues by
tc qdisc, pre-set maximum combined queues returned to default value
after VF reset being 4 and this generated errors during removing tc.
Fixed by removing clear num_req_queues before reset VF.

Fixes: e284fc280473 (i40e: Add and delete cloud filter)
Signed-off-by: Grzegorz Szczurek <grzegorzx.szczurek@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Bindushree P <Bindushree.p@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -3787,11 +3787,6 @@ static int i40e_vc_add_qch_msg(struct i4
 
 	/* set this flag only after making sure all inputs are sane */
 	vf->adq_enabled = true;
-	/* num_req_queues is set when user changes number of queues via ethtool
-	 * and this causes issue for default VSI(which depends on this variable)
-	 * when ADq is enabled, hence reset it.
-	 */
-	vf->num_req_queues = 0;
 
 	/* reset the VF in order to allocate resources */
 	i40e_vc_reset_vf(vf, true);


