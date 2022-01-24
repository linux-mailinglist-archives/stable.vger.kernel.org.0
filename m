Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EF849A3EB
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369155AbiAYABG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1847009AbiAXXSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:18:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB7AC06F8D2;
        Mon, 24 Jan 2022 13:26:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7346B811A2;
        Mon, 24 Jan 2022 21:26:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9057C340E4;
        Mon, 24 Jan 2022 21:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059566;
        bh=+ssm34GG7w4RratDitFIfpR8USrSyhcfbr2ppoi86JE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=in+3hX30x2c0aTleor+8lXsVwU+HNLlG4ZAAr4XyqXyoxJvHz7QAuGwNGkBZRhzhe
         d90JhDGO9cT0ydqs3GCtWpDAKNIPUVz5nE0KZqRDTlvy75dHXbW5UcO0bNLEGo1R5M
         zhMDrwA6G1Cezf4s4TlErCkUXyYkQz+/c3bwvYdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0626/1039] iwlwifi: acpi: fix wgds rev 3 size
Date:   Mon, 24 Jan 2022 19:40:15 +0100
Message-Id: <20220124184146.379991845@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit dc276ffd0754e94080565c10b964f3c211879fdd ]

The exact size of WGDS revision 3 was calculated using the wrong
parameters. Fix it.

Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211204130722.12c5b0cffe52.I7f342502f628f43a7e000189a699484bcef0f562@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
index bf431fa4fe81f..2e4590876bc33 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/acpi.c
@@ -789,7 +789,7 @@ int iwl_sar_get_wgds_table(struct iwl_fw_runtime *fwrt)
 				 * looking up in ACPI
 				 */
 				if (wifi_pkg->package.count !=
-				    min_size + profile_size * num_profiles) {
+				    hdr_size + profile_size * num_profiles) {
 					ret = -EINVAL;
 					goto out_free;
 				}
-- 
2.34.1



