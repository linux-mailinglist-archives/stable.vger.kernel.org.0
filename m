Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED944FD8F2
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377045AbiDLHrN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357214AbiDLHjw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721581571B;
        Tue, 12 Apr 2022 00:13:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 194ACB81B46;
        Tue, 12 Apr 2022 07:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B102C385A5;
        Tue, 12 Apr 2022 07:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747627;
        bh=ljsjBHnVqmoW3KTJKR7AJNY4q6I3EsUNpYuZ6eKN6FU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcPpoDGYzukfKFH3eWz6BsOVxGqVe6TUAOxIHYY0GIQ+AxMkdqqTUBKVCG3J2uax4
         DpIpyXPuVQ5MEwRqgqQl5l+L50u9jCcVYxG3vA17IC0N4VC+vkebjxH2Cx4yVY+v1g
         FmlTfay+zbFgvXKe/iqrYmEjTfTAGnUDPheqI5YQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Emmanuel Grumbach <Emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 146/343] iwlwifi: mei: fix building iwlmei
Date:   Tue, 12 Apr 2022 08:29:24 +0200
Message-Id: <20220412062955.595930684@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 066291bec0c55315e568ead501bebdefcb8453d2 ]

Building iwlmei without CONFIG_CFG80211 causes a link-time warning:

ld.lld: error: undefined symbol: ieee80211_hdrlen
>>> referenced by net.c
>>>               net/wireless/intel/iwlwifi/mei/net.o:(iwl_mei_tx_copy_to_csme) in archive drivers/built-in.a

Add an explicit dependency to avoid this. In theory it should not
be needed here, but it also seems pointless to allow IWLMEI
for configurations without CFG80211.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Emmanuel Grumbach <Emmanuel.grumbach@intel.com>
Acked-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220316183617.1470631-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 85e704283755..a647a406b87b 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -139,6 +139,7 @@ config IWLMEI
 	tristate "Intel Management Engine communication over WLAN"
 	depends on INTEL_MEI
 	depends on PM
+	depends on CFG80211
 	help
 	  Enables the iwlmei kernel module.
 
-- 
2.35.1



