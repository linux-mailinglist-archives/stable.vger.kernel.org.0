Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E608489164
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239965AbiAJHbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:31:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38908 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240274AbiAJH3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:29:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A7F4611B6;
        Mon, 10 Jan 2022 07:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D00C36AE9;
        Mon, 10 Jan 2022 07:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799786;
        bh=pRaENRlRFEDP/WHMvW5FiYnPh5Euy4mEOHWYmBFTZ1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=adePLct6yebrUDz6L+bFQpQpB8mz99KzJWzE2mUfiozEnDKFCWzQ7Faz+HQ/voHxU
         3BHev4uWrk1dA98vxM6cMLWuD3zfKgUvXY+M6Df1WrvI0/5okrSUfT4eMy2ST5b8t7
         UOVbPfnMwpVgnkKvzNMYu+S98HsEYSxdK71zcMR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 14/43] i40e: Fix for displaying message regarding NVM version
Date:   Mon, 10 Jan 2022 08:23:11 +0100
Message-Id: <20220110071817.827523691@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Palczewski <mateusz.palczewski@intel.com>

commit 40feded8a247f95957a0de9abd100085fb320a2f upstream.

When loading the i40e driver, it prints a message like: 'The driver for the
device detected a newer version of the NVM image v1.x than expected v1.y.
Please install the most recent version of the network driver.' This is
misleading as the driver is working as expected.

Fix that by removing the second part of message and changing it from
dev_info to dev_dbg.

Fixes: 4fb29bddb57f ("i40e: The driver now prints the API version in error message")
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14987,8 +14987,8 @@ static int i40e_probe(struct pci_dev *pd
 
 	if (hw->aq.api_maj_ver == I40E_FW_API_VERSION_MAJOR &&
 	    hw->aq.api_min_ver > I40E_FW_MINOR_VERSION(hw))
-		dev_info(&pdev->dev,
-			 "The driver for the device detected a newer version of the NVM image v%u.%u than expected v%u.%u. Please install the most recent version of the network driver.\n",
+		dev_dbg(&pdev->dev,
+			"The driver for the device detected a newer version of the NVM image v%u.%u than v%u.%u.\n",
 			 hw->aq.api_maj_ver,
 			 hw->aq.api_min_ver,
 			 I40E_FW_API_VERSION_MAJOR,


