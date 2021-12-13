Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1072472923
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241814AbhLMKSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbhLMKO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:14:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81298C08ED49;
        Mon, 13 Dec 2021 01:54:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07B26B80E26;
        Mon, 13 Dec 2021 09:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73346C34602;
        Mon, 13 Dec 2021 09:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389289;
        bh=2p/i4birDKezTK2Hbqca235vLaZKRYYJaWqL109d7J4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cuz0kiiNwLGqHw9wJP5082SrPbIhpfAh/2lPSOw+XQwQs61yik4+RvJLqLfbFhRVJ
         NZsBOoat1rTS/ru1n5Dj1tMoIhzWNB07Vy8l5oZOjDS94JFhgr7fVucq2OH3r0vxxR
         PxIus2apu0rvTOQB7MG383SeMT8lQidzTQPhcN2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mitch Williams <mitch.a.williams@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 048/171] iavf: restore MSI state on reset
Date:   Mon, 13 Dec 2021 10:29:23 +0100
Message-Id: <20211213092946.695761736@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mitch Williams <mitch.a.williams@intel.com>

commit 7e4dcc13965c57869684d57a1dc6dd7be589488c upstream.

If the PF experiences an FLR, the VF's MSI and MSI-X configuration will
be conveniently and silently removed in the process. When this happens,
reset recovery will appear to complete normally but no traffic will
pass. The netdev watchdog will helpfully notify everyone of this issue.

To prevent such public embarrassment, restore MSI configuration at every
reset. For normal resets, this will do no harm, but for VF resets
resulting from a PF FLR, this will keep the VF working.

Fixes: 5eae00c57f5e ("i40evf: main driver core")
Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2199,6 +2199,7 @@ static void iavf_reset_task(struct work_
 	}
 
 	pci_set_master(adapter->pdev);
+	pci_restore_msi_state(adapter->pdev);
 
 	if (i == IAVF_RESET_WAIT_COMPLETE_COUNT) {
 		dev_err(&adapter->pdev->dev, "Reset never finished (%x)\n",


