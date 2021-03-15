Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B24433B73C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhCON74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232493AbhCON67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CD7664EEC;
        Mon, 15 Mar 2021 13:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816721;
        bh=THw6yf0bfiJSFbYMutcyFRFhwf/AapyQAcjRb1E+Izo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srGy4Dg3fMGFObdzgdwlVUwF1cqcSKaKQGA2Ltjzkl2SJ72w+82QKB/oWY+R7+FvD
         dFiXSeeq/4r4YGFzM0tEzcOLBkdme+PLrsM1XI+gXugCXpyxt9CmnYYbNVTvV1PyFk
         KOaWKjpGAFG1LS0tRY8lNa3XnrcxB3yW+r2LkhiY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Danielle Ratson <danieller@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.11 085/306] selftests: forwarding: Fix race condition in mirror installation
Date:   Mon, 15 Mar 2021 14:52:28 +0100
Message-Id: <20210315135510.524224335@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
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
 


