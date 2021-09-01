Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6097A3FDC16
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344310AbhIAMql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345657AbhIAMoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:44:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4683610FB;
        Wed,  1 Sep 2021 12:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499935;
        bh=GBWktodHJbzUILLX7upgQPvhEFnvldsn6m3ZrRH3NMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxodP0bhRvDnVSbVWiBDz/q+zpIDrFXH2eiJ9wMePd5RPp6FUVCR7R+imF0Tf9xGj
         COFWPdXc/G1uqgZzYPYftQKHx/yS1OzFCnGW72wKTN6VprK3VmnO+kz0/74axUMlVP
         CdzqJW5Wavj0LK8k8E8OCIi9BHHLHRTDqD9BQHfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 041/113] ice: do not abort devlink info if board identifier cant be found
Date:   Wed,  1 Sep 2021 14:27:56 +0200
Message-Id: <20210901122303.363783048@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit a8f89fa27773a8c96fd09fb4e2f4892d794f21f6 ]

The devlink dev info command reports version information about the
device and firmware running on the board. This includes the "board.id"
field which is supposed to represent an identifier of the board design.
The ice driver uses the Product Board Assembly identifier for this.

In some cases, the PBA is not present in the NVM. If this happens,
devlink dev info will fail with an error. Instead, modify the
ice_info_pba function to just exit without filling in the context
buffer. This will cause the board.id field to be skipped. Log a dev_dbg
message in case someone wants to confirm why board.id is not showing up
for them.

Fixes: e961b679fb0b ("ice: add board identifier info to devlink .info_get")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20210819223451.245613-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index cf685eeea198..e256f70cf59d 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -42,7 +42,9 @@ static int ice_info_pba(struct ice_pf *pf, struct ice_info_ctx *ctx)
 
 	status = ice_read_pba_string(hw, (u8 *)ctx->buf, sizeof(ctx->buf));
 	if (status)
-		return -EIO;
+		/* We failed to locate the PBA, so just skip this entry */
+		dev_dbg(ice_pf_to_dev(pf), "Failed to read Product Board Assembly string, status %s\n",
+			ice_stat_str(status));
 
 	return 0;
 }
-- 
2.30.2



