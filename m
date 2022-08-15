Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B150C594846
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346250AbiHOXjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:39:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346200AbiHOXhT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:37:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94B95FA4;
        Mon, 15 Aug 2022 13:09:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59DCE6069F;
        Mon, 15 Aug 2022 20:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D812C433C1;
        Mon, 15 Aug 2022 20:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594188;
        bh=zv4DZZibKAMRI0gVGHC/jrX5f2LnrYxkNA82LOX0cq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAsAVbapHunNdaTWiMOXWSnP9kuUZ3Mi3nt6PJfHJ5zRKSlEmJUEoTu+LK1u6/S9N
         3OsjUyLPpa4Y2m5DcCiTNwTzV6hSuGfRtmydMLlMKeT3Sssp14S9ff7dvGhzTlbQ5r
         +c7NXWYS/LCTYNNSD40m6C60vjcmDrPzEUP+9qL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=B6rn-Thorben=20Hinz?= <jthinz@mailbox.tu-berlin.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0392/1157] selftests/bpf: Fix rare segfault in sock_fields prog test
Date:   Mon, 15 Aug 2022 19:55:48 +0200
Message-Id: <20220815180455.370700379@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>

[ Upstream commit 6dc7a0baf1a70b7d22662d38481824c14ddd80c5 ]

test_sock_fields__detach() got called with a null pointer here when one
of the CHECKs or ASSERTs up to the test_sock_fields__open_and_load()
call resulted in a jump to the "done" label.

A skeletons *__detach() is not safe to call with a null pointer, though.
This led to a segfault.

Go the easy route and only call test_sock_fields__destroy() which is
null-pointer safe and includes detaching.

Came across this while looking[1] to introduce the usage of
bpf_tcp_helpers.h (included in progs/test_sock_fields.c) together with
vmlinux.h.

[1] https://lore.kernel.org/bpf/629bc069dd807d7ac646f836e9dca28bbc1108e2.camel@mailbox.tu-berlin.de/

Fixes: 8f50f16ff39d ("selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads")
Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20220621070116.307221-1-jthinz@mailbox.tu-berlin.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sock_fields.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sock_fields.c b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
index 9d211b5c22c4..7d23166c77af 100644
--- a/tools/testing/selftests/bpf/prog_tests/sock_fields.c
+++ b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
@@ -394,7 +394,6 @@ void serial_test_sock_fields(void)
 	test();
 
 done:
-	test_sock_fields__detach(skel);
 	test_sock_fields__destroy(skel);
 	if (child_cg_fd >= 0)
 		close(child_cg_fd);
-- 
2.35.1



