Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6913CA771
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240509AbhGOSx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239672AbhGOSx0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:53:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3C84613D8;
        Thu, 15 Jul 2021 18:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375032;
        bh=3Fs+gAv7AGiLCzxSOVAnIumXX4vXQB1F0+AeoQ2SAyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vOfEHWSOUpj1AUsZfV2zI8BksI+eUjwrE4sQirPdx7lfkjHHeT30wdl8Rz4sBGvek
         4qNMSYrtcB+tyO6+RiwvvAVKjDAxBDecTdkV7OZAmV1UOEEqyxhDeRj6/CzhnVfWjg
         7O7vq3NHSz2x+UQDGnb9diBJX+1wEDCzI5AksIlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/215] iwlwifi: mvm: fix error print when session protection ends
Date:   Thu, 15 Jul 2021 20:37:55 +0200
Message-Id: <20210715182617.544953488@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaul Triebitz <shaul.triebitz@intel.com>

[ Upstream commit 976ac0af7ba2c5424bc305b926c0807d96fdcc83 ]

When the session protection ends and the Driver is not
associated or a beacon was not heard, the Driver
prints "No beacons heard...".
That's confusing for the case where not associated.
Change the print when not associated to "Not associated...".

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210617100544.41a5a5a894fa.I9eabb76e7a3a7f4abbed8f2ef918f1df8e825726@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 3939eccd3d5a..394598b14a17 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -345,6 +345,8 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 			 * and know the dtim period.
 			 */
 			iwl_mvm_te_check_disconnect(mvm, te_data->vif,
+				!te_data->vif->bss_conf.assoc ?
+				"Not associated and the time event is over already..." :
 				"No beacon heard and the time event is over already...");
 			break;
 		default:
@@ -843,6 +845,8 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 			 * and know the dtim period.
 			 */
 			iwl_mvm_te_check_disconnect(mvm, vif,
+						    !vif->bss_conf.assoc ?
+						    "Not associated and the session protection is over already..." :
 						    "No beacon heard and the session protection is over already...");
 			spin_lock_bh(&mvm->time_event_lock);
 			iwl_mvm_te_clear_data(mvm, te_data);
-- 
2.30.2



