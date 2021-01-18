Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D08C2F9F4C
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391025AbhARMRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:17:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390889AbhARLqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C104E2222A;
        Mon, 18 Jan 2021 11:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970359;
        bh=rAiLV1FajodwqXxVeFW9K7IoNTI2jgXHKei92OBxcPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dYPSoFnP/wQxjrVzEuZ9mQZwl9WJsozn+RYI3cc/4zYXWtxh1DcETCIiPvVFVnEv2
         g2bJHm2YL+CTlpwqjuLVjRg96dnIRLFWjvtnAv8SeISeJEujng2o8Noq4bEhaKcmpP
         Eiz3lk/gFp8q5D1U0LKLJ5IdPHkG3MhFvxK7BHdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Yi <yiche@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 147/152] selftests: netfilter: Pass family parameter "-f" to conntrack tool
Date:   Mon, 18 Jan 2021 12:35:22 +0100
Message-Id: <20210118113359.768044253@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Yi <yiche@redhat.com>

commit fab336b42441e0b2eb1d81becedb45fbdf99606e upstream.

Fix nft_conntrack_helper.sh false fail report:

1) Conntrack tool need "-f ipv6" parameter to show out ipv6 traffic items.

2) Sleep 1 second after background nc send packet, to make sure check
is after this statement executed.

False report:
FAIL: ns1-lkjUemYw did not show attached helper ip set via ruleset
PASS: ns1-lkjUemYw connection on port 2121 has ftp helper attached
...

After fix:
PASS: ns1-2hUniwU2 connection on port 2121 has ftp helper attached
PASS: ns2-2hUniwU2 connection on port 2121 has ftp helper attached
...

Fixes: 619ae8e0697a6 ("selftests: netfilter: add test case for conntrack helper assignment")
Signed-off-by: Chen Yi <yiche@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/netfilter/nft_conntrack_helper.sh |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
+++ b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
@@ -94,7 +94,13 @@ check_for_helper()
 	local message=$2
 	local port=$3
 
-	ip netns exec ${netns} conntrack -L -p tcp --dport $port 2> /dev/null |grep -q 'helper=ftp'
+	if echo $message |grep -q 'ipv6';then
+		local family="ipv6"
+	else
+		local family="ipv4"
+	fi
+
+	ip netns exec ${netns} conntrack -L -f $family -p tcp --dport $port 2> /dev/null |grep -q 'helper=ftp'
 	if [ $? -ne 0 ] ; then
 		echo "FAIL: ${netns} did not show attached helper $message" 1>&2
 		ret=1
@@ -111,8 +117,8 @@ test_helper()
 
 	sleep 3 | ip netns exec ${ns2} nc -w 2 -l -p $port > /dev/null &
 
-	sleep 1
 	sleep 1 | ip netns exec ${ns1} nc -w 2 10.0.1.2 $port > /dev/null &
+	sleep 1
 
 	check_for_helper "$ns1" "ip $msg" $port
 	check_for_helper "$ns2" "ip $msg" $port
@@ -128,8 +134,8 @@ test_helper()
 
 	sleep 3 | ip netns exec ${ns2} nc -w 2 -6 -l -p $port > /dev/null &
 
-	sleep 1
 	sleep 1 | ip netns exec ${ns1} nc -w 2 -6 dead:1::2 $port > /dev/null &
+	sleep 1
 
 	check_for_helper "$ns1" "ipv6 $msg" $port
 	check_for_helper "$ns2" "ipv6 $msg" $port


