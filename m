Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139642F7981
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387980AbhAOMh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:37:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387959AbhAOMh0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A07D207C4;
        Fri, 15 Jan 2021 12:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714231;
        bh=eMJwKpa0bJnF8vt7pd700QRe790C5p5wZsTNaF13/Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=09FG7DAsTo5n/94D9wx/dPV6fB3bkUyN5aUZeh+bXwtPPonrD8OvElAJB2x3LS7rQ
         Nw50HmritLgG1UweW5hDZo1gcEIBfmd545xwcflwq/eq8VHuT6xt3rY+ZvlZg5gMqu
         nnr2MlrS0RT/fV1GvLe3gEI2EEMY3wi7k65s8bvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 043/103] net: dsa: lantiq_gswip: Exclude RMII from modes that report 1 GbE
Date:   Fri, 15 Jan 2021 13:27:36 +0100
Message-Id: <20210115122008.141653968@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 3545454c7801e391b0d966f82c98614d45394770 ]

Exclude RMII from modes that report 1 GbE support. Reduced MII supports
up to 100 MbE.

Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20210107195818.3878-1-olek2@wp.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/lantiq_gswip.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1436,11 +1436,12 @@ static void gswip_phylink_validate(struc
 	phylink_set(mask, Pause);
 	phylink_set(mask, Asym_Pause);
 
-	/* With the exclusion of MII and Reverse MII, we support Gigabit,
-	 * including Half duplex
+	/* With the exclusion of MII, Reverse MII and Reduced MII, we
+	 * support Gigabit, including Half duplex
 	 */
 	if (state->interface != PHY_INTERFACE_MODE_MII &&
-	    state->interface != PHY_INTERFACE_MODE_REVMII) {
+	    state->interface != PHY_INTERFACE_MODE_REVMII &&
+	    state->interface != PHY_INTERFACE_MODE_RMII) {
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseT_Half);
 	}


