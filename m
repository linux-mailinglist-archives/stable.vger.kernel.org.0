Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F4635BF71
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238984AbhDLJG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239145AbhDLJCb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AC6A61019;
        Mon, 12 Apr 2021 09:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218079;
        bh=5cGtune326pDnmup4L3lsuh2PnaryyaDAp9ti+EcXnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zSWn+Q0Gc3tpG2ppL5lkgWJlNJ5PgawEPUrjaLgyzCtZOd9U3iR/ArFzve/x2rlSp
         GP0xtH1irmo/YIe7SQaOW2jRZfwZIF6Z0j8chfmIganLIdwMDZA/q6RSo+//Y4108q
         5G7ateuZy5w501u1mq8s1tP1xAVa8nFEijVtcNu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.11 064/210] i40e: Fix sparse error: vsi->netdev could be null
Date:   Mon, 12 Apr 2021 10:39:29 +0200
Message-Id: <20210412084018.134380081@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

commit 6b5674fe6b9bf05394886ebcec62b2d7dae88c42 upstream.

Remove vsi->netdev->name from the trace.
This is redundant information. With the devinfo trace, the adapter
is already identifiable.

Previously following error was produced when compiling against sparse.
i40e_main.c:2571 i40e_sync_vsi_filters() error:
	we previously assumed 'vsi->netdev' could be null (see line 2323)

Fixes: b603f9dc20af ("i40e: Log info when PF is entering and leaving Allmulti mode.")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2560,8 +2560,7 @@ int i40e_sync_vsi_filters(struct i40e_vs
 				 i40e_stat_str(hw, aq_ret),
 				 i40e_aq_str(hw, hw->aq.asq_last_status));
 		} else {
-			dev_info(&pf->pdev->dev, "%s is %s allmulti mode.\n",
-				 vsi->netdev->name,
+			dev_info(&pf->pdev->dev, "%s allmulti mode.\n",
 				 cur_multipromisc ? "entering" : "leaving");
 		}
 	}


