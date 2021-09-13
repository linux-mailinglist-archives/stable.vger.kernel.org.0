Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F020240942E
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344827AbhIMO2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:28:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345627AbhIMO0o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:26:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D65FD61B64;
        Mon, 13 Sep 2021 13:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540963;
        bh=XW9QkUscgFsUbyK7AHxGjzEjUEPA1rw9pXh8rXD1WPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeEQJ2TbuskOzJUgIGCaFeWN8ti0eLGEEQ7QnoSboW75VR2u8ADX5HJGkFcvpuXOc
         qn/5XAtYisEbeS3mbGvhe+ysRfj7fKNZeTp54qom308uFV0jkSBmaxJVHnR5vnLHVH
         gn0GVghnu8Yq9xcFYa4PDTfJupLWqI6kNybo6RV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 107/334] bpf, selftests: Fix test_maps now that sockmap supports UDP
Date:   Mon, 13 Sep 2021 15:12:41 +0200
Message-Id: <20210913131116.992150274@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit c39aa21599748f3845a47645f482d94099b11460 ]

UDP socket support was added recently so testing UDP insert failure is no
longer correct and causes test_maps failure. The fix is easy though, we
simply need to test that UDP is correctly added instead of blocked.

Fixes: 122e6c79efe1c ("sock_map: Update sock type checks for UDP")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210720184832.452430-1-john.fastabend@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_maps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
index 30cbf5d98f7d..abdfc41f7685 100644
--- a/tools/testing/selftests/bpf/test_maps.c
+++ b/tools/testing/selftests/bpf/test_maps.c
@@ -764,8 +764,8 @@ static void test_sockmap(unsigned int tasks, void *data)
 	udp = socket(AF_INET, SOCK_DGRAM, 0);
 	i = 0;
 	err = bpf_map_update_elem(fd, &i, &udp, BPF_ANY);
-	if (!err) {
-		printf("Failed socket SOCK_DGRAM allowed '%i:%i'\n",
+	if (err) {
+		printf("Failed socket update SOCK_DGRAM '%i:%i'\n",
 		       i, udp);
 		goto out_sockmap;
 	}
-- 
2.30.2



