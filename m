Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90AAD35BF72
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbhDLJG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239736AbhDLJD4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:03:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF3F161357;
        Mon, 12 Apr 2021 09:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218082;
        bh=zzhZFaNYPkumHGYSrHmgvbBxq6kUTTi2KdxTiGDvNqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=taQwpy3QEA2freQHYREbc84chSg6KoHp20hJAAsmB10ZF19T/JI0RlbAcBplPwlPY
         Fj4tvSpuOPVsByURfthLZXd0hX6//VVjGkqFKMgupAR6v8O2v5q1NuGWRTlUBAugf9
         vN07NebcCEklpKt75uHElIKYEa+J0EkwgNaQ5w4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Dave Switzer <david.switzer@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.11 065/210] i40e: Fix sparse error: uninitialized symbol ring
Date:   Mon, 12 Apr 2021 10:39:30 +0200
Message-Id: <20210412084018.163779729@linuxfoundation.org>
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

commit d6d04ee6d2c9bb5084c8f6074195d6aa0024e825 upstream.

Init pointer with NULL in default switch case statement.

Previously the error was produced when compiling against sparse.
i40e_debugfs.c:582 i40e_dbg_dump_desc() error: uninitialized symbol 'ring'.

Fixes: 44ea803e2fa7 ("i40e: introduce new dump desc XDP command")
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -578,6 +578,9 @@ static void i40e_dbg_dump_desc(int cnt,
 	case RING_TYPE_XDP:
 		ring = kmemdup(vsi->xdp_rings[ring_id], sizeof(*ring), GFP_KERNEL);
 		break;
+	default:
+		ring = NULL;
+		break;
 	}
 	if (!ring)
 		return;


