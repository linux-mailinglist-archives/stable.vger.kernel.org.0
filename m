Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E808945C683
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 15:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352335AbhKXOKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:10:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354168AbhKXOGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 09:06:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AABB61221;
        Wed, 24 Nov 2021 13:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759541;
        bh=nwjCONIEpUExpZ0pnCiWDEIlC/hFUCq//2m/jOtaYpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7QHkVWI3c2IMKeKpS33zh/KFoTMrNYeiT1sQDHiX1GBZASbSeH/qEvSLU1J5782s
         R/JlEuG7LzBYlDw1OlTbPZxs0pItqlOMY0t6JcGMzZPB68MU1RaDVTpB3Us6hNfboF
         /Xuape+ycCQ+jinizgC1PAd5YjTur4MDdLzpeU3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 275/279] ice: Delete always true check of PF pointer
Date:   Wed, 24 Nov 2021 12:59:22 +0100
Message-Id: <20211124115728.193401129@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

commit 2ff04286a9569675948f39cec2c6ad47c3584633 upstream.

PF pointer is always valid when PCI core calls its .shutdown() and
.remove() callbacks. There is no need to check it again.

Fixes: 837f08fdecbe ("ice: Add basic driver framework for Intel(R) E800 Series")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4600,9 +4600,6 @@ static void ice_remove(struct pci_dev *p
 	struct ice_pf *pf = pci_get_drvdata(pdev);
 	int i;
 
-	if (!pf)
-		return;
-
 	for (i = 0; i < ICE_MAX_RESET_WAIT; i++) {
 		if (!ice_is_reset_in_progress(pf->state))
 			break;


