Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942ED45250D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345446AbhKPBqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241584AbhKOSX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:23:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE89D617E3;
        Mon, 15 Nov 2021 17:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998827;
        bh=z+19KzzCPaZVSNg9zTbnACtrJ9VvhMrCVmjr8r+Gw3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YnUG7Fp4eyyDiCSgPdUGOXxpFIl/xqhlf4WVTgnF2EDWRqXbCxSgbwnFAxzco9H/A
         IvL+6QT2vIoKL3ya02MlUMkT3f8irMGbUhSeDGKB6g4wDfiQire82ZDf6ejQccjWKZ
         rg1VB7WxNbsXH+FiKYUInaTu9pNu+0omQkWgVDxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 077/849] fcnal-test: kill hanging ping/nettest binaries on cleanup
Date:   Mon, 15 Nov 2021 17:52:40 +0100
Message-Id: <20211115165422.658885311@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1f83b835a3eaa5ae4bd825fb07182698bfc243ba ]

On my box I see a bunch of ping/nettest processes hanging
around after fcntal-test.sh is done.

Clean those up before netns deletion.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20211021140247.29691-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index a8ad92850e630..8acc4f2a20071 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -436,10 +436,13 @@ cleanup()
 		ip -netns ${NSA} link set dev ${NSA_DEV} down
 		ip -netns ${NSA} link del dev ${NSA_DEV}
 
+		ip netns pids ${NSA} | xargs kill 2>/dev/null
 		ip netns del ${NSA}
 	fi
 
+	ip netns pids ${NSB} | xargs kill 2>/dev/null
 	ip netns del ${NSB}
+	ip netns pids ${NSC} | xargs kill 2>/dev/null
 	ip netns del ${NSC} >/dev/null 2>&1
 }
 
-- 
2.33.0



