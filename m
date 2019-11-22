Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 222B8106FEC
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728945AbfKVLTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729857AbfKVKsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:48:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B1EA205C9;
        Fri, 22 Nov 2019 10:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419691;
        bh=oIuPZIKjSWr+B1tN15q/Yf7G/jszH9poscu1Os74aYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUYE0PYq09GvhVrny52V2G0PRA9njF1heneCsikPVHVvp2XSEHKS3AC7IDwEmmaLX
         6ciPyh5tLpKDpl09aqXcgxGh878etf86u/W1SmkThQpNj8UAUuHB3LWmvn5KY7VRk3
         jsxNawZA1UIA1YZNbi3Y9RDGpECJgD4jPjuYSQBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 198/222] iwlwifi: mvm: dont send keys when entering D3
Date:   Fri, 22 Nov 2019 11:28:58 +0100
Message-Id: <20191122100916.524397942@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 8c7fd6a365eb5b2647b2c01918730d0a485b9f85 ]

In the past, we needed to program the keys when entering D3. This was
since we replaced the image. However, now that there is a single
image, this is no longer needed.  Note that RSC is sent separately in
a new command.  This solves issues with newer devices that support PN
offload. Since driver re-sent the keys, the PN got zeroed and the
receiver dropped the next packets, until PN caught up again.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 207d8ae1e1160..19052efe53f12 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -935,8 +935,10 @@ int iwl_mvm_wowlan_config_key_params(struct iwl_mvm *mvm,
 {
 	struct iwl_wowlan_kek_kck_material_cmd kek_kck_cmd = {};
 	struct iwl_wowlan_tkip_params_cmd tkip_cmd = {};
+	bool unified = fw_has_capa(&mvm->fw->ucode_capa,
+				   IWL_UCODE_TLV_CAPA_CNSLDTD_D3_D0_IMG);
 	struct wowlan_key_data key_data = {
-		.configure_keys = !d0i3,
+		.configure_keys = !d0i3 && !unified,
 		.use_rsc_tsc = false,
 		.tkip = &tkip_cmd,
 		.use_tkip = false,
-- 
2.20.1



