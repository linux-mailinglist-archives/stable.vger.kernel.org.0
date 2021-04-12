Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D64B35BD0F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbhDLIrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237810AbhDLIq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:46:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 590466124C;
        Mon, 12 Apr 2021 08:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217171;
        bh=T9KzrbxyndIAxlb1orgHX2l18UXo5UDeB3JibSMLvWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jYYkThPxKggzp2nfLMEuqmhNcer0IsCPZa7rFmzelHwFeq/Sy0616gb8Ze2VBb46P
         Iiywb9m4bAQjlOqTYTFuWekAlvN99k+gnNNL+n4Kus3SUBfJiRqKKMGuMcxb+cpvfv
         P1+c/l7QWUWQTKNRiONPZ7+Cy3svl/pztLS8T1lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 030/111] i40e: Fix sparse error: vsi->netdev could be null
Date:   Mon, 12 Apr 2021 10:40:08 +0200
Message-Id: <20210412084005.233952731@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
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
@@ -2547,8 +2547,7 @@ int i40e_sync_vsi_filters(struct i40e_vs
 				 i40e_stat_str(hw, aq_ret),
 				 i40e_aq_str(hw, hw->aq.asq_last_status));
 		} else {
-			dev_info(&pf->pdev->dev, "%s is %s allmulti mode.\n",
-				 vsi->netdev->name,
+			dev_info(&pf->pdev->dev, "%s allmulti mode.\n",
 				 cur_multipromisc ? "entering" : "leaving");
 		}
 	}


