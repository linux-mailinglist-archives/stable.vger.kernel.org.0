Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD31B450CC0
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238080AbhKORmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:42:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:52660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238286AbhKORkW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:40:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98E7E632E5;
        Mon, 15 Nov 2021 17:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997212;
        bh=yX+1LotnylVoATmx3GgWMNzVqZiGHDsNYaGoIlFJzgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXnLhMUI0G1KC3b9VHHp2EZpfseqYsJ8RYozw9UyT1YRSNYqusTOxcAoBM8k2Y4rw
         MlOjOhvThDgOUMl9t8d8GxNoTXHJ4YRZTQZujPFHBAVs7puByQ+loFDcU/pnrx2yse
         SSIGAxkWzplvdw/cfq415zzu0+jBR+ZRB5D6BJDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/575] fcnal-test: kill hanging ping/nettest binaries on cleanup
Date:   Mon, 15 Nov 2021 17:56:30 +0100
Message-Id: <20211115165345.888788076@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 02b0b9ead40b9..225440f5f99eb 100755
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



