Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBA00270A89
	for <lists+stable@lfdr.de>; Sat, 19 Sep 2020 06:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgISEU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Sep 2020 00:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:54966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISEU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Sep 2020 00:20:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F48122208;
        Sat, 19 Sep 2020 04:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600489228;
        bh=uD6xAztbVsrxrxGE5nhe7BWP5qXoKvPMqGnZIlslD3o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fTF4twVG61mzrdWwiLBMPDRNeGh4VU0UXQ7oQzZHdTnYYixVY2H3p4+byNy3+9XbV
         92LAv96Ku38amK4nQiXjghYd/jqnvG0PMHx0w4bLS116tmX8oXh5mVMB3UR1ZwM+cv
         E/lM0HqwoUp2RB217XcVaRgox/YWM4/OLPebJK38=
Date:   Fri, 18 Sep 2020 21:20:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, christophe.leroy@csgroup.eu,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 10/15] selftests/vm: fix display of page size in
 map_hugetlb
Message-ID: <20200919042028.rpQMuOsNE%akpm@linux-foundation.org>
In-Reply-To: <20200918211925.7e97f0ef63d92f5cfe5ccbc5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: selftests/vm: fix display of page size in map_hugetlb

The displayed size is in bytes while the text says it is in kB.

Shift it by 10 to really display kBytes.

Link: https://lkml.kernel.org/r/e27481224564a93d14106e750de31189deaa8bc8.1598861977.git.christophe.leroy@csgroup.eu
Fixes: fa7b9a805c79 ("tools/selftest/vm: allow choosing mem size and page size in map_hugetlb")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/vm/map_hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/map_hugetlb.c~selftests-vm-fix-display-of-page-size-in-map_hugetlb
+++ a/tools/testing/selftests/vm/map_hugetlb.c
@@ -83,7 +83,7 @@ int main(int argc, char **argv)
 	}
 
 	if (shift)
-		printf("%u kB hugepages\n", 1 << shift);
+		printf("%u kB hugepages\n", 1 << (shift - 10));
 	else
 		printf("Default size hugepages\n");
 	printf("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
_
