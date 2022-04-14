Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4904C5013B6
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244918AbiDNNwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344575AbiDNNoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:44:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9412FE65;
        Thu, 14 Apr 2022 06:39:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36DC861D70;
        Thu, 14 Apr 2022 13:39:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B08C385A1;
        Thu, 14 Apr 2022 13:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943587;
        bh=vC3HpaQC66yZXonEgmL5Uq5YOTH5rq+MgVEPdR036Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VMei08A+jDnn0makQG7ferkPszXOt7o5X6mo1EtuAdhFlH41D/H+K7KKj/4Vh2Sq1
         ftDAmLjgTIJlILCPnl5AIQW4ZYT/YXEvDZ2Mk1eBzH0SnflEUf8zkJLXqegagsRAg7
         iXs+qWfVFXd/QLIwYUo/j9lBueOUNW2eH2aerxr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Maurer <fmaurer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 208/475] selftests/bpf: Make test_lwt_ip_encap more stable and faster
Date:   Thu, 14 Apr 2022 15:09:53 +0200
Message-Id: <20220414110900.950018289@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Maurer <fmaurer@redhat.com>

[ Upstream commit d23a8720327d33616f584d76c80824bfa4699be6 ]

In test_lwt_ip_encap, the ingress IPv6 encap test failed from time to
time. The failure occured when an IPv4 ping through the IPv6 GRE
encapsulation did not receive a reply within the timeout. The IPv4 ping
and the IPv6 ping in the test used different timeouts (1 sec for IPv4
and 6 sec for IPv6), probably taking into account that IPv6 might need
longer to successfully complete. However, when IPv4 pings (with the
short timeout) are encapsulated into the IPv6 tunnel, the delays of IPv6
apply.

The actual reason for the long delays with IPv6 was that the IPv6
neighbor discovery sometimes did not complete in time. This was caused
by the outgoing interface only having a tentative link local address,
i.e., not having completed DAD for that lladdr. The ND was successfully
retried after 1 sec but that was too late for the ping timeout.

The IPv6 addresses for the test were already added with nodad. However,
for the lladdrs, DAD was still performed. We now disable DAD in the test
netns completely and just assume that the two lladdrs on each veth pair
do not collide. This removes all the delays for IPv6 traffic in the
test.

Without the delays, we can now also reduce the delay of the IPv6 ping to
1 sec. This makes the whole test complete faster because we don't need
to wait for the excessive timeout for each IPv6 ping that is supposed
to fail.

Fixes: 0fde56e4385b0 ("selftests: bpf: add test_lwt_ip_encap selftest")
Signed-off-by: Felix Maurer <fmaurer@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/4987d549d48b4e316cd5b3936de69c8d4bc75a4f.1646305899.git.fmaurer@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_lwt_ip_encap.sh b/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
index b497bb85b667..6c69c42b1d60 100755
--- a/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
+++ b/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
@@ -120,6 +120,14 @@ setup()
 	ip netns exec ${NS2} sysctl -wq net.ipv4.conf.default.rp_filter=0
 	ip netns exec ${NS3} sysctl -wq net.ipv4.conf.default.rp_filter=0
 
+	# disable IPv6 DAD because it sometimes takes too long and fails tests
+	ip netns exec ${NS1} sysctl -wq net.ipv6.conf.all.accept_dad=0
+	ip netns exec ${NS2} sysctl -wq net.ipv6.conf.all.accept_dad=0
+	ip netns exec ${NS3} sysctl -wq net.ipv6.conf.all.accept_dad=0
+	ip netns exec ${NS1} sysctl -wq net.ipv6.conf.default.accept_dad=0
+	ip netns exec ${NS2} sysctl -wq net.ipv6.conf.default.accept_dad=0
+	ip netns exec ${NS3} sysctl -wq net.ipv6.conf.default.accept_dad=0
+
 	ip link add veth1 type veth peer name veth2
 	ip link add veth3 type veth peer name veth4
 	ip link add veth5 type veth peer name veth6
@@ -289,7 +297,7 @@ test_ping()
 		ip netns exec ${NS1} ping  -c 1 -W 1 -I veth1 ${IPv4_DST} 2>&1 > /dev/null
 		RET=$?
 	elif [ "${PROTO}" == "IPv6" ] ; then
-		ip netns exec ${NS1} ping6 -c 1 -W 6 -I veth1 ${IPv6_DST} 2>&1 > /dev/null
+		ip netns exec ${NS1} ping6 -c 1 -W 1 -I veth1 ${IPv6_DST} 2>&1 > /dev/null
 		RET=$?
 	else
 		echo "    test_ping: unknown PROTO: ${PROTO}"
-- 
2.34.1



