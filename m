Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22D2499151
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379053AbiAXUKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:10:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44306 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347497AbiAXT6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:58:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91783B80FA1;
        Mon, 24 Jan 2022 19:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC051C340E5;
        Mon, 24 Jan 2022 19:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054317;
        bh=9Df3ZJ+2b4VOrSeXn0WahFNQGHuymqCiY1adXrjqDfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AijO7NF/AVB/IWqp5HTh0IwZnGmnsmELso+sUzQ0F7mvE2UaGtrm1ciOYAdJ8d/Tc
         IJ4txUkQPGAcHL2EMnQKOusgcSUOSGO+cxcHFagitBXul3KqXDbiX7CRotXnaI3Ur/
         927CSLflZv1HCwPW4cPxQxr/8ek+tvI5wa4+voBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 348/563] iwlwifi: mvm: avoid clearing a just saved session protection id
Date:   Mon, 24 Jan 2022 19:41:53 +0100
Message-Id: <20220124184036.441853434@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index a633ad5f8ca4e..3f081cdea09ca 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -1166,15 +1166,10 @@ void iwl_mvm_schedule_session_protection(struct iwl_mvm *mvm,
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
@@ -1188,6 +1183,11 @@ void iwl_mvm_schedule_session_protection(struct iwl_mvm *mvm,
 	}
 
 	iwl_mvm_te_clear_data(mvm, te_data);
+	/*
+	 * The time_event_data.id field is reused to save session
+	 * protection's configuration.
+	 */
+	te_data->id = le32_to_cpu(cmd.conf_id);
 	te_data->duration = le32_to_cpu(cmd.duration_tu);
 	spin_unlock_bh(&mvm->time_event_lock);
 
-- 
2.34.1



