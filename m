Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99143CA955
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241478AbhGOTGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:06:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242684AbhGOTFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:05:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4045613D3;
        Thu, 15 Jul 2021 19:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375694;
        bh=+eZ0yTPFBqX/+7MawF+ewYY+p2odJue09D667njTbPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRQtgBJXAryQmftQufTkfrf0/LErJbgMh7363VzmH0t5uEGLqicqOVa4Xn9lUDMma
         EAkwb1DcAZeNUfTxMGTNIzMKuGr8ntQZYOeBp1Ws3ysusTWvDBV1GM/xddED8CerGc
         KXO+Ucblslv3RCDCSzux8hx7ELyEl1C0JggRgS4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Sergeev <asergeev@carbonrobotics.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.12 195/242] i40e: fix PTP on 5Gb links
Date:   Thu, 15 Jul 2021 20:39:17 +0200
Message-Id: <20210715182627.545843558@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

commit 26b0ce8dd3dd704393dbace4dc416adfeffe531f upstream.

As reported by Alex Sergeev, the i40e driver is incrementing the PTP
clock at 40Gb speeds when linked at 5Gb. Fix this bug by making
sure that the right multiplier is selected when linked at 5Gb.

Fixes: 3dbdd6c2f70a ("i40e: Add support for 5Gbps cards")
Cc: stable@vger.kernel.org
Reported-by: Alex Sergeev <asergeev@carbonrobotics.com>
Suggested-by: Alex Sergeev <asergeev@carbonrobotics.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/i40e/i40e_ptp.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_ptp.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ptp.c
@@ -11,13 +11,14 @@
  * operate with the nanosecond field directly without fear of overflow.
  *
  * Much like the 82599, the update period is dependent upon the link speed:
- * At 40Gb link or no link, the period is 1.6ns.
- * At 10Gb link, the period is multiplied by 2. (3.2ns)
+ * At 40Gb, 25Gb, or no link, the period is 1.6ns.
+ * At 10Gb or 5Gb link, the period is multiplied by 2. (3.2ns)
  * At 1Gb link, the period is multiplied by 20. (32ns)
  * 1588 functionality is not supported at 100Mbps.
  */
 #define I40E_PTP_40GB_INCVAL		0x0199999999ULL
 #define I40E_PTP_10GB_INCVAL_MULT	2
+#define I40E_PTP_5GB_INCVAL_MULT	2
 #define I40E_PTP_1GB_INCVAL_MULT	20
 
 #define I40E_PRTTSYN_CTL1_TSYNTYPE_V1  BIT(I40E_PRTTSYN_CTL1_TSYNTYPE_SHIFT)
@@ -465,6 +466,9 @@ void i40e_ptp_set_increment(struct i40e_
 	case I40E_LINK_SPEED_10GB:
 		mult = I40E_PTP_10GB_INCVAL_MULT;
 		break;
+	case I40E_LINK_SPEED_5GB:
+		mult = I40E_PTP_5GB_INCVAL_MULT;
+		break;
 	case I40E_LINK_SPEED_1GB:
 		mult = I40E_PTP_1GB_INCVAL_MULT;
 		break;


