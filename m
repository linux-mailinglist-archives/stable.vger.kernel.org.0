Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101BF35BD04
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237975AbhDLIq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237742AbhDLIqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:46:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B9ED61221;
        Mon, 12 Apr 2021 08:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217155;
        bh=0cNbOnMZ16XEOZeaAzI8EuJMGfTvpS7aRU4XQGG5wrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2RWG7HaLQ3rLW1y/GcudSKdKsnDfBOSMRpBJ4kRhLOpVT0fjpiIErWMI2Hjf9xUJ5
         g3A+rhSsDDiQUyzZn5RPfDGpFkrKkS+K5MVlNO8qZzHc6OxTLu6s1Xek1eXwkU3C1s
         L4uY82VUmqtbokMpaY08FpPEDaJqaFtj+tp4doIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Malz <robertx.malz@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.4 024/111] ice: Cleanup fltr list in case of allocation issues
Date:   Mon, 12 Apr 2021 10:40:02 +0200
Message-Id: <20210412084005.033164092@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Malz <robertx.malz@intel.com>

commit b7eeb52721fe417730fc5adc5cbeeb5fe349ab26 upstream.

When ice_remove_vsi_lkup_fltr is called, by calling
ice_add_to_vsi_fltr_list local copy of vsi filter list
is created. If any issues during creation of vsi filter
list occurs it up for the caller to free already
allocated memory. This patch ensures proper memory
deallocation in these cases.

Fixes: 80d144c9ac82 ("ice: Refactor switch rule management structures and functions")
Signed-off-by: Robert Malz <robertx.malz@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -2665,7 +2665,7 @@ ice_remove_vsi_lkup_fltr(struct ice_hw *
 					  &remove_list_head);
 	mutex_unlock(rule_lock);
 	if (status)
-		return;
+		goto free_fltr_list;
 
 	switch (lkup) {
 	case ICE_SW_LKUP_MAC:
@@ -2688,6 +2688,7 @@ ice_remove_vsi_lkup_fltr(struct ice_hw *
 		break;
 	}
 
+free_fltr_list:
 	list_for_each_entry_safe(fm_entry, tmp, &remove_list_head, list_entry) {
 		list_del(&fm_entry->list_entry);
 		devm_kfree(ice_hw_to_dev(hw), fm_entry);


