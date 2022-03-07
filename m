Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C9D4CF747
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235157AbiCGJpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241072AbiCGJlt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6150F66AEC;
        Mon,  7 Mar 2022 01:39:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1D8B61219;
        Mon,  7 Mar 2022 09:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A6FC340F4;
        Mon,  7 Mar 2022 09:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645998;
        bh=GxjjCsKo7A5cdJcZZChpjxpBbwzR2bIJcqLI7N/1ee8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Don1FKx4OxSHYmPxsfZAhQGpqPYKDlQGU/21CmYowoyf+jBlj0te0/y7h/F28mEj8
         s90KV4TIrQbQ7jXZN1yJK1nPcfVX2vNoJksDiDWufWWnquRpDXs78sBxNj8Up9ivsh
         J48AzNqpXshRK1Uhc+OooDXQWY1aGp5Xr/+nlYzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Tal <moshet@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Gal Pressman <gal@nvidia.com>, Amit Cohen <amcohen@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/262] ethtool: Fix link extended state for big endian
Date:   Mon,  7 Mar 2022 10:17:27 +0100
Message-Id: <20220307091705.383984434@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 849524b55d89a..3fad741df53ef 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -94,7 +94,7 @@ struct ethtool_link_ext_state_info {
 		enum ethtool_link_ext_substate_link_logical_mismatch link_logical_mismatch;
 		enum ethtool_link_ext_substate_bad_signal_integrity bad_signal_integrity;
 		enum ethtool_link_ext_substate_cable_issue cable_issue;
-		u8 __link_ext_substate;
+		u32 __link_ext_substate;
 	};
 };
 
-- 
2.34.1



