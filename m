Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD9611BCAB6
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgD1SfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:35:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729668AbgD1SfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:35:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D4F32085B;
        Tue, 28 Apr 2020 18:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098915;
        bh=ugpQGowmrdGqDF/Za+uAAbijYTd/pjVCPMzzaCQ76Q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uSbf0hXjbVybowMt2cOmap9/rVTLea4FACvtcp52jFZaYxb395gByQmbS5Eacua07
         fKL7AzIRe0nI1yqWzpCSW0XuPMRZO9sIIeQSRot4LSVkzeXS9wPjR2WOz6JBwpSoyJ
         SISdH8PlqBDrIadDylOL6SK8QzQWvdKJoJSpMvr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.6 128/167] iwlwifi: mvm: fix inactive TID removal return value usage
Date:   Tue, 28 Apr 2020 20:25:04 +0200
Message-Id: <20200428182241.556985671@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit e6d419f943318e2b903e380dfd52a8dda6db3021 upstream.

The function iwl_mvm_remove_inactive_tids() returns bool, so we
should just check "if (ret)", not "if (ret >= 0)" (which would
do nothing useful here). We obviously therefore cannot use the
return value of the function for the free_queue, we need to use
the queue (i) we're currently dealing with instead.

Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20200417100405.9d862ed72535.I9e27ccc3ee3c8855fc13682592b571581925dfbd@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1169,9 +1169,9 @@ static int iwl_mvm_inactivity_check(stru
 						   inactive_tid_bitmap,
 						   &unshare_queues,
 						   &changetid_queues);
-		if (ret >= 0 && free_queue < 0) {
+		if (ret && free_queue < 0) {
 			queue_owner = sta;
-			free_queue = ret;
+			free_queue = i;
 		}
 		/* only unlock sta lock - we still need the queue info lock */
 		spin_unlock_bh(&mvmsta->lock);


