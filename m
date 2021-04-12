Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8B535BF70
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbhDLJGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239128AbhDLJC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:02:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43AC061245;
        Mon, 12 Apr 2021 09:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218076;
        bh=VChZ7GsvT6kbaA/hB2yLbCG+GMdofw6o3zOhkrvQBKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wFBU7z95hJvqJyvpJpPywJKikOf1j7rduOLCoWOS1BapCsRgc4TPV1fAJfIScwmrp
         jVzZxui8vLdI79jyqEnBIz4no01mOi6R3BZ+Gvyl0r+5uK1KBJpibd3VGvUh/7hbpe
         vC7G29bsXnLdawEo+wXE9cLuQ3Y3hmyV2j1LA3Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.11 063/210] i40e: Fix sparse warning: missing error code err
Date:   Mon, 12 Apr 2021 10:39:28 +0200
Message-Id: <20210412084018.102018837@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

commit 8a1e918d833ca5c391c4ded5dc006e2d1ce6d37c upstream.

Set proper return values inside error checking if-statements.

Previously following warning was produced when compiling against sparse.
i40e_main.c:15162 i40e_init_recovery_mode() warn: missing error code 'err'

Fixes: 4ff0ee1af0169 ("i40e: Introduce recovery mode support")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14647,12 +14647,16 @@ static int i40e_init_recovery_mode(struc
 	 * in order to register the netdev
 	 */
 	v_idx = i40e_vsi_mem_alloc(pf, I40E_VSI_MAIN);
-	if (v_idx < 0)
+	if (v_idx < 0) {
+		err = v_idx;
 		goto err_switch_setup;
+	}
 	pf->lan_vsi = v_idx;
 	vsi = pf->vsi[v_idx];
-	if (!vsi)
+	if (!vsi) {
+		err = -EFAULT;
 		goto err_switch_setup;
+	}
 	vsi->alloc_queue_pairs = 1;
 	err = i40e_config_netdev(vsi);
 	if (err)


