Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2515F472629
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhLMJtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59116 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235993AbhLMJpk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:45:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65563B80E1C;
        Mon, 13 Dec 2021 09:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF53C00446;
        Mon, 13 Dec 2021 09:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388738;
        bh=EX82P4phzSTVRbumpbv9eKWA9wIaFZQWBL2Dltr1tqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7f95CqpF1HQcBTQVdxroMMGYIsutm8HsUW5HPHzhktd5QWaM3T3mZA/SrAiCEvzU
         KxzNhEjgqDQmC1K1gnGq7F3paOis1loL79UjCOH0jUlbRgLP2D2j03b2F6CEhyhwWP
         Smsham0u6kdkHNGxMloaiF2Nc9jKqSeraoP/7VII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Bindushree P <Bindushree.p@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 53/88] i40e: Fix pre-set max number of queues for VF
Date:   Mon, 13 Dec 2021 10:30:23 +0100
Message-Id: <20211213092935.100005693@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
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
@@ -3713,11 +3713,6 @@ static int i40e_vc_add_qch_msg(struct i4
 
 	/* set this flag only after making sure all inputs are sane */
 	vf->adq_enabled = true;
-	/* num_req_queues is set when user changes number of queues via ethtool
-	 * and this causes issue for default VSI(which depends on this variable)
-	 * when ADq is enabled, hence reset it.
-	 */
-	vf->num_req_queues = 0;
 
 	/* reset the VF in order to allocate resources */
 	i40e_vc_notify_vf_reset(vf);


