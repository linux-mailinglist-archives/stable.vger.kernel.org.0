Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79472586971
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbiHAMCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbiHAMBu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:01:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D23DF9;
        Mon,  1 Aug 2022 04:53:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDCA261227;
        Mon,  1 Aug 2022 11:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C926BC433D6;
        Mon,  1 Aug 2022 11:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354828;
        bh=TiAgG5vUFmtICBTTOC+Ytzwf4hKXz4NMEgmV2/gbwfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w/OtOFnTQ5wxO5OiRUwXw3zfbGjNb1/r+aiHvOQpg6uq7OHRg3/g+8TDtT8PBjgGP
         J8TnFCgeEi+Bx+N6WFjT1U0oHTd0eDvzI5N1myqHDp5jL+G8kex2qjf3VJL6mHuDiv
         s6GLbK1lVqZo9GPxKzAeagei7hinJRM4zjaK+6eY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 34/69] net: pcs: xpcs: propagate xpcs_read error to xpcs_get_state_c37_sgmii
Date:   Mon,  1 Aug 2022 13:46:58 +0200
Message-Id: <20220801114135.896348934@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 27161db0904ee48e59140aa8d0835939a666c1f1 ]

While phylink_pcs_ops :: pcs_get_state does return void, xpcs_get_state()
does check for a non-zero return code from xpcs_get_state_c37_sgmii()
and prints that as a message to the kernel log.

However, a non-zero return code from xpcs_read() is translated into
"return false" (i.e. zero as int) and the I/O error is therefore not
printed. Fix that.

Fixes: b97b5331b8ab ("net: pcs: add C37 SGMII AN support for intel mGbE controller")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220720112057.3504398-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-xpcs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 7de631f5356f..fd4cbf8a55ad 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -890,7 +890,7 @@ static int xpcs_get_state_c37_sgmii(struct dw_xpcs *xpcs,
 	 */
 	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_INTR_STS);
 	if (ret < 0)
-		return false;
+		return ret;
 
 	if (ret & DW_VR_MII_C37_ANSGM_SP_LNKSTS) {
 		int speed_value;
-- 
2.35.1



