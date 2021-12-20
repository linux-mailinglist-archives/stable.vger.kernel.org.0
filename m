Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E0E47AD40
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236779AbhLTOvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:51:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38634 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbhLTOsH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:48:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABB0F61185;
        Mon, 20 Dec 2021 14:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90074C36AF0;
        Mon, 20 Dec 2021 14:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011686;
        bh=u6l7cWOe3Cl8aEC8Liy9VsBmgy8XvYgHzvWCvRR+gh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpsqYrsIhRT88XqPC0FrEifSdZ1y/3LY7c6K4ULEbBSgMZE6cfAeEX/OeMLcmKA7h
         Avu7fSgfWxo39LJFwPLvb7sL21LzLPDV4VaGl1iP+c13PQZODMR5wj6pcq9iczQ/pv
         WWlnKlviJmqNuoViH6GVPOALL+ePhWpIe5+WZpeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Zhijian <lizhijian@fujitsu.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/99] selftests: Fix raw socket bind tests with VRF
Date:   Mon, 20 Dec 2021 15:34:10 +0100
Message-Id: <20211220143030.623876528@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 0f108ae4452025fef529671998f6c7f1c4526790 ]

Commit referenced below added negative socket bind tests for VRF. The
socket binds should fail since the address to bind to is in a VRF yet
the socket is not bound to the VRF or a device within it. Update the
expected return code to check for 1 (bind failure) so the test passes
when the bind fails as expected. Add a 'show_hint' comment to explain
why the bind is expected to fail.

Fixes: 75b2b2b3db4c ("selftests: Add ipv4 address bind tests to fcnal-test")
Reported-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 9f771f7e57450..dd67004a1d83a 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1747,8 +1747,9 @@ ipv4_addr_bind_vrf()
 	for a in ${NSA_IP} ${VRF_IP}
 	do
 		log_start
+		show_hint "Socket not bound to VRF, but address is in VRF"
 		run_cmd nettest -s -R -P icmp -l ${a} -b
-		log_test_addr ${a} $? 0 "Raw socket bind to local address"
+		log_test_addr ${a} $? 1 "Raw socket bind to local address"
 
 		log_start
 		run_cmd nettest -s -R -P icmp -l ${a} -d ${NSA_DEV} -b
-- 
2.33.0



