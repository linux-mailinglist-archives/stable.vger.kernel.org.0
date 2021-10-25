Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4012F43A1C4
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235585AbhJYTly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:59602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237154AbhJYTju (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55D1361154;
        Mon, 25 Oct 2021 19:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190539;
        bh=LDCUe0qtzBRMvib6ZbR+7eZoeVrHN0Bup0+sxRHVavU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYaq+cAdwewag53z1qTgkcI6lbGNKEarFOOJV0yGMdxVQ3yOmyupMnXfpxVlCv9L5
         fH/dtGQAXJgOPUxPWApKN9q9XcA+BOPvQ7HKiqfp1SjfLsX55tDJlqNZ040t56WsLy
         chOsnwzLvr6wR1DuffEPZ4saL9CbRYNMLBtKxnyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "stable@vger.kernel.org, Lorenz Bauer" <lmb@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 5.10 93/95] selftests: bpf: fix backported ASSERT_FALSE
Date:   Mon, 25 Oct 2021 21:15:30 +0200
Message-Id: <20211025191010.199813252@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

Commit 183d9ebd449c ("selftests/bpf: Fix core_reloc test runner") causes
builds of selftests/bpf to fail on 5.10.y since the branch doesn't have the
ASSERT_FALSE macro yet. Replace ASSERT_FALSE with ASSERT_EQ.

Fixes: 183d9ebd449c ("selftests/bpf: Fix core_reloc test runner")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/core_reloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -857,7 +857,7 @@ void test_core_reloc(void)
 			goto cleanup;
 		}
 
-		if (!ASSERT_FALSE(test_case->fails, "obj_load_should_fail"))
+		if (!ASSERT_EQ(test_case->fails, false, "obj_load_should_fail"))
 			goto cleanup;
 
 		equal = memcmp(data->out, test_case->output,


