Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 392B0328A01
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238890AbhCASJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:09:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238981AbhCASCm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:02:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCDEE6516D;
        Mon,  1 Mar 2021 17:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618450;
        bh=eno8TBR3dVmtsb0SKpcXuy0w+BazzcextpK+WyGdDYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KWImB/0XuRjFVJnch0RBM7jjZ6DotIrABJ/atfQCqh9JocvCxHAHrCOjElBsAT8b
         m2u8Ph47KEQc9Vgy64ltYIjl/WKQ7cahETFToWS41tv27Q55lzBB86zyNduWS46CIK
         FWMB2W9QenhYc6eBm/QwJaZd46xryO65i8Qa09H0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/663] iwlwifi: mvm: dont check if CSA event is running before removing
Date:   Mon,  1 Mar 2021 17:05:39 +0100
Message-Id: <20210301161146.229466725@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit b8a86164454aa745ecb534d7477d50d440ea05b6 ]

We may want to remove it before it started (i.e. before the
actual switch time).

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Fixes: 58ddd9b6d194 ("iwlwifi: mvm: don't send a CSA command the firmware doesn't know")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210210171218.835db8987b8a.Ic6c5d28d744302db1bc6c4314bd3138ba472f834@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 1db6d8d38822a..3939eccd3d5ac 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -1055,9 +1055,6 @@ void iwl_mvm_remove_csa_period(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (!te_data->running)
-		return;
-
 	spin_lock_bh(&mvm->time_event_lock);
 	id = te_data->id;
 	spin_unlock_bh(&mvm->time_event_lock);
-- 
2.27.0



