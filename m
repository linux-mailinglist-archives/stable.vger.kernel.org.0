Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34738B5D28
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfIRGWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbfIRGW1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:22:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E95B218AE;
        Wed, 18 Sep 2019 06:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787746;
        bh=xCYf6H3BZ4UqZg17dDZOqY8hskqn5G7eCavzPOr6A7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PtJ5uvn5Saig9S2MPc411/6Nl2sxa4DfRPHUlcyHVGvxwKO8RaNA5aalPY2n5eXrZ
         Vki0DD8XPk82XpFrGPBFojYw2k7L5nsUmg/MntkNKOMLpkFFSZ5tW3feCkPQJ9hGQ1
         nuKc9Gc/axWzXx3gPPOTD7k4QrM+JwibJOdwhmPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gregg Leventhal <gleventhal@janestreet.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 4.19 19/50] ixgbe: Prevent u8 wrapping of ITR value to something less than 10us
Date:   Wed, 18 Sep 2019 08:19:02 +0200
Message-Id: <20190918061225.140090286@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061223.116178343@linuxfoundation.org>
References: <20190918061223.116178343@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

commit 377228accbbb8b9738f615d791aa803f41c067e0 upstream.

There were a couple cases where the ITR value generated via the adaptive
ITR scheme could exceed 126. This resulted in the value becoming either 0
or something less than 10. Switching back and forth between a value less
than 10 and a value greater than 10 can cause issues as certain hardware
features such as RSC to not function well when the ITR value has dropped
that low.

CC: stable@vger.kernel.org
Fixes: b4ded8327fea ("ixgbe: Update adaptive ITR algorithm")
Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -2626,7 +2626,7 @@ adjust_by_size:
 		/* 16K ints/sec to 9.2K ints/sec */
 		avg_wire_size *= 15;
 		avg_wire_size += 11452;
-	} else if (avg_wire_size <= 1980) {
+	} else if (avg_wire_size < 1968) {
 		/* 9.2K ints/sec to 8K ints/sec */
 		avg_wire_size *= 5;
 		avg_wire_size += 22420;
@@ -2659,6 +2659,8 @@ adjust_by_size:
 	case IXGBE_LINK_SPEED_2_5GB_FULL:
 	case IXGBE_LINK_SPEED_1GB_FULL:
 	case IXGBE_LINK_SPEED_10_FULL:
+		if (avg_wire_size > 8064)
+			avg_wire_size = 8064;
 		itr += DIV_ROUND_UP(avg_wire_size,
 				    IXGBE_ITR_ADAPTIVE_MIN_INC * 64) *
 		       IXGBE_ITR_ADAPTIVE_MIN_INC;


