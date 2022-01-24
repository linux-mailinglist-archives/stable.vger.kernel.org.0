Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730B1499C13
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577203AbiAXV7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458030AbiAXVzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:55:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF27C07E2A1;
        Mon, 24 Jan 2022 12:36:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4048FB8121A;
        Mon, 24 Jan 2022 20:36:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E370C340E5;
        Mon, 24 Jan 2022 20:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056580;
        bh=c7/XBWzsaYmWU+H2uCUZADGkTpa6wfvO5HYwbEXPfCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKKDyrGbG/6rAXWwEProfEBcWSqwbMLW7zzAOwlRo7YNh8RqORu92RTU9I9KxXh+d
         6m4t6Rq8S+6rbN4S+YTZw/v5K/ElzTJuD4ncNjIsKqiSL4GfqMTsjessE3BuoCiWxj
         36byYMG2C19s2KaXWAueMgLmyJNTJDtiYx92uutY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 531/846] iwlwifi: mvm: avoid clearing a just saved session protection id
Date:   Mon, 24 Jan 2022 19:40:48 +0100
Message-Id: <20220124184119.319040568@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

[ Upstream commit 8e967c137df3b236d2075f9538cb888129425d1a ]

When scheduling a session protection the id is saved but
then it may be cleared when calling iwl_mvm_te_clear_data
(if a previous session protection is currently active).
Fix it by saving the id after calling iwl_mvm_te_clear_data.

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211204130722.b0743a588d14.I098fef6677d0dab3ef1b6183ed206a10bab01eb2@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index f93f15357a3f8..b8c645b9880fc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -1167,15 +1167,10 @@ void iwl_mvm_schedule_session_protection(struct iwl_mvm *mvm,
 			cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id,
 							mvmvif->color)),
 		.action = cpu_to_le32(FW_CTXT_ACTION_ADD),
+		.conf_id = cpu_to_le32(SESSION_PROTECT_CONF_ASSOC),
 		.duration_tu = cpu_to_le32(MSEC_TO_TU(duration)),
 	};
 
-	/* The time_event_data.id field is reused to save session
-	 * protection's configuration.
-	 */
-	mvmvif->time_event_data.id = SESSION_PROTECT_CONF_ASSOC;
-	cmd.conf_id = cpu_to_le32(mvmvif->time_event_data.id);
-
 	lockdep_assert_held(&mvm->mutex);
 
 	spin_lock_bh(&mvm->time_event_lock);
@@ -1189,6 +1184,11 @@ void iwl_mvm_schedule_session_protection(struct iwl_mvm *mvm,
 	}
 
 	iwl_mvm_te_clear_data(mvm, te_data);
+	/*
+	 * The time_event_data.id field is reused to save session
+	 * protection's configuration.
+	 */
+	te_data->id = le32_to_cpu(cmd.conf_id);
 	te_data->duration = le32_to_cpu(cmd.duration_tu);
 	te_data->vif = vif;
 	spin_unlock_bh(&mvm->time_event_lock);
-- 
2.34.1



