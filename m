Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E0D4A4526
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346712AbiAaLgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378566AbiAaLeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:34:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50F7C0698FE;
        Mon, 31 Jan 2022 03:23:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75AE761296;
        Mon, 31 Jan 2022 11:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C84C340E8;
        Mon, 31 Jan 2022 11:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628208;
        bh=h2Oglsh7fuIuzgbAo+NjPCjgEr+fRutI0On/jy4oQZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpYNQETVNPgYIFQyydNZPKXfAGxpnc+G1fFOuiODpr/M7JHs0eYLWTetVq5l6K7V0
         QI3XFFOl1wk85EgvBl2+cB8j0vOClE9bcAmKZ5qpmK1sO3lj9TybTyGedL6pAyWIxr
         q8MmQ4sKE8MxipIdLHtOf+iKR1+tp63t0eXH7H7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Tal <moshet@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 132/200] ethtool: Fix link extended state for big endian
Date:   Mon, 31 Jan 2022 11:56:35 +0100
Message-Id: <20220131105237.990234986@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Tal <moshet@nvidia.com>

[ Upstream commit e2f08207c558bc0bc8abaa557cdb29bad776ac7b ]

The link extended sub-states are assigned as enum that is an integer
size but read from a union as u8, this is working for small values on
little endian systems but for big endian this always give 0. Fix the
variable in the union to match the enum size.

Fixes: ecc31c60240b ("ethtool: Add link extended state")
Signed-off-by: Moshe Tal <moshet@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ethtool.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 845a0ffc16ee8..d8f07baf272ad 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -95,7 +95,7 @@ struct ethtool_link_ext_state_info {
 		enum ethtool_link_ext_substate_bad_signal_integrity bad_signal_integrity;
 		enum ethtool_link_ext_substate_cable_issue cable_issue;
 		enum ethtool_link_ext_substate_module module;
-		u8 __link_ext_substate;
+		u32 __link_ext_substate;
 	};
 };
 
-- 
2.34.1



