Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8191328A74
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239593AbhCASRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:17:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238926AbhCASJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:09:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E60864FB8;
        Mon,  1 Mar 2021 17:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620273;
        bh=9sZS/BHALgHGCvTiRHKD/68pHAa3uwu5mh7Yxiit5FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lp0oUt0lU5ZxfhnfISgOWjUXltZO+JFOOPs/0JK8Ffih9sZxGoa2z+6yAkMo3D1X3
         3oNFnQBRqArj7YUHZQyYdNZfxaZl9J1VtQIb3qtqluTjWkQxaQ924BiPmgHM6PL3Vo
         2Y7QjylgO8XWjjw/7J/vgtwH6egXmFGyYQFKNr4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 093/775] iwlwifi: mvm: dont check if CSA event is running before removing
Date:   Mon,  1 Mar 2021 17:04:21 +0100
Message-Id: <20210301161206.275280204@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 4e1bdf13e5e71..0b012f8c9eb22 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -999,9 +999,6 @@ void iwl_mvm_remove_csa_period(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	if (!te_data->running)
-		return;
-
 	spin_lock_bh(&mvm->time_event_lock);
 	id = te_data->id;
 	spin_unlock_bh(&mvm->time_event_lock);
-- 
2.27.0



