Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51B863580C
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbiKWJuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236986AbiKWJtk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:49:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F0E11373D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:46:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCCB961B29
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:46:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3D9C433D6;
        Wed, 23 Nov 2022 09:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196788;
        bh=jyKkORKFRgtrno+VYXBm2KyG4O4f6Lddnrs3pAb2oJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ow9u0tXhjZ4PI7Fb2nPHRJb9gn9GElkfUgT04cV95Hl4W5wzna9v0ejqYPejvjzbh
         OGIwAzLY2sRHbn23Hb7oFix9UInma/VeSy6dPou/e9q5H/RrVHDbpqVZtxM96a0Udp
         hHEMy7Ma7EQ9K6jwMZ3rSYeTMld8VwowijPFvlr0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pu Lehui <pulehui@huawei.com>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 124/314] selftests/bpf: Fix casting error when cross-compiling test_verifier for 32-bit platforms
Date:   Wed, 23 Nov 2022 09:49:29 +0100
Message-Id: <20221123084631.142821393@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit 0811664da064c6d7ca64c02f5579f758a007e52d ]

When cross-compiling test_verifier for 32-bit platforms, the casting error is shown below:

test_verifier.c:1263:27: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
 1263 |  info.xlated_prog_insns = (__u64)*buf;
      |                           ^
cc1: all warnings being treated as errors

Fix it by adding zero-extension for it.

Fixes: 933ff53191eb ("selftests/bpf: specify expected instructions in test_verifier tests")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/r/20221108121945.4104644-1-pulehui@huaweicloud.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index f9d553fbf68a..ce97a9262698 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -1260,7 +1260,7 @@ static int get_xlated_program(int fd_prog, struct bpf_insn **buf, int *cnt)
 
 	bzero(&info, sizeof(info));
 	info.xlated_prog_len = xlated_prog_len;
-	info.xlated_prog_insns = (__u64)*buf;
+	info.xlated_prog_insns = (__u64)(unsigned long)*buf;
 	if (bpf_obj_get_info_by_fd(fd_prog, &info, &info_len)) {
 		perror("second bpf_obj_get_info_by_fd failed");
 		goto out_free_buf;
-- 
2.35.1



