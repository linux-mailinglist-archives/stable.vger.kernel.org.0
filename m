Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3693521817
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242826AbiEJNdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243890AbiEJNcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:32:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DE1177898;
        Tue, 10 May 2022 06:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F45561769;
        Tue, 10 May 2022 13:23:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15824C385C2;
        Tue, 10 May 2022 13:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188994;
        bh=FxIhdZqIw91pbHMbO5gwTOdjHrJnWK2rh0Rb9gXuISc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dU1HsL/zdxZNvVWTQWHejnYRbr5fB30XZnubBqzWVrGh2dOz2BGGSUULUiqTJQQpZ
         8p/dxjgQHr/k0CiPR2h+lpp5FHcB4qmbkUuKozwGWBGAQD1DCfR9ZcLYu03+15QxvK
         PQoauegljEkJjZnS0JC+xyZzff1torP3CEfMLSSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.4 29/52] selftests: mirror_gre_bridge_1q: Avoid changing PVID while interface is operational
Date:   Tue, 10 May 2022 15:07:58 +0200
Message-Id: <20220510130730.706939275@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.852544477@linuxfoundation.org>
References: <20220510130729.852544477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

commit 3122257c02afd9f199a8fc84ae981e1fc4958532 upstream.

In emulated environments, the bridge ports enslaved to br1 get a carrier
before changing br1's PVID. This means that by the time the PVID is
changed, br1 is already operational and configured with an IPv6
link-local address.

When the test is run with netdevs registered by mlxsw, changing the PVID
is vetoed, as changing the VID associated with an existing L3 interface
is forbidden. This restriction is similar to the 8021q driver's
restriction of changing the VID of an existing interface.

Fix this by taking br1 down and bringing it back up when it is fully
configured.

With this fix, the test reliably passes on top of both the SW and HW
data paths (emulated or not).

Fixes: 239e754af854 ("selftests: forwarding: Test mirror-to-gretap w/ UL 802.1q")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/20220502084507.364774-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh
+++ b/tools/testing/selftests/net/forwarding/mirror_gre_bridge_1q.sh
@@ -61,9 +61,12 @@ setup_prepare()
 
 	vrf_prepare
 	mirror_gre_topo_create
+	# Avoid changing br1's PVID while it is operational as a L3 interface.
+	ip link set dev br1 down
 
 	ip link set dev $swp3 master br1
 	bridge vlan add dev br1 vid 555 pvid untagged self
+	ip link set dev br1 up
 	ip address add dev br1 192.0.2.129/28
 	ip address add dev br1 2001:db8:2::1/64
 


