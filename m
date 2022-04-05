Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2DC4F2B00
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242317AbiDEIhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238341AbiDEISw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:18:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE24D68;
        Tue,  5 Apr 2022 01:08:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0EA6B81B90;
        Tue,  5 Apr 2022 08:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03935C385A1;
        Tue,  5 Apr 2022 08:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146118;
        bh=sQjWN0L8ZliOSDC5PB74ERNUxAish/045NCKzjPfV5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a0vGTsEfNKY7X0MHk13+dZnAZsxm297gl0/rKoneVZy5jg7szPLfJpMJZCXQTkKF/
         d2bJ5lVPXAU3UThSnVYuDPlfNgh741xBLnEj6J4VZHmA7ZPNzQiXkIAs54q1KTj3/r
         N5fYyDn3jMjnOAUt1ych1evfBQqJOhgUsi3HG7h8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0649/1126] iwlwifi: pcie: fix SW error MSI-X mapping
Date:   Tue,  5 Apr 2022 09:23:16 +0200
Message-Id: <20220405070426.680343058@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7b9f485091a5755f6e0a7dd3725f3b312768ecd0 ]

We need to also update the IVAR location, since we've shifted
the bit.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: 571836a02c7b ("iwlwifi: pcie: update sw error interrupt for BZ family")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220304131517.bcfb28484e50.I921df6b5134785d7eeb0c934e4a43157c582fa79@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index ef14584fc0a1..4b08eb46617c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1112,7 +1112,7 @@ static const struct iwl_causes_list causes_list_pre_bz[] = {
 };
 
 static const struct iwl_causes_list causes_list_bz[] = {
-	{MSIX_HW_INT_CAUSES_REG_SW_ERR_BZ,	CSR_MSIX_HW_INT_MASK_AD, 0x29},
+	{MSIX_HW_INT_CAUSES_REG_SW_ERR_BZ,	CSR_MSIX_HW_INT_MASK_AD, 0x15},
 };
 
 static void iwl_pcie_map_list(struct iwl_trans *trans,
-- 
2.34.1



