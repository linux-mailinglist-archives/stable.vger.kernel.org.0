Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43D330CC06
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbhBBTm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:42:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:40458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233268AbhBBNxX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:53:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2E9364FC9;
        Tue,  2 Feb 2021 13:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273441;
        bh=oHPrG3Zo04+XEM1eUNerAGQWt+ylIArg4kz+BKnOPAU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udRVu2h55/rEBSEHI5OdFq0YhSNcxuet8IebiC13IJRaoZn83fUJXOF66hrhlEAb+
         omAMnHcaRZbhWGJEAAfCcfzG/WwpdO/r05iM7sWWWFx6Yo/Z3zVyiTQTP2+O0UMS4l
         kHyMYg0yXp6xAwtwl2gtSGn0LPxEgqLCf0+u36+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Tieman <henry.w.tieman@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/142] ice: fix FDir IPv6 flexbyte
Date:   Tue,  2 Feb 2021 14:37:50 +0100
Message-Id: <20210202133002.123959433@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Henry Tieman <henry.w.tieman@intel.com>

[ Upstream commit 29e2d9eb82647654abff150ff02fa1e07362214f ]

The packet classifier would occasionally misrecognize an IPv6 training
packet when the next protocol field was 0. The correct value for
unspecified protocol is IPPROTO_NONE.

Fixes: 165d80d6adab ("ice: Support IPv6 Flow Director filters")
Signed-off-by: Henry Tieman <henry.w.tieman@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
index 2d27f66ac8534..192729546bbfc 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c
@@ -1576,7 +1576,13 @@ ice_set_fdir_input_set(struct ice_vsi *vsi, struct ethtool_rx_flow_spec *fsp,
 		       sizeof(struct in6_addr));
 		input->ip.v6.l4_header = fsp->h_u.usr_ip6_spec.l4_4_bytes;
 		input->ip.v6.tc = fsp->h_u.usr_ip6_spec.tclass;
-		input->ip.v6.proto = fsp->h_u.usr_ip6_spec.l4_proto;
+
+		/* if no protocol requested, use IPPROTO_NONE */
+		if (!fsp->m_u.usr_ip6_spec.l4_proto)
+			input->ip.v6.proto = IPPROTO_NONE;
+		else
+			input->ip.v6.proto = fsp->h_u.usr_ip6_spec.l4_proto;
+
 		memcpy(input->mask.v6.dst_ip, fsp->m_u.usr_ip6_spec.ip6dst,
 		       sizeof(struct in6_addr));
 		memcpy(input->mask.v6.src_ip, fsp->m_u.usr_ip6_spec.ip6src,
-- 
2.27.0



