Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BE245B61C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 09:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240954AbhKXIFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 03:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232944AbhKXIFV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 03:05:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B80A460F5B;
        Wed, 24 Nov 2021 08:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637740932;
        bh=Tgw1j0bKBU46R0N+y4UsfnueloH7qSGEg1cXU32x6sg=;
        h=Subject:To:Cc:From:Date:From;
        b=a9Q62cz+cDm5FOVJj4w9cF9vtWhxyIB0xUS86WbobOdXcdQXwwwpc86WgpR4DoeY5
         duylxgcb4toVupm9B7VzHon790fsk/t9gMx8PSprlos+cgEDdMibqrQ7ZPLCIgzsmd
         iCHRp3upfP0KWzFAlCBmwzEVCWoU33r3Urh/FTE4=
Subject: FAILED: patch "[PATCH] ice: Delete always true check of PF pointer" failed to apply to 4.19-stable tree
To:     leon@kernel.org, davem@davemloft.net, leonro@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Nov 2021 09:02:09 +0100
Message-ID: <163774092990192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2ff04286a9569675948f39cec2c6ad47c3584633 Mon Sep 17 00:00:00 2001
From: Leon Romanovsky <leon@kernel.org>
Date: Thu, 23 Sep 2021 21:12:52 +0300
Subject: [PATCH] ice: Delete always true check of PF pointer

PF pointer is always valid when PCI core calls its .shutdown() and
.remove() callbacks. There is no need to check it again.

Fixes: 837f08fdecbe ("ice: Add basic driver framework for Intel(R) E800 Series")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 34e64533026a..aacc0b345bbe 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4593,9 +4593,6 @@ static void ice_remove(struct pci_dev *pdev)
 	struct ice_pf *pf = pci_get_drvdata(pdev);
 	int i;
 
-	if (!pf)
-		return;
-
 	for (i = 0; i < ICE_MAX_RESET_WAIT; i++) {
 		if (!ice_is_reset_in_progress(pf->state))
 			break;

