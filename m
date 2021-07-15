Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7E913CAA67
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242577AbhGOTNJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:13:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244165AbhGOTKm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:10:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0036C601FE;
        Thu, 15 Jul 2021 19:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376068;
        bh=jm0JWmxGcpKQuILz7gY4zT/faOtsrR7J5SxL68SHXzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6uf6nVTveoAor14++dQ1/N1lm7J4c2WwM0N7T/iwHm3zXbwK7mJXfdoB/+n+SAR7
         diqm1KUXfij30qPNoWCI8V/dGt/2cxV++9kaFjgZgAbE6RFTyqsSLtclxeRlxYoP20
         IQp+eUkJh0Td5F6QQDHunCOVWhwGG6hNRacdbBhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 111/266] ice: fix incorrect payload indicator on PTYPE
Date:   Thu, 15 Jul 2021 20:37:46 +0200
Message-Id: <20210715182633.485461100@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 638a0c8c8861cb8a3b54203e632ea5dcc23d8ca5 ]

The entry for PTYPE 90 indicates that the payload is layer 3. This does
not match the specification in the datasheet which indicates the packet
is a MAC, IPv6, UDP packet, with a payload in layer 4.

Fix the lookup table to match the data sheet.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
index 21329ed3087e..fc3b56c13786 100644
--- a/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
+++ b/drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h
@@ -744,7 +744,7 @@ static const struct ice_rx_ptype_decoded ice_ptype_lkup[] = {
 	/* Non Tunneled IPv6 */
 	ICE_PTT(88, IP, IPV6, FRG, NONE, NONE, NOF, NONE, PAY3),
 	ICE_PTT(89, IP, IPV6, NOF, NONE, NONE, NOF, NONE, PAY3),
-	ICE_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY3),
+	ICE_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY4),
 	ICE_PTT_UNUSED_ENTRY(91),
 	ICE_PTT(92, IP, IPV6, NOF, NONE, NONE, NOF, TCP,  PAY4),
 	ICE_PTT(93, IP, IPV6, NOF, NONE, NONE, NOF, SCTP, PAY4),
-- 
2.30.2



