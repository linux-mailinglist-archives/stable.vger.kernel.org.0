Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58F6E5AEC
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbfJZNS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbfJZNSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:18:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9011222BE;
        Sat, 26 Oct 2019 13:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095933;
        bh=8rI5UOEw6DaLu75RfzL3/QkaHNW9D5ayHlsc7k0R+E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nB4B6sbpRhydkVitsxmPrMUdY1iJANVh9encbH+CFfStAv0scFnru9QuTLM1+iEy2
         ReRvXnnOq7pwiJnZLXkL/+mXruBjjhQjrT7kWUWvEgNufqXBubw8fDmjXCTmCh5nxO
         OT8ujYh7bmcCvEdtdwXYOaoohKNkTsjqZPTC7SuI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Hubbard <jhubbard@nvidia.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Keith Busch <keith.busch@intel.com>,
        Shuah Khan <shuah@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        kbuild test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 96/99] mm/gup_benchmark: add a missing "w" to getopt string
Date:   Sat, 26 Oct 2019 09:15:57 -0400
Message-Id: <20191026131600.2507-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

[ Upstream commit 6f24c8d30d08f270b54f4c2cb9b08dfccbe59c57 ]

Even though gup_benchmark.c has code to handle the -w command-line option,
the "w" is not part of the getopt string.  It looks as if it has been
missing the whole time.

On my machine, this leads naturally to the following predictable result:

  $ sudo ./gup_benchmark -w
  ./gup_benchmark: invalid option -- 'w'

...which is fixed with this commit.

Link: http://lkml.kernel.org/r/20191014184639.1512873-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: kbuild test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vm/gup_benchmark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vm/gup_benchmark.c b/tools/testing/selftests/vm/gup_benchmark.c
index c0534e298b512..cb3fc09645c48 100644
--- a/tools/testing/selftests/vm/gup_benchmark.c
+++ b/tools/testing/selftests/vm/gup_benchmark.c
@@ -37,7 +37,7 @@ int main(int argc, char **argv)
 	char *file = "/dev/zero";
 	char *p;
 
-	while ((opt = getopt(argc, argv, "m:r:n:f:tTLUSH")) != -1) {
+	while ((opt = getopt(argc, argv, "m:r:n:f:tTLUwSH")) != -1) {
 		switch (opt) {
 		case 'm':
 			size = atoi(optarg) * MB;
-- 
2.20.1

