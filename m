Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A29E66C509
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbjAPQAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbjAPQAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D04234D1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:00:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9569060C1B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9286C433D2;
        Mon, 16 Jan 2023 16:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884846;
        bh=PfRQSYh6dXAJ6wy8EVH2O+u1IAcIYf141Qr/D/CCf/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0ftcMOanmwP5QwOOfsRjG+BGxz3L6RUMZvO6/Cm+u7Z4xkVnr2c6NWiqwS66nlTm
         cMlL5amqj43XnRIXIj60whdhCk/iXMrqhukQqZycbOSasu30hF6+04NPZ5DSE8BCG9
         PPnDUnoqZ3TV57Bxoee8uNfC+87HjWE13n740/OY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guillaume Nault <gnault@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/183] selftests/net: l2_tos_ttl_inherit.sh: Set IPv6 addresses with "nodad".
Date:   Mon, 16 Jan 2023 16:51:24 +0100
Message-Id: <20230116154810.098875433@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit e59370b2e96eb8e7e057a2a16e999ff385a3f2fb ]

The ping command can run before DAD completes. In that case, ping may
fail and break the selftest.

We don't need DAD here since we're working on isolated device pairs.

Fixes: b690842d12fd ("selftests/net: test l2 tunnel TOS/TTL inheriting")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/l2_tos_ttl_inherit.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
index dca1e6f777a8..e2574b08eabc 100755
--- a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
+++ b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
@@ -137,8 +137,8 @@ setup() {
 		if [ "$type" = "gre" ]; then
 			type="ip6gretap"
 		fi
-		ip addr add fdd1:ced0:5d88:3fce::1/64 dev veth0
-		$ns ip addr add fdd1:ced0:5d88:3fce::2/64 dev veth1
+		ip addr add fdd1:ced0:5d88:3fce::1/64 dev veth0 nodad
+		$ns ip addr add fdd1:ced0:5d88:3fce::2/64 dev veth1 nodad
 		ip link add name tep0 type $type $local_addr1 \
 		remote fdd1:ced0:5d88:3fce::2 tos $test_tos ttl $test_ttl \
 		$vxlan $geneve
@@ -170,8 +170,8 @@ setup() {
 		ip addr add 198.19.0.1/24 brd + dev ${parent}0
 		$ns ip addr add 198.19.0.2/24 brd + dev ${parent}1
 	elif [ "$inner" = "6" ]; then
-		ip addr add fdd4:96cf:4eae:443b::1/64 dev ${parent}0
-		$ns ip addr add fdd4:96cf:4eae:443b::2/64 dev ${parent}1
+		ip addr add fdd4:96cf:4eae:443b::1/64 dev ${parent}0 nodad
+		$ns ip addr add fdd4:96cf:4eae:443b::2/64 dev ${parent}1 nodad
 	fi
 }
 
-- 
2.35.1



