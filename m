Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D2123A6D5
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgHCMzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:55:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgHCMXC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:23:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A1D220738;
        Mon,  3 Aug 2020 12:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457381;
        bh=cdtxj/ywbkVNySjD8OmBny99CKB7Y7dBkHs04XnxzZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LH9xriZaPP34S8VLB4uBbWk1K/t6k/f9qP8TZGpFL/S02Lvu8812c3Jcj6c+f48bY
         4YS8SPNirbtRZ9OuL93DykoLbkE1QsJBqYfz//o3D9sk/2IokshpHxDCqTmIEZNhzt
         xNC6lkaluUhlBNUcR9ErgapidQB6Gt4RlTdnQ7ME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 046/120] selftests/net: tcp_mmap: fix clang warning for target arch PowerPC
Date:   Mon,  3 Aug 2020 14:18:24 +0200
Message-Id: <20200803121905.051526833@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

[ Upstream commit 94b6c13be57cdedb7cf4d33dbcd066fad133f22b ]

When size_t maps to unsigned int (e.g. on 32-bit powerpc), then the
comparison with 1<<35 is always true. Clang 9 threw:
warning: result of comparison of constant 34359738368 with \
expression of type 'size_t' (aka 'unsigned int') is always true \
[-Wtautological-constant-out-of-range-compare]
        while (total < FILE_SZ) {

Tested: make -C tools/testing/selftests TARGETS="net" run_tests

Fixes: 192dc405f308 ("selftests: net: add tcp_mmap program")
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tcp_mmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 4555f88252baf..a61b7b3da5496 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -344,7 +344,7 @@ int main(int argc, char *argv[])
 {
 	struct sockaddr_storage listenaddr, addr;
 	unsigned int max_pacing_rate = 0;
-	size_t total = 0;
+	uint64_t total = 0;
 	char *host = NULL;
 	int fd, c, on = 1;
 	char *buffer;
@@ -473,12 +473,12 @@ int main(int argc, char *argv[])
 		zflg = 0;
 	}
 	while (total < FILE_SZ) {
-		ssize_t wr = FILE_SZ - total;
+		int64_t wr = FILE_SZ - total;
 
 		if (wr > chunk_size)
 			wr = chunk_size;
 		/* Note : we just want to fill the pipe with 0 bytes */
-		wr = send(fd, buffer, wr, zflg ? MSG_ZEROCOPY : 0);
+		wr = send(fd, buffer, (size_t)wr, zflg ? MSG_ZEROCOPY : 0);
 		if (wr <= 0)
 			break;
 		total += wr;
-- 
2.25.1



