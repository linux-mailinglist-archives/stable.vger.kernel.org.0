Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30A94373A78
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhEEMKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:53700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233593AbhEEMJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:09:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C000613C4;
        Wed,  5 May 2021 12:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216541;
        bh=v0L3Lwn8MNJzGQuluKTNQb+gCZiYjptZe+pQAEEAOII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0dnpHIM1lvTXzeg7EdHZtG8rhzzLGdzFzT2wsjhsWJ5EQJZhn6iMMPIy06jx8LAE
         ZCQISrPVTLXBN/JtSCCvrZjUHF0iL9hKLNSQ7PrXtMVLIgerb3z6BOF1AbLhaEjNdE
         kNKvUwZShJS9hPZ/F7k/R8BdVK8oq0LZw2/kjIWA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Lowe <nick.lowe@gmail.com>,
        David Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.11 05/31] igb: Enable RSS for Intel I211 Ethernet Controller
Date:   Wed,  5 May 2021 14:05:54 +0200
Message-Id: <20210505112326.847597709@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
References: <20210505112326.672439569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Lowe <nick.lowe@gmail.com>

commit 6e6026f2dd2005844fb35c3911e8083c09952c6c upstream.

The Intel I211 Ethernet Controller supports 2 Receive Side Scaling (RSS)
queues. It should not be excluded from having this feature enabled.

Via commit c883de9fd787 ("igb: rename igb define to be more generic")
E1000_MRQC_ENABLE_RSS_4Q was renamed to E1000_MRQC_ENABLE_RSS_MQ to
indicate that this is a generic bit flag to enable queues and not
a flag that is specific to devices that support 4 queues

The bit flag enables 2, 4 or 8 queues appropriately depending on the part.

Tested with a multicore CPU and frames were then distributed as expected.

This issue appears to have been introduced because of confusion caused
by the prior name.

Signed-off-by: Nick Lowe <nick.lowe@gmail.com>
Tested-by: David Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4482,8 +4482,7 @@ static void igb_setup_mrqc(struct igb_ad
 		else
 			mrqc |= E1000_MRQC_ENABLE_VMDQ;
 	} else {
-		if (hw->mac.type != e1000_i211)
-			mrqc |= E1000_MRQC_ENABLE_RSS_MQ;
+		mrqc |= E1000_MRQC_ENABLE_RSS_MQ;
 	}
 	igb_vmm_control(adapter);
 


