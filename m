Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF1864F3309
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242973AbiDEJil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243481AbiDEJI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:08:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7401DB6E46;
        Tue,  5 Apr 2022 01:58:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F273361562;
        Tue,  5 Apr 2022 08:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5A0C385A0;
        Tue,  5 Apr 2022 08:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149089;
        bh=lre0W96EM7EblNvH8Ij16KE8LDCrkMoFLKWR5QotJtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgWyYH93HFSIEFlKBR2q8hp9wOdXhBMGkUdurBi02YRWkK6ohvyT2/utOfE6VkdMc
         G9aMqYeuihTqz4z6oNS/FqBX+ej9YLRZqyFNEssRfKumy6A2CtNE2VZ8K2sxWxuXm5
         EAXbpy7EIHYfoaHblYljwqot+dn2AlwGa4pdfUzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0588/1017] iwlwifi: pcie: fix SW error MSI-X mapping
Date:   Tue,  5 Apr 2022 09:25:01 +0200
Message-Id: <20220405070411.733093280@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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
index 3b38c426575b..39cd7dfea78f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1084,7 +1084,7 @@ static const struct iwl_causes_list causes_list_pre_bz[] = {
 };
 
 static const struct iwl_causes_list causes_list_bz[] = {
-	{MSIX_HW_INT_CAUSES_REG_SW_ERR_BZ,	CSR_MSIX_HW_INT_MASK_AD, 0x29},
+	{MSIX_HW_INT_CAUSES_REG_SW_ERR_BZ,	CSR_MSIX_HW_INT_MASK_AD, 0x15},
 };
 
 static void iwl_pcie_map_list(struct iwl_trans *trans,
-- 
2.34.1



