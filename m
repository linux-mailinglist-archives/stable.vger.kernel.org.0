Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54880F7DEE
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbfKKSxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:53:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:48820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730135AbfKKSxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:53:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FB2420818;
        Mon, 11 Nov 2019 18:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498426;
        bh=4f1PiMzwr1X9jaxUxe9/HavsPY+6mPRKQx+bo1iSaS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfzIi3PyACfw4l57ZZ78BJBsvBf7x0/11C+H79l/8+m6BGs+UyvmiVZZYkPG7qRjV
         psuUcFQOb02oTVe1M+kMIdn0ZV0xAiJWcGIZLToEGBouliaaYNlmmGaJlagDNI8KH7
         YcN05TIcFhrYCNxL6Vte9v2MaULLKuZA/ib/XLpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Oskolkov <posk@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 109/193] selftests/bpf: More compatible nc options in test_tc_edt
Date:   Mon, 11 Nov 2019 19:28:11 +0100
Message-Id: <20191111181509.164214150@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 11875ba7f251c52effb2b924e04c2ddefa9856ef ]

Out of the three nc implementations widely in use, at least two (BSD netcat
and nmap-ncat) do not support -l combined with -s. Modify the nc invocation
to be accepted by all of them.

Fixes: 7df5e3db8f63 ("selftests: bpf: tc-bpf flow shaping with EDT")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Peter Oskolkov <posk@google.com>
Link: https://lore.kernel.org/bpf/f5bf07dccd8b552a76c84d49e80b86c5aa071122.1571400024.git.jbenc@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_tc_edt.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_tc_edt.sh b/tools/testing/selftests/bpf/test_tc_edt.sh
index f38567ef694b6..daa7d1b8d3092 100755
--- a/tools/testing/selftests/bpf/test_tc_edt.sh
+++ b/tools/testing/selftests/bpf/test_tc_edt.sh
@@ -59,7 +59,7 @@ ip netns exec ${NS_SRC} tc filter add dev veth_src egress \
 
 # start the listener
 ip netns exec ${NS_DST} bash -c \
-	"nc -4 -l -s ${IP_DST} -p 9000 >/dev/null &"
+	"nc -4 -l -p 9000 >/dev/null &"
 declare -i NC_PID=$!
 sleep 1
 
-- 
2.20.1



