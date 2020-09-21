Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0F1272EFE
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgIUQrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:47:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729760AbgIUQrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:47:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFBA423888;
        Mon, 21 Sep 2020 16:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706834;
        bh=DeR0aKI8WkL4uiBhR9N2qdwDYZpfrYva1bno0IxnhGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MInVX8tVNS5Mdx/QJMYiz08GiUyf8BggLfkAowDB0qEmLQr+Ke0cssFL3DMEgusZM
         0smD7Nc6bMiZJKatwgkkVdmxMf1KKZq595e8XjjmGor9SRQ45XfPDx58NqQD35Gtrb
         rl/zjx4uBHpgGG6iQOT3AQLFzb7m4p48AywaltKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 112/118] selftests/vm: fix display of page size in map_hugetlb
Date:   Mon, 21 Sep 2020 18:28:44 +0200
Message-Id: <20200921162041.591047289@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 1ec882fc81e3177faf055877310dbdb0c68eb7db upstream.

The displayed size is in bytes while the text says it is in kB.

Shift it by 10 to really display kBytes.

Fixes: fa7b9a805c79 ("tools/selftest/vm: allow choosing mem size and page size in map_hugetlb")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/e27481224564a93d14106e750de31189deaa8bc8.1598861977.git.christophe.leroy@csgroup.eu
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/vm/map_hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/map_hugetlb.c
+++ b/tools/testing/selftests/vm/map_hugetlb.c
@@ -83,7 +83,7 @@ int main(int argc, char **argv)
 	}
 
 	if (shift)
-		printf("%u kB hugepages\n", 1 << shift);
+		printf("%u kB hugepages\n", 1 << (shift - 10));
 	else
 		printf("Default size hugepages\n");
 	printf("Mapping %lu Mbytes\n", (unsigned long)length >> 20);


