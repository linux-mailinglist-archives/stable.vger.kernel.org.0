Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 304294891CE
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234014AbiAJHgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41618 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240870AbiAJHdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:33:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B88E160F81;
        Mon, 10 Jan 2022 07:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F81FC36AED;
        Mon, 10 Jan 2022 07:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799983;
        bh=tR1ZCEsYQm4fvpxkqSSPTZVCnW2ChIeMjEFgxVTo3YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9O4qFHbNPPpMwvaPj+EjXo1T+jPJO4wzmBWRAoBjwvQzVLPzU4MCbAPZpOrEgfX7
         lKyufhmANdsr5mLiNpi3WQVGs4a9WMuPj+IEnp8gOZDJmg+EhJ+U5YWuas82sejA7e
         oKv0nl6OhrsFrhZuJkdzgCU5jxxr20n0lCEHAJwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ashwin Vijayavel <ashwin.vijayavel@intel.com>,
        Karen Sornek <karen.sornek@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 08/72] iavf: Fix limit of total number of queues to active queues of VF
Date:   Mon, 10 Jan 2022 08:22:45 +0100
Message-Id: <20220110071821.797177803@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

commit b712941c8085e638bb92456e866ed3de4404e3d5 upstream.

In the absence of this validation, if the user requests to
configure queues more than the enabled queues, it results in
sending the requested number of queues to the kernel stack
(due to the asynchronous nature of VF response), in which
case the stack might pick a queue to transmit that is not
enabled and result in Tx hang. Fix this bug by
limiting the total number of queues allocated for VF to
active queues of VF.

Fixes: d5b33d024496 ("i40evf: add ndo_setup_tc callback to i40evf")
Signed-off-by: Ashwin Vijayavel <ashwin.vijayavel@intel.com>
Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2652,8 +2652,11 @@ static int iavf_validate_ch_config(struc
 		total_max_rate += tx_rate;
 		num_qps += mqprio_qopt->qopt.count[i];
 	}
-	if (num_qps > IAVF_MAX_REQ_QUEUES)
+	if (num_qps > adapter->num_active_queues) {
+		dev_err(&adapter->pdev->dev,
+			"Cannot support requested number of queues\n");
 		return -EINVAL;
+	}
 
 	ret = iavf_validate_tx_bandwidth(adapter, total_max_rate);
 	return ret;


