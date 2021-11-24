Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B490845BC34
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242728AbhKXM0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:26:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245200AbhKXMYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:24:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 452EA6120F;
        Wed, 24 Nov 2021 12:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756129;
        bh=uD7QM3zZ1ifDv+fKhirBA3ejrGhIoMshuO/jRiOTJ/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNj3AuZIEKT3AJKgG3E6Gc5PLvoHMYtanSmo2HqX1bhT701KjoHJlJyz1+A7VZ4pX
         SOD9VNcY2hPXetp7eZtvXLCiAtDooFYwHp+03NWtb6eqL6Ynzqpg3eO9o91jsnbAO+
         VkrrB4WzL4O1hdoSXu3Uyxic2E+Dk7IWgS+2fh4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Surabhi Boob <surabhi.boob@intel.com>,
        Tony Brelinski <tony.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 182/207] iavf: Fix for the false positive ASQ/ARQ errors while issuing VF reset
Date:   Wed, 24 Nov 2021 12:57:33 +0100
Message-Id: <20211124115709.864978440@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Surabhi Boob <surabhi.boob@intel.com>

[ Upstream commit 321421b57a12e933f92b228e0e6d0b2c6541f41d ]

While issuing VF Reset from the guest OS, the VF driver prints
logs about critical / Overflow error detection. This is not an
actual error since the VF_MBX_ARQLEN register is set to all FF's
for a short period of time and the VF would catch the bits set if
it was reading the register during that spike of time.
This patch introduces an additional check to ignore this condition
since the VF is in reset.

Fixes: 19b73d8efaa4 ("i40evf: Add additional check for reset")
Signed-off-by: Surabhi Boob <surabhi.boob@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40evf/i40evf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40evf/i40evf_main.c b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
index 537776a3e5de1..9ba36425a3ddd 100644
--- a/drivers/net/ethernet/intel/i40evf/i40evf_main.c
+++ b/drivers/net/ethernet/intel/i40evf/i40evf_main.c
@@ -1889,7 +1889,7 @@ static void i40evf_adminq_task(struct work_struct *work)
 
 	/* check for error indications */
 	val = rd32(hw, hw->aq.arq.len);
-	if (val == 0xdeadbeef) /* indicates device in reset */
+	if (val == 0xdeadbeef || val == 0xffffffff) /* device in reset */
 		goto freedom;
 	oldval = val;
 	if (val & I40E_VF_ARQLEN1_ARQVFE_MASK) {
-- 
2.33.0



