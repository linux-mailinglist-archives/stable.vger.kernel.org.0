Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5CF6171D79
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389680AbgB0ORW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:17:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389204AbgB0ORR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:17:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 638342469D;
        Thu, 27 Feb 2020 14:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813036;
        bh=bJ0SkaoT0tHBLaUk3sTig7xfYiyECBhloF/CD+tvZBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0bmWzKhCz+HKipp1vd4nS3T3R7rbLTv67siHF2+fxJgaQ/TKBY+UUOpGWkgk0M5l
         1DKCyX6EVwngt7Si8Yjpc8aQSLCurZ3x6cE85FIXlFKzjULWKEwtJOvQsRvOW/y/J0
         QaG4tcTsIUFsmstJQjLKSpL+HCzV5PNOFW3InC1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 5.5 113/150] ice: Remove possible null dereference
Date:   Thu, 27 Feb 2020 14:37:30 +0100
Message-Id: <20200227132249.447765879@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Nguyen <anthony.l.nguyen@intel.com>

commit 0a6ea04e3bbd20833d2b49296e5adc1c5bb86386 upstream.

Commit 1f45ebe0d8fb ("ice: add extra check for null Rx descriptor") moved
the call to ice_construct_skb() under a null check as Coverity reported a
possible use of null skb. However, the original call was not deleted, do so
now.

Fixes: 1f45ebe0d8fb ("ice: add extra check for null Rx descriptor")
Reported-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/ice/ice_txrx.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -1078,8 +1078,6 @@ construct_skb:
 				skb = ice_build_skb(rx_ring, rx_buf, &xdp);
 			else
 				skb = ice_construct_skb(rx_ring, rx_buf, &xdp);
-		} else {
-			skb = ice_construct_skb(rx_ring, rx_buf, &xdp);
 		}
 		/* exit if we failed to retrieve a buffer */
 		if (!skb) {


