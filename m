Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D87E1A40E6
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 06:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDJDqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726082AbgDJDqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:46:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59F4620BED;
        Fri, 10 Apr 2020 03:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490400;
        bh=veCBmgdRybGO47FNkFF3zVpn19J+P2jgtZGRswXSyFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grMnufgF/5rJDnhlgTHbr6X8mVDtQE+5ejGB+douOLT9mqr5UWg9DLkMMXwx9Yy7i
         xnZp8bIkODz64Mn9eIFNduUe2GfW/z+VX9LWrRZIPCTFRCeb+hi8nDPV/y9ttPQ/uT
         JcIZpXpAPxxAzUMVQtqo/yTWO+4FhHRz/YAt5Y6k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ajay Singh <ajay.kathat@microchip.com>,
        kbuild test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 5.6 04/68] staging: wilc1000: avoid double unlocking of 'wilc->hif_cs' mutex
Date:   Thu,  9 Apr 2020 23:45:29 -0400
Message-Id: <20200410034634.7731-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034634.7731-1-sashal@kernel.org>
References: <20200410034634.7731-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

[ Upstream commit 6c411581caef6e3b2c286871641018364c6db50a ]

Possible double unlocking of 'wilc->hif_cs' mutex was identified by
smatch [1]. Removed the extra call to release_bus() in
wilc_wlan_handle_txq() which was missed in earlier commit fdc2ac1aafc6
("staging: wilc1000: support suspend/resume functionality").

[1]. https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/NOEVW7C3GV74EWXJO3XX6VT2NKVB2HMT/

Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Link: https://lore.kernel.org/r/20200221170120.15739-1-ajay.kathat@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wilc1000/wlan.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wlan.c b/drivers/staging/wilc1000/wlan.c
index 601e4d1345d24..05b8adfe001da 100644
--- a/drivers/staging/wilc1000/wlan.c
+++ b/drivers/staging/wilc1000/wlan.c
@@ -572,7 +572,6 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 				entries = ((reg >> 3) & 0x3f);
 				break;
 			}
-			release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
 		} while (--timeout);
 		if (timeout <= 0) {
 			ret = func->hif_write_reg(wilc, WILC_HOST_VMM_CTL, 0x0);
-- 
2.20.1

