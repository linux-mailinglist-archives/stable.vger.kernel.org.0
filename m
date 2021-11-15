Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D818F45117C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243904AbhKOTJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:09:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243776AbhKOTGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:06:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9579F63248;
        Mon, 15 Nov 2021 18:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000197;
        bh=jPgkEP+8sYQy5B11UtAwkKzgC4r+Q0RrdIN4qj/0Uf4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0DNBjEQAKXmxRNlcyKljs9DmVGsk2JHNmZAMSvFsvy3Ex/RhDwUozfiipPr9V0aL
         0yUoSZrXPWsEgNxhwATEsIxsfPnKXUYb3CiFZ+y5Lb64/jTUOL+sawMsUPz9MLj6ZR
         VXHUjcArPYl7iQeiw5t8lb7PtaX+2bYyMZSGzlJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 529/849] selftests/bpf: Fix memory leak in test_ima
Date:   Mon, 15 Nov 2021 18:00:12 +0100
Message-Id: <20211115165438.165534893@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit efadf2ad17a2d5dc90bda4e6e8b2f96af4c62dae ]

The allocated ring buffer is never freed, do so in the cleanup path.

Fixes: f446b570ac7e ("bpf/selftests: Update the IMA test to use BPF ring buffer")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20211028063501.2239335-9-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/test_ima.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
index 0252f61d611a9..97d8a6f84f4ab 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
@@ -43,7 +43,7 @@ static int process_sample(void *ctx, void *data, size_t len)
 void test_test_ima(void)
 {
 	char measured_dir_template[] = "/tmp/ima_measuredXXXXXX";
-	struct ring_buffer *ringbuf;
+	struct ring_buffer *ringbuf = NULL;
 	const char *measured_dir;
 	char cmd[256];
 
@@ -85,5 +85,6 @@ close_clean:
 	err = system(cmd);
 	CHECK(err, "failed to run command", "%s, errno = %d\n", cmd, errno);
 close_prog:
+	ring_buffer__free(ringbuf);
 	ima__destroy(skel);
 }
-- 
2.33.0



