Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37CC35BDE8
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237514AbhDLI4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:56:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238317AbhDLIxH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:53:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 652FE61284;
        Mon, 12 Apr 2021 08:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217497;
        bh=s4FdJ/p1pUqG5fTExzR0/krWBd2BW8ol+KYc38nkH7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPUYNNBlt8nfIqMWrq3mYT09fdOlZJe+3Vvt1PiM6a4BEHWwhXHgSTVWAX3xHV6Xc
         c+F5dF0KXi8dl/MpR2wvdnTpGO1rL+n93kzvcVsZ7daM0DH1/ZYp+/dQpGs+BwvKdi
         zOZWDLC47jpWR5XcXcBdKfEVtU9Ut+3Lv/TjW9ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jacek=20Bu=C5=82atek?= <jacekx.bulatek@intel.com>,
        Haiyue Wang <haiyue.wang@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.10 038/188] ice: Fix for dereference of NULL pointer
Date:   Mon, 12 Apr 2021 10:39:12 +0200
Message-Id: <20210412084014.911137003@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacek Bułatek <jacekx.bulatek@intel.com>

commit 7a91d3f02b04b2fb18c2dfa8b6c4e5a40a2753f5 upstream.

Add handling of allocation fault for ice_vsi_list_map_info.

Also *fi should not be NULL pointer, it is a reference to raw
data field, so remove this variable and use the reference
directly.

Fixes: 9daf8208dd4d ("ice: Add support for switch filter programming")
Signed-off-by: Jacek Bułatek <jacekx.bulatek@intel.com>
Co-developed-by: Haiyue Wang <haiyue.wang@intel.com>
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1239,6 +1239,9 @@ ice_add_update_vsi_list(struct ice_hw *h
 			ice_create_vsi_list_map(hw, &vsi_handle_arr[0], 2,
 						vsi_list_id);
 
+		if (!m_entry->vsi_list_info)
+			return ICE_ERR_NO_MEMORY;
+
 		/* If this entry was large action then the large action needs
 		 * to be updated to point to FWD to VSI list
 		 */
@@ -2224,6 +2227,7 @@ ice_vsi_uses_fltr(struct ice_fltr_mgmt_l
 	return ((fm_entry->fltr_info.fltr_act == ICE_FWD_TO_VSI &&
 		 fm_entry->fltr_info.vsi_handle == vsi_handle) ||
 		(fm_entry->fltr_info.fltr_act == ICE_FWD_TO_VSI_LIST &&
+		 fm_entry->vsi_list_info &&
 		 (test_bit(vsi_handle, fm_entry->vsi_list_info->vsi_map))));
 }
 
@@ -2296,14 +2300,12 @@ ice_add_to_vsi_fltr_list(struct ice_hw *
 		return ICE_ERR_PARAM;
 
 	list_for_each_entry(fm_entry, lkup_list_head, list_entry) {
-		struct ice_fltr_info *fi;
-
-		fi = &fm_entry->fltr_info;
-		if (!fi || !ice_vsi_uses_fltr(fm_entry, vsi_handle))
+		if (!ice_vsi_uses_fltr(fm_entry, vsi_handle))
 			continue;
 
 		status = ice_add_entry_to_vsi_fltr_list(hw, vsi_handle,
-							vsi_list_head, fi);
+							vsi_list_head,
+							&fm_entry->fltr_info);
 		if (status)
 			return status;
 	}


