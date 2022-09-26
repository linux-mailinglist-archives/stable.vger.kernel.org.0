Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4193E5EA454
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbiIZLpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238536AbiIZLno (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:43:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38C872ED4;
        Mon, 26 Sep 2022 03:46:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F06DB80881;
        Mon, 26 Sep 2022 10:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01322C433C1;
        Mon, 26 Sep 2022 10:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189171;
        bh=Sm780qRk8F+ZTcd1ZBEChuYNOc8jrNgphySWx4jsQeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAMBuTX5GovGadW9Pd5JaW0zdki8nFbG/kOile2PGNfKTFAhtz0UvKs23Mx9p7gml
         QhmTHlEOHQBJA2VGyoA23O+JVH4CxL9oYl7hBPHa4R+CB/nxW+ZHHTGpVDxcG346Nb
         dXP5gh/2gm5jDksvMrtFRnfzWMA1qF7dnvFfAdh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 095/207] wifi: iwlwifi: Mark IWLMEI as broken
Date:   Mon, 26 Sep 2022 12:11:24 +0200
Message-Id: <20220926100810.858005608@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 8997f5c8a62760db69fd5c56116705796322c8ed ]

The iwlmei driver breaks iwlwifi when returning from suspend. The interface
ends up in the 'down' state after coming back from suspend. And iwd doesn't
touch the interface state, but wpa_supplicant does, so the bug only happens on
iwd.

The bug report[0] has been open for four months now, and no fix seems to be
forthcoming. Since just disabling the iwlmei driver works as a workaround,
let's mark the config option as broken until it can be fixed properly.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=215937

Fixes: 2da4366f9e2c ("iwlwifi: mei: add the driver to allow cooperation with CSME")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Acked-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220907134450.1183045-1-toke@toke.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index a647a406b87b..b20409f8c13a 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -140,6 +140,7 @@ config IWLMEI
 	depends on INTEL_MEI
 	depends on PM
 	depends on CFG80211
+	depends on BROKEN
 	help
 	  Enables the iwlmei kernel module.
 
-- 
2.35.1



