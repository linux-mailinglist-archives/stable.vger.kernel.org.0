Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9B64121DF
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359847AbhITSKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:10:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358992AbhITSJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:09:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21C6C63260;
        Mon, 20 Sep 2021 17:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158338;
        bh=9yQVsBKhkMPV/1QFKagHMGFQ/CidzBP1nHpUmOc3MUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKBfvjG7SYXhvJrcO7oHRmTEHrg3tbSdOVczD6LOFZ/CnECY3Nu7u47zIve1wFvVJ
         R9da5iRyiDQEp45ReAgIH3GZw6AMQcW6xR10Mien3c1Sg6pLXAG+8Rdzfe6cJ9yRfd
         m7dS6htuv6jh5X+dwSAgxsL2DbLSjuijXfN/YJ+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juhee Kang <claudiajkang@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 110/260] samples: bpf: Fix tracex7 error raised on the missing argument
Date:   Mon, 20 Sep 2021 18:42:08 +0200
Message-Id: <20210920163934.874877269@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juhee Kang <claudiajkang@gmail.com>

[ Upstream commit 7d07006f05922b95518be403f08ef8437b67aa32 ]

The current behavior of 'tracex7' doesn't consist with other bpf samples
tracex{1..6}. Other samples do not require any argument to run with, but
tracex7 should be run with btrfs device argument. (it should be executed
with test_override_return.sh)

Currently, tracex7 doesn't have any description about how to run this
program and raises an unexpected error. And this result might be
confusing since users might not have a hunch about how to run this
program.

    // Current behavior
    # ./tracex7
    sh: 1: Syntax error: word unexpected (expecting ")")
    // Fixed behavior
    # ./tracex7
    ERROR: Run with the btrfs device argument!

In order to fix this error, this commit adds logic to report a message
and exit when running this program with a missing argument.

Additionally in test_override_return.sh, there is a problem with
multiple directory(tmpmnt) creation. So in this commit adds a line with
removing the directory with every execution.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210727041056.23455-1-claudiajkang@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/test_override_return.sh | 1 +
 samples/bpf/tracex7_user.c          | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/samples/bpf/test_override_return.sh b/samples/bpf/test_override_return.sh
index e68b9ee6814b..35db26f736b9 100755
--- a/samples/bpf/test_override_return.sh
+++ b/samples/bpf/test_override_return.sh
@@ -1,5 +1,6 @@
 #!/bin/bash
 
+rm -r tmpmnt
 rm -f testfile.img
 dd if=/dev/zero of=testfile.img bs=1M seek=1000 count=1
 DEVICE=$(losetup --show -f testfile.img)
diff --git a/samples/bpf/tracex7_user.c b/samples/bpf/tracex7_user.c
index ea6dae78f0df..2ed13e9f3fcb 100644
--- a/samples/bpf/tracex7_user.c
+++ b/samples/bpf/tracex7_user.c
@@ -13,6 +13,11 @@ int main(int argc, char **argv)
 	char command[256];
 	int ret;
 
+	if (!argv[1]) {
+		fprintf(stderr, "ERROR: Run with the btrfs device argument!\n");
+		return 0;
+	}
+
 	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
 
 	if (load_bpf_file(filename)) {
-- 
2.30.2



