Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19D345C275
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345348AbhKXN3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:29:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349008AbhKXN1I (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:27:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90BA161B96;
        Wed, 24 Nov 2021 12:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758225;
        bh=4RiHdufeqRe2/PWGm6XyNLAsMoyonUedGo1hqfYFHBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XG+Chv11kmc6QlTO9BD8MXkwtlBBSBMQj3nxKrMiO6Jz0D4DkG9lhyLfBQf2cTDEY
         icdHBpv87a60eWdvuWSDuhnds8ZckcSILzqqVF2zv67+9iJCwRUlCzcbcEvZVLSSyf
         3sy9+RbHTE7Hvausy2hTSO9lw1KQ/X2KM+AJjJoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 098/100] ice: Delete always true check of PF pointer
Date:   Wed, 24 Nov 2021 12:58:54 +0100
Message-Id: <20211124115658.022579383@linuxfoundation.org>
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
@@ -3005,9 +3005,6 @@ static void ice_remove(struct pci_dev *p
 	struct ice_pf *pf = pci_get_drvdata(pdev);
 	int i;
 
-	if (!pf)
-		return;
-
 	for (i = 0; i < ICE_MAX_RESET_WAIT; i++) {
 		if (!ice_is_reset_in_progress(pf->state))
 			break;


