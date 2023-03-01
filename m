Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600DD6A730E
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjCASML (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbjCASML (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:12:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274DC4AFF4
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:12:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 94FBACE1DAC
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABC3C433EF;
        Wed,  1 Mar 2023 18:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694327;
        bh=se/Fx4rz2BZ2nlfkGZPZDiiRofWTYK5uf5Xbmg0VmRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VyP4aFxYzVPA0MmXQGOu3t8gtWh2mWEqnGWgS4YdzEJNw++ziXSbsbr3ZzbdPgigr
         x6ReW3YhZeg8FEgkkhbgS5cn217+BduuC+Rf38U09JNomwrhLPy5HSJckBz6sFVojW
         UKVEFwQJZ1YX17vVqsi9+HMyPTKlOAAH8OFQsUCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 22/42] selftests: ocelot: tc_flower_chains: make test_vlan_ingress_modify() more comprehensive
Date:   Wed,  1 Mar 2023 19:08:43 +0100
Message-Id: <20230301180658.052399258@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit bbb253b206b9c417928a6c827d038e457f3012e9 ]

We have two IS1 filters of the OCELOT_VCAP_KEY_ANY key type (the one with
"action vlan pop" and the one with "action vlan modify") and one of the
OCELOT_VCAP_KEY_IPV4 key type (the one with "action skbedit priority").
But we have no IS1 filter with the OCELOT_VCAP_KEY_ETYPE key type, and
there was an uncaught breakage there.

To increase test coverage, convert one of the OCELOT_VCAP_KEY_ANY
filters to OCELOT_VCAP_KEY_ETYPE, by making the filter also match on the
MAC SA of the traffic sent by mausezahn, $h1_mac.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20230205192409.1796428-2-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
index 9c79bbcce5a87..aff0a59f92d9a 100755
--- a/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
+++ b/tools/testing/selftests/drivers/net/ocelot/tc_flower_chains.sh
@@ -246,7 +246,7 @@ test_vlan_ingress_modify()
 	bridge vlan add dev $swp2 vid 300
 
 	tc filter add dev $swp1 ingress chain $(IS1 2) pref 3 \
-		protocol 802.1Q flower skip_sw vlan_id 200 \
+		protocol 802.1Q flower skip_sw vlan_id 200 src_mac $h1_mac \
 		action vlan modify id 300 \
 		action goto chain $(IS2 0 0)
 
-- 
2.39.0



