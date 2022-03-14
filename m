Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186494D81DE
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239780AbiCNL5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239802AbiCNL47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:56:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC696A191;
        Mon, 14 Mar 2022 04:55:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6231060FF3;
        Mon, 14 Mar 2022 11:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C56C340E9;
        Mon, 14 Mar 2022 11:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647258948;
        bh=rmqWh++bmnolqTwUgqq50Pxu7vO0BZugPXX67ZgUons=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rlHsdb2I51rKadhUYfwgfKalYpE0XR/p96k0DGOYFinsBFMURHWmGcHPALSXnE1DD
         2ZYLtvaANfXjy5KhUpZwJ6YVuGeHyNThV9E8jcCbck+vATte2WdID1sqdVmI4xGVp3
         +I2NrG/tYT7mSAYSshyNHJ/TLXM0ePyeqZTWH+zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/43] selftests: pmtu.sh: Kill tcpdump processes launched by subshell.
Date:   Mon, 14 Mar 2022 12:53:26 +0100
Message-Id: <20220314112734.846774844@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112734.415677317@linuxfoundation.org>
References: <20220314112734.415677317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 18dfc667550fe9c032a6dcc3402b50e691e18029 ]

The cleanup() function takes care of killing processes launched by the
test functions. It relies on variables like ${tcpdump_pids} to get the
relevant PIDs. But tests are run in their own subshell, so updated
*_pids values are invisible to other shells. Therefore cleanup() never
sees any process to kill:

$ ./tools/testing/selftests/net/pmtu.sh -t pmtu_ipv4_exception
TEST: ipv4: PMTU exceptions                                         [ OK ]
TEST: ipv4: PMTU exceptions - nexthop objects                       [ OK ]

$ pgrep -af tcpdump
6084 tcpdump -s 0 -i veth_A-R1 -w pmtu_ipv4_exception_veth_A-R1.pcap
6085 tcpdump -s 0 -i veth_R1-A -w pmtu_ipv4_exception_veth_R1-A.pcap
6086 tcpdump -s 0 -i veth_R1-B -w pmtu_ipv4_exception_veth_R1-B.pcap
6087 tcpdump -s 0 -i veth_B-R1 -w pmtu_ipv4_exception_veth_B-R1.pcap
6088 tcpdump -s 0 -i veth_A-R2 -w pmtu_ipv4_exception_veth_A-R2.pcap
6089 tcpdump -s 0 -i veth_R2-A -w pmtu_ipv4_exception_veth_R2-A.pcap
6090 tcpdump -s 0 -i veth_R2-B -w pmtu_ipv4_exception_veth_R2-B.pcap
6091 tcpdump -s 0 -i veth_B-R2 -w pmtu_ipv4_exception_veth_B-R2.pcap
6228 tcpdump -s 0 -i veth_A-R1 -w pmtu_ipv4_exception_veth_A-R1.pcap
6229 tcpdump -s 0 -i veth_R1-A -w pmtu_ipv4_exception_veth_R1-A.pcap
6230 tcpdump -s 0 -i veth_R1-B -w pmtu_ipv4_exception_veth_R1-B.pcap
6231 tcpdump -s 0 -i veth_B-R1 -w pmtu_ipv4_exception_veth_B-R1.pcap
6232 tcpdump -s 0 -i veth_A-R2 -w pmtu_ipv4_exception_veth_A-R2.pcap
6233 tcpdump -s 0 -i veth_R2-A -w pmtu_ipv4_exception_veth_R2-A.pcap
6234 tcpdump -s 0 -i veth_R2-B -w pmtu_ipv4_exception_veth_R2-B.pcap
6235 tcpdump -s 0 -i veth_B-R2 -w pmtu_ipv4_exception_veth_B-R2.pcap

Fix this by running cleanup() in the context of the test subshell.
Now that each test cleans the environment after completion, there's no
need for calling cleanup() again when the next test starts. So let's
drop it from the setup() function. This is okay because cleanup() is
also called when pmtu.sh starts, so even the first test starts in a
clean environment.

Also, use tcpdump's immediate mode. Otherwise it might not have time to
process buffered packets, resulting in missing packets or even empty
pcap files for short tests.

Note: PAUSE_ON_FAIL is still evaluated before cleanup(), so one can
still inspect the test environment upon failure when using -p.

Fixes: a92a0a7b8e7c ("selftests: pmtu: Simplify cleanup and namespace names")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 3429767cadcd..88be9083b923 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -579,7 +579,6 @@ setup_routing() {
 setup() {
 	[ "$(id -u)" -ne 0 ] && echo "  need to run as root" && return $ksft_skip
 
-	cleanup
 	for arg do
 		eval setup_${arg} || { echo "  ${arg} not supported"; return 1; }
 	done
@@ -590,7 +589,7 @@ trace() {
 
 	for arg do
 		[ "${ns_cmd}" = "" ] && ns_cmd="${arg}" && continue
-		${ns_cmd} tcpdump -s 0 -i "${arg}" -w "${name}_${arg}.pcap" 2> /dev/null &
+		${ns_cmd} tcpdump --immediate-mode -s 0 -i "${arg}" -w "${name}_${arg}.pcap" 2> /dev/null &
 		tcpdump_pids="${tcpdump_pids} $!"
 		ns_cmd=
 	done
@@ -1182,6 +1181,10 @@ run_test() {
 
 	unset IFS
 
+	# Since cleanup() relies on variables modified by this subshell, it
+	# has to run in this context.
+	trap cleanup EXIT
+
 	if [ "$VERBOSE" = "1" ]; then
 		printf "\n##########################################################################\n\n"
 	fi
-- 
2.34.1



