Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6DFF33B8F5
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbhCOOFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232261AbhCON6q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5F0064F3E;
        Mon, 15 Mar 2021 13:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816714;
        bh=THw6yf0bfiJSFbYMutcyFRFhwf/AapyQAcjRb1E+Izo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhWuIRs+dRbClFpjmLNm8M7ReR2DasiLMGiVOszgANpbLt3Yt8Ee11SPjwluHU9Ut
         2+/RVVSO3veA13EeeXsfXapBHRiIrviXD2tSRlnXR8Etsc5k7y6c8o9IS//31jybdn
         Is5RhuzLxTeK9oZsQrWr4fQ4Zet3R8tSfMpAYzWM=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danielle Ratson <danieller@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 071/290] selftests: forwarding: Fix race condition in mirror installation
Date:   Mon, 15 Mar 2021 14:52:44 +0100
Message-Id: <20210315135544.303884819@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Danielle Ratson <danieller@nvidia.com>

commit edcbf5137f093b5502f5f6b97cce3cbadbde27aa upstream.

When mirroring to a gretap in hardware the device expects to be
programmed with the egress port and all the encapsulating headers. This
requires the driver to resolve the path the packet will take in the
software data path and program the device accordingly.

If the path cannot be resolved (in this case because of an unresolved
neighbor), then mirror installation fails until the path is resolved.
This results in a race that causes the test to sometimes fail.

Fix this by setting the neighbor's state to permanent, so that it is
always valid.

Fixes: b5b029399fa6d ("selftests: forwarding: mirror_gre_bridge_1d_vlan: Add STP test")
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1d_vlan.sh
@@ -86,11 +86,20 @@ test_ip6gretap()
 
 test_gretap_stp()
 {
+	# Sometimes after mirror installation, the neighbor's state is not valid.
+	# The reason is that there is no SW datapath activity related to the
+	# neighbor for the remote GRE address. Therefore whether the corresponding
+	# neighbor will be valid is a matter of luck, and the test is thus racy.
+	# Set the neighbor's state to permanent, so it would be always valid.
+	ip neigh replace 192.0.2.130 lladdr $(mac_get $h3) \
+		nud permanent dev br2
 	full_test_span_gre_stp gt4 $swp3.555 "mirror to gretap"
 }
 
 test_ip6gretap_stp()
 {
+	ip neigh replace 2001:db8:2::2 lladdr $(mac_get $h3) \
+		nud permanent dev br2
 	full_test_span_gre_stp gt6 $swp3.555 "mirror to ip6gretap"
 }
 


