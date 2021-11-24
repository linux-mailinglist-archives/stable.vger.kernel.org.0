Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691F845C05E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243379AbhKXNHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:07:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347326AbhKXNFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:05:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7DE7613A3;
        Wed, 24 Nov 2021 12:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757456;
        bh=3uznKvS2YSwo9UDBzMZsBGoD7cheUAVf2NW0SgOo+o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R66Ul+PMAbjeF5Id7JnZviJKK44+X6625QThaZP7I8E8ZCrpqJJHL5CwY+fLBfFnx
         41Or2N9Ub/IIddSmp2CjxArf41ptub13m9/4FhA1YFr452EnbS76GvgpPNvUZFRm6t
         ceReTeE/LrCwgN+b1ovWlNMcrgLGJgbAjP6RHMcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrea Righi <andrea.righi@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 174/323] selftests/bpf: Fix fclose/pclose mismatch in test_progs
Date:   Wed, 24 Nov 2021 12:56:04 +0100
Message-Id: <20211124115724.822951670@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index bad3505d66e05..0fcd38ffcc24c 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -1112,7 +1112,7 @@ static int extract_build_id(char *build_id, size_t size)
 
 	if (getline(&line, &len, fp) == -1)
 		goto err;
-	fclose(fp);
+	pclose(fp);
 
 	if (len > size)
 		len = size;
@@ -1121,7 +1121,7 @@ static int extract_build_id(char *build_id, size_t size)
 	free(line);
 	return 0;
 err:
-	fclose(fp);
+	pclose(fp);
 	return -1;
 }
 
-- 
2.33.0



