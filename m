Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33DC45C1F7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348257AbhKXNYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:24:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346868AbhKXNWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6006361350;
        Wed, 24 Nov 2021 12:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758066;
        bh=CtJbkrHOKXmZiYYoEm+bjfcT8DYXwruiNCqFSv9VEgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brIrk1A7cKK7RHiF5fy4rChZ7XZblwcLyWyzLc5xN8J/Vpk38Y2t2e1CKWmLIile3
         jlCaV2bjc0ohUeQYFX0qMfSu64LiLBpKq8jcU5O8inU5rLigWm3VRz24Q78XB6I66d
         POMfAFRfd8Rpv9comeM8fid8KtK20l89oJlKpDjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Marczak <piotr.marczak@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 050/100] iavf: Fix failure to exit out from last all-multicast mode
Date:   Wed, 24 Nov 2021 12:58:06 +0100
Message-Id: <20211124115656.505224142@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Marczak <piotr.marczak@intel.com>

[ Upstream commit 8905072a192fffe9389255489db250c73ecab008 ]

The driver could only quit allmulti when allmulti and promisc modes are
turn on at the same time. If promisc had been off there was no way to turn
off allmulti mode.
The patch corrects this behavior. Switching allmulti does not depends on
promisc state mode anymore

Fixes: f42a5c74da99 ("i40e: Add allmulti support for the VF")
Signed-off-by: Piotr Marczak <piotr.marczak@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index c7e365267bc0f..43afe887cac9e 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1626,8 +1626,7 @@ static int iavf_process_aq_command(struct iavf_adapter *adapter)
 		iavf_set_promiscuous(adapter, FLAG_VF_MULTICAST_PROMISC);
 		return 0;
 	}
-
-	if ((adapter->aq_required & IAVF_FLAG_AQ_RELEASE_PROMISC) &&
+	if ((adapter->aq_required & IAVF_FLAG_AQ_RELEASE_PROMISC) ||
 	    (adapter->aq_required & IAVF_FLAG_AQ_RELEASE_ALLMULTI)) {
 		iavf_set_promiscuous(adapter, 0);
 		return 0;
-- 
2.33.0



