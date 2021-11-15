Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F9C45237F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352979AbhKPB0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:26:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:35152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243463AbhKOTCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:02:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A62E563368;
        Mon, 15 Nov 2021 18:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000106;
        bh=Vml9FdpwBb/m1Fv0zYGhQLH7BSgx+U3HNiH8ddqoG0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRsHjf9/FCfRAAMn1O5piTQov/fMzNX4bvSXYAXfB4rIVLZKmBqgtyY0/chWc0arn
         JKDtaPycnoQ912aYj9pXbMOJOL5QuujzD+SEV3kns6Xxc6AR2mECrM4oFjMDR4Mf0d
         UwrCqZQOOGQe+MZ+D+UeNgttC6/EDuMQsw2nFPgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 540/849] selftests/bpf: Fix fclose/pclose mismatch in test_progs
Date:   Mon, 15 Nov 2021 18:00:23 +0100
Message-Id: <20211115165438.531278070@linuxfoundation.org>
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

From: Andrea Righi <andrea.righi@canonical.com>

[ Upstream commit f48ad69097fe79d1de13c4d8fef556d4c11c5e68 ]

Make sure to use pclose() to properly close the pipe opened by popen().

Fixes: 81f77fd0deeb ("bpf: add selftest for stackmap with BPF_F_STACK_BUILD_ID")
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20211026143409.42666-1-andrea.righi@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index bfbf2277b61a6..f381253902274 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -348,7 +348,7 @@ int extract_build_id(char *build_id, size_t size)
 
 	if (getline(&line, &len, fp) == -1)
 		goto err;
-	fclose(fp);
+	pclose(fp);
 
 	if (len > size)
 		len = size;
@@ -357,7 +357,7 @@ int extract_build_id(char *build_id, size_t size)
 	free(line);
 	return 0;
 err:
-	fclose(fp);
+	pclose(fp);
 	return -1;
 }
 
-- 
2.33.0



