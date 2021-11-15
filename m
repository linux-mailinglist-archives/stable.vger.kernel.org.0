Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F622450F25
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241152AbhKOS1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:27:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241326AbhKOSYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:24:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E12096108F;
        Mon, 15 Nov 2021 17:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998888;
        bh=xtkgGemgYZjpAIjTK77NNlagL7CJxzmAxpCBxRLic1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CawwEemawn5hiWeRVkjUCQNJnnu6dFJVTejw1z1GaQoUgqgNsw9SlOYr5U4fhl8xu
         4dE9BxN/QC7ahxHfJiCuufpincq7fz7Z47eJCmgG1zKw0l8m/aOIuNaG7oMHcD4Q9M
         0zJI34IUN8zhzBt4ryOdDItJ0QJ+JzOnV9frWAG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Yang <davidcomponentone@gmail.com>,
        Zeal Robot <zealci@zte.com.cn>, Zi Yan <ziy@nvidia.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 097/849] tools/testing/selftests/vm/split_huge_page_test.c: fix application of sizeof to pointer
Date:   Mon, 15 Nov 2021 17:53:00 +0100
Message-Id: <20211115165423.365143844@linuxfoundation.org>
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

From: David Yang <davidcomponentone@gmail.com>

[ Upstream commit 9c7516d669e68e94e17203469a873ff5d1d3a41a ]

The coccinelle check report:

  ./tools/testing/selftests/vm/split_huge_page_test.c:344:36-42:
  ERROR: application of sizeof to pointer

Use "strlen" to fix it.

Link: https://lkml.kernel.org/r/20211012030116.184027-1-davidcomponentone@gmail.com
Signed-off-by: David Yang <davidcomponentone@gmail.com>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/split_huge_page_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/split_huge_page_test.c b/tools/testing/selftests/vm/split_huge_page_test.c
index 1af16d2c2a0ac..52497b7b9f1db 100644
--- a/tools/testing/selftests/vm/split_huge_page_test.c
+++ b/tools/testing/selftests/vm/split_huge_page_test.c
@@ -341,7 +341,7 @@ void split_file_backed_thp(void)
 	}
 
 	/* write something to the file, so a file-backed THP can be allocated */
-	num_written = write(fd, tmpfs_loc, sizeof(tmpfs_loc));
+	num_written = write(fd, tmpfs_loc, strlen(tmpfs_loc) + 1);
 	close(fd);
 
 	if (num_written < 1) {
-- 
2.33.0



