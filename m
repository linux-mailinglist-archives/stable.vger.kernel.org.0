Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47F635BF53
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238345AbhDLJED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:04:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238639AbhDLJCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:02:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3D036124C;
        Mon, 12 Apr 2021 09:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218030;
        bh=yjcgSVbPV9yPz4BnHuFpjepjGUIL73RsTudylucoQKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ooZ4dpdqXCFns+5w7JZXFlQBmvkhHgPOnwMhF5vKgHt9Xalq4U5U4I3WC12N5d9BJ
         anB4ZW9Z3LX3iHdgspIyRPmgDTN+UZ5MSAWiPELvmzoDr1Eq8vfU0mTYRe8JCDSFGE
         i2XrzeLYYJmNnm4iWMIdIPtkzQhvcgcHKvr8A8hk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Ertman <david.m.ertman@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.11 044/210] ice: remove DCBNL_DEVRESET bit from PF state
Date:   Mon, 12 Apr 2021 10:39:09 +0200
Message-Id: <20210412084017.482234356@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Ertman <david.m.ertman@intel.com>

commit 741b7b743bbcb5a3848e4e55982064214f900d2f upstream.

The original purpose of the ICE_DCBNL_DEVRESET was to protect
the driver during DCBNL device resets.  But, the flow for
DCBNL device resets now consists of only calls up the stack
such as dev_close() and dev_open() that will result in NDO calls
to the driver.  These will be handled with state changes from the
stack.  Also, there is a problem of the dev_close and dev_open
being blocked by checks for reset in progress also using the
ICE_DCBNL_DEVRESET bit.

Since the ICE_DCBNL_DEVRESET bit is not necessary for protecting
the driver from DCBNL device resets and it is actually blocking
changes coming from the DCBNL interface, remove the bit from the
PF state and don't block driver function based on DCBNL reset in
progress.

Fixes: b94b013eb626 ("ice: Implement DCBNL support")
Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice.h        |    1 -
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c |    2 --
 drivers/net/ethernet/intel/ice/ice_lib.c    |    1 -
 3 files changed, 4 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -194,7 +194,6 @@ enum ice_state {
 	__ICE_NEEDS_RESTART,
 	__ICE_PREPARED_FOR_RESET,	/* set by driver when prepared */
 	__ICE_RESET_OICR_RECV,		/* set by driver after rcv reset OICR */
-	__ICE_DCBNL_DEVRESET,		/* set by dcbnl devreset */
 	__ICE_PFR_REQ,			/* set by driver and peers */
 	__ICE_CORER_REQ,		/* set by driver and peers */
 	__ICE_GLOBR_REQ,		/* set by driver and peers */
--- a/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb_nl.c
@@ -18,12 +18,10 @@ static void ice_dcbnl_devreset(struct ne
 	while (ice_is_reset_in_progress(pf->state))
 		usleep_range(1000, 2000);
 
-	set_bit(__ICE_DCBNL_DEVRESET, pf->state);
 	dev_close(netdev);
 	netdev_state_change(netdev);
 	dev_open(netdev, NULL);
 	netdev_state_change(netdev);
-	clear_bit(__ICE_DCBNL_DEVRESET, pf->state);
 }
 
 /**
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2944,7 +2944,6 @@ err_vsi:
 bool ice_is_reset_in_progress(unsigned long *state)
 {
 	return test_bit(__ICE_RESET_OICR_RECV, state) ||
-	       test_bit(__ICE_DCBNL_DEVRESET, state) ||
 	       test_bit(__ICE_PFR_REQ, state) ||
 	       test_bit(__ICE_CORER_REQ, state) ||
 	       test_bit(__ICE_GLOBR_REQ, state);


