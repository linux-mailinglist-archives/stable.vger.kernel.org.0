Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B56E2ABC14
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730748AbgKINd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:33:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730974AbgKINGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:06:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11E96206C0;
        Mon,  9 Nov 2020 13:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927160;
        bh=C6nedIJpJZKheagyONJTZkJ4kWfca7XQdltWRj5Kw7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QGGDOEhVDMZTHFs3DopCO7X70wivwS5azzRkVcZN3pOgIO/annMOnZD2krcC/riSb
         4P2lsntwsnpz97cOc/g8tnA6YQIVg4zNbdE2tPM29GOIkIHsHMELMs4XntOZSX7IQV
         ZfxYUXV0riiRHSQGmDgy4LVwvg70lRUIuvWzFrOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martyna Szapar <martyna.szapar@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.14 14/48] i40e: Fix of memory leak and integer truncation in i40e_virtchnl.c
Date:   Mon,  9 Nov 2020 13:55:23 +0100
Message-Id: <20201109125017.444598697@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125016.734107741@linuxfoundation.org>
References: <20201109125016.734107741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martyna Szapar <martyna.szapar@intel.com>

commit 24474f2709af6729b9b1da1c5e160ab62e25e3a4 upstream.

Fixed possible memory leak in i40e_vc_add_cloud_filter function:
cfilter is being allocated and in some error conditions
the function returns without freeing the memory.

Fix of integer truncation from u16 (type of queue_id value) to u8
when calling i40e_vc_isvalid_queue_id function.

Signed-off-by: Martyna Szapar <martyna.szapar@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
[bwh: Backported to 4.14: i40e_vc_add_cloud_filter() does not exist
 but the integer truncation is still possible]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -189,7 +189,7 @@ static inline bool i40e_vc_isvalid_vsi_i
  * check for the valid queue id
  **/
 static inline bool i40e_vc_isvalid_queue_id(struct i40e_vf *vf, u16 vsi_id,
-					    u8 qid)
+					    u16 qid)
 {
 	struct i40e_pf *pf = vf->pf;
 	struct i40e_vsi *vsi = i40e_find_vsi_from_id(pf, vsi_id);


