Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAFE5316C6
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbiEWRS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240570AbiEWRQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:16:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC1A72212;
        Mon, 23 May 2022 10:15:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60EB7B8121F;
        Mon, 23 May 2022 17:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF17C385A9;
        Mon, 23 May 2022 17:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326105;
        bh=Em6VDN095tlB4mBZm4+ai7DDqRwvok4lEQCa+cyHyY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aKZJIDl/FDDl1+Q5i0YE83a1xutycno35+JgxUYapdCm7nrVt4N+qj3uIEF4nfTpe
         2QKMlivYPbwHFNugogwQmS4sg0ggYO5DAuF469c2whdCZOezYb0IUGPgn1Vp2dRfmD
         MyG9ffayoGu1gXS/JH+RByknUpyOMqce87txGeYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 55/68] selftests: add ping test with ping_group_range tuned
Date:   Mon, 23 May 2022 19:05:22 +0200
Message-Id: <20220523165811.579043620@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

[ Upstream commit e71b7f1f44d3d88c677769c85ef0171caf9fc89f ]

The 'ping' utility is able to manage two kind of sockets (raw or icmp),
depending on the sysctl ping_group_range. By default, ping_group_range is
set to '1 0', which forces ping to use an ip raw socket.

Let's replay the ping tests by allowing 'ping' to use the ip icmp socket.
After the previous patch, ipv4 tests results are the same with both kinds
of socket. For ipv6, there are a lot a new failures (the previous patch
fixes only two cases).

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 157822331954..d2ac09b35dcf 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -757,10 +757,16 @@ ipv4_ping()
 	setup
 	set_sysctl net.ipv4.raw_l3mdev_accept=1 2>/dev/null
 	ipv4_ping_novrf
+	setup
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
+	ipv4_ping_novrf
 
 	log_subsection "With VRF"
 	setup "yes"
 	ipv4_ping_vrf
+	setup "yes"
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
+	ipv4_ping_vrf
 }
 
 ################################################################################
@@ -2005,10 +2011,16 @@ ipv6_ping()
 	log_subsection "No VRF"
 	setup
 	ipv6_ping_novrf
+	setup
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
+	ipv6_ping_novrf
 
 	log_subsection "With VRF"
 	setup "yes"
 	ipv6_ping_vrf
+	setup "yes"
+	set_sysctl net.ipv4.ping_group_range='0 2147483647' 2>/dev/null
+	ipv6_ping_vrf
 }
 
 ################################################################################
-- 
2.35.1



