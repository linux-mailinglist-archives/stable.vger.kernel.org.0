Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D4D2F1455
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbhAKNXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:23:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:35610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733123AbhAKNSc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF75722AAF;
        Mon, 11 Jan 2021 13:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371097;
        bh=BoLImqZ9D+UGGOAjz9LpCYxBKJCMOQ+alHIwZKDypyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGdppj66LdOktBHvfnlStOhGszp9pGKXtyPhyfB+d8RVZzzBdWt+03JLhtjLRUsY2
         EpDvxqR/Bfu63ILvvivhTzsx+yxDshAOola0HtMvw4Qh10jwtF2aWEiixQCfiOF+vu
         uHt4nxqygd6pJM85FlqZLcNbY/BkazGlWL633JSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 141/145] dmaengine: idxd: off by one in cleanup code
Date:   Mon, 11 Jan 2021 14:02:45 +0100
Message-Id: <20210111130055.284556966@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit ff58f7dd0c1352a01de3a40327895bd51e03de3a upstream.

The clean up is off by one so this will start at "i" and it should start
with "i - 1" and then it doesn't unregister the zeroeth elements in the
array.

Fixes: c52ca478233c ("dmaengine: idxd: add configuration component of driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/X9nFeojulsNqUSnG@mwanda
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/idxd/sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -379,7 +379,7 @@ int idxd_register_driver(void)
 	return 0;
 
 drv_fail:
-	for (; i > 0; i--)
+	while (--i >= 0)
 		driver_unregister(&idxd_drvs[i]->drv);
 	return rc;
 }
@@ -1639,7 +1639,7 @@ int idxd_register_bus_type(void)
 	return 0;
 
 bus_err:
-	for (; i > 0; i--)
+	while (--i >= 0)
 		bus_unregister(idxd_bus_types[i]);
 	return rc;
 }


