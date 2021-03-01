Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9F2328A66
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbhCASRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:17:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238505AbhCASJS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:09:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDCD5651FC;
        Mon,  1 Mar 2021 17:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620431;
        bh=UyxyDC5H4iCfK+QSXJyxUZ4eJ+IyEZFxGcFEYb9+TbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkoD1rzevWrXZOGFT9tCf9kzmlhEQRYnivoS8+Pu1tY6KOH69jaaz77HUqzaSx8SB
         ehd/Dq+bG5Wnb6Pyt74EcrmHuDj0UlCKbP8HSA3rC8nSUz4BqYo4oC7g2zzIAJs3/w
         K2PhQjnJt7Jylhw+2UWJH2kFLdV5YMyzFuwV8BZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 151/775] selftests/bpf: Dont exit on failed bpf_testmod unload
Date:   Mon,  1 Mar 2021 17:05:19 +0100
Message-Id: <20210301161209.112899047@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 86ce322d21eb032ed8fdd294d0fb095d2debb430 ]

Fix bug in handling bpf_testmod unloading that will cause test_progs exiting
prematurely if bpf_testmod unloading failed. This is especially problematic
when running a subset of test_progs that doesn't require root permissions and
doesn't rely on bpf_testmod, yet will fail immediately due to exit(1) in
unload_bpf_testmod().

Fixes: 9f7fa225894c ("selftests/bpf: Add bpf_testmod kernel module for testing")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210126065019.1268027-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 213628ee721c1..6396932b97e29 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -390,7 +390,7 @@ static void unload_bpf_testmod(void)
 			return;
 		}
 		fprintf(env.stderr, "Failed to unload bpf_testmod.ko from kernel: %d\n", -errno);
-		exit(1);
+		return;
 	}
 	if (env.verbosity > VERBOSE_NONE)
 		fprintf(stdout, "Successfully unloaded bpf_testmod.ko.\n");
-- 
2.27.0



