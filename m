Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3B54F28EC
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbiDEIXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237382AbiDEIR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE88CB53DC;
        Tue,  5 Apr 2022 01:06:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B0C4B81B14;
        Tue,  5 Apr 2022 08:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906DBC385A1;
        Tue,  5 Apr 2022 08:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145966;
        bh=U56hZjD4S/pEnKF2LuvYVCgeLMT6KTmLGPDAPE1EpZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNiySDHWAnFNIzRUTPS1ZqZVREptSqIaBsLOSal6AQa12nDfiZeUHJm23ynaoJcXH
         X7DeAgB8rGSRuEs8lFqwH8bUNLykrBqp7PVsZt5NKshyy3vmBBEA8AE/dRoGForRq9
         EBExSQ1HfCFp9TDYhl6QxZ0poWq/XVEHXQ2jUpJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geliang Tang <geliang.tang@suse.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0556/1126] selftests: mptcp: add csum mib check for mptcp_connect
Date:   Tue,  5 Apr 2022 09:21:43 +0200
Message-Id: <20220405070423.953672524@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Geliang Tang <geliang.tang@suse.com>

[ Upstream commit 24720d7452df2dff2e539d9dff28904e25bb1c6d ]

This patch added the data checksum error mib counters check for the
script mptcp_connect.sh when the data checksum is enabled.

In do_transfer(), got the mib counters twice, before and after running
the mptcp_connect commands. The latter minus the former is the actual
number of the data checksum mib counter.

The output looks like this:

ns1 MPTCP -> ns2 (dead:beef:1::2:10007) MPTCP   (duration    86ms) [ OK ]
ns1 MPTCP -> ns2 (10.0.2.1:10008      ) MPTCP   (duration    66ms) [ FAIL ]
server got 1 data checksum error[s]

Fixes: 94d66ba1d8e48 ("selftests: mptcp: enable checksum in mptcp_connect.sh")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/255
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/mptcp/mptcp_connect.sh      | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index f0f4ab96b8f3..621af6895f4d 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -432,6 +432,8 @@ do_transfer()
 	local stat_ackrx_last_l=$(get_mib_counter "${listener_ns}" "MPTcpExtMPCapableACKRX")
 	local stat_cookietx_last=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesSent")
 	local stat_cookierx_last=$(get_mib_counter "${listener_ns}" "TcpExtSyncookiesRecv")
+	local stat_csum_err_s=$(get_mib_counter "${listener_ns}" "MPTcpExtDataCsumErr")
+	local stat_csum_err_c=$(get_mib_counter "${connector_ns}" "MPTcpExtDataCsumErr")
 
 	timeout ${timeout_test} \
 		ip netns exec ${listener_ns} \
@@ -524,6 +526,23 @@ do_transfer()
 		fi
 	fi
 
+	if $checksum; then
+		local csum_err_s=$(get_mib_counter "${listener_ns}" "MPTcpExtDataCsumErr")
+		local csum_err_c=$(get_mib_counter "${connector_ns}" "MPTcpExtDataCsumErr")
+
+		local csum_err_s_nr=$((csum_err_s - stat_csum_err_s))
+		if [ $csum_err_s_nr -gt 0 ]; then
+			printf "[ FAIL ]\nserver got $csum_err_s_nr data checksum error[s]"
+			rets=1
+		fi
+
+		local csum_err_c_nr=$((csum_err_c - stat_csum_err_c))
+		if [ $csum_err_c_nr -gt 0 ]; then
+			printf "[ FAIL ]\nclient got $csum_err_c_nr data checksum error[s]"
+			retc=1
+		fi
+	fi
+
 	if [ $retc -eq 0 ] && [ $rets -eq 0 ]; then
 		printf "[ OK ]"
 	fi
-- 
2.34.1



