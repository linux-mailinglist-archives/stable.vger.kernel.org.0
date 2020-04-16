Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34151ACB98
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442658AbgDPPtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:49:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896677AbgDPNdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:33:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8BA121D91;
        Thu, 16 Apr 2020 13:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043976;
        bh=qs75tEfOs2fCsYk39M8OgekZWGozE5twqSR4yC7eBIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpAw3kK1vP2/nHZjqZcIPsaPXQol8wldS6KCmGqR9jnPbEhsuB3V5FU2NmM9rhJwf
         7hCACqCxxyft+N056i9jGf+VvAAqsBc7vAo+KbJFmDLeF2dHsPh+FkUY9mf9oNPKQe
         CYvx3Wtcv6XIrvGtBmJ8Mdz6RL2m9bF6x1WHaK34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 005/257] iwlwifi: mvm: take the required lock when clearing time event data
Date:   Thu, 16 Apr 2020 15:20:56 +0200
Message-Id: <20200416131326.567948201@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 089e5016d7eb063712063670e6da7c1a4de1a5c1 ]

When receiving a session protection end notification, the time event
data is cleared without holding the required lock. Fix it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200306151128.a49846a634e4.Id1ada7c5a964f5e25f4d0eacc2c4b050015b46a2@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index c0b420fe5e48f..1babc4bb5194b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -785,7 +785,9 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 		if (!le32_to_cpu(notif->status)) {
 			iwl_mvm_te_check_disconnect(mvm, vif,
 						    "Session protection failure");
+			spin_lock_bh(&mvm->time_event_lock);
 			iwl_mvm_te_clear_data(mvm, te_data);
+			spin_unlock_bh(&mvm->time_event_lock);
 		}
 
 		if (le32_to_cpu(notif->start)) {
@@ -801,7 +803,9 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 			 */
 			iwl_mvm_te_check_disconnect(mvm, vif,
 						    "No beacon heard and the session protection is over already...");
+			spin_lock_bh(&mvm->time_event_lock);
 			iwl_mvm_te_clear_data(mvm, te_data);
+			spin_unlock_bh(&mvm->time_event_lock);
 		}
 
 		goto out_unlock;
-- 
2.20.1



