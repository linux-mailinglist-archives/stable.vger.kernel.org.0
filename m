Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55C335BE03
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237928AbhDLI42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:44694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238709AbhDLIya (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:54:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EBF761358;
        Mon, 12 Apr 2021 08:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217558;
        bh=5cGtune326pDnmup4L3lsuh2PnaryyaDAp9ti+EcXnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTUxxijcAOiVKnlfNSfMJ309yWxEUPQ+nVmgXzR6TG9fgmt9Yz+A0eosNQy7Lq3aO
         JJoWNfn+iyk98R6T3kcJ13f2deMrM/WG/IvPxXHif/8cIcOekDQkMAX73mSfFMD2U5
         9Z/TEQUmoJp3u0V1kBaiEqn4HDfRDzLqbupSBbbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 057/188] i40e: Fix sparse error: vsi->netdev could be null
Date:   Mon, 12 Apr 2021 10:39:31 +0200
Message-Id: <20210412084015.544471134@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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


