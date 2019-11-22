Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B65D2106F42
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbfKVKxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:38232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730217AbfKVKxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:53:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2582220715;
        Fri, 22 Nov 2019 10:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420012;
        bh=AIoefMBkzTyQpQDx+wHLCeWHS00qU4UIZRBzUd3m66k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lCKmDqtJrPJCjByM6IZSKdgR5ZUZRiGX4QPrhSV6XjuOTxvJKfn23fUyJ7K2shRWu
         7+GstTg+l2VxwPSO7w7Ke1fILyvnmTUkO4pJ0+P/kiUJ0eg5YRYTf5JakLK51JamKH
         y9EALBcn7AwqATlLXtoBph2WMydjlE/2FPSMPTjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/122] iwlwifi: mvm: dont send keys when entering D3
Date:   Fri, 22 Nov 2019 11:28:59 +0100
Message-Id: <20191122100825.938795873@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
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
index b205a7bfb828d..65c51c6983288 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -947,8 +947,10 @@ int iwl_mvm_wowlan_config_key_params(struct iwl_mvm *mvm,
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



