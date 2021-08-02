Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D4C3DD7E1
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234050AbhHBNs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:58622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234238AbhHBNsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:48:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFBCD61156;
        Mon,  2 Aug 2021 13:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912084;
        bh=tHOekwRJ4MeSn4j5FHLQaDM0EqXA9pI/JdOvNmo6hXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEKD4tW/xABvPbg0RysUU8FkODry51ZAmxzDcFtQ81+IK97RsV+MoCw+gKG0ZNDTF
         ek86oUf01M106H6PRdTTyF2OR40sbXehpBTaQsA9pHB/syIvmLwYVVNN931p6/vvpg
         ujq7b8mBBKTnAGVWSPu/7wx6zGpxLS7j1pzs1v+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 4.14 01/38] selftest: fix build error in tools/testing/selftests/vm/userfaultfd.c
Date:   Mon,  2 Aug 2021 15:44:23 +0200
Message-Id: <20210802134334.884634600@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134334.835358048@linuxfoundation.org>
References: <20210802134334.835358048@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

When backporting 0db282ba2c12 ("selftest: use mmap instead of
posix_memalign to allocate memory") to this stable branch, I forgot a {
breaking the build.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/vm/userfaultfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/vm/userfaultfd.c
+++ b/tools/testing/selftests/vm/userfaultfd.c
@@ -131,7 +131,7 @@ static void anon_allocate_area(void **al
 {
 	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
 			   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (*alloc_area == MAP_FAILED)
+	if (*alloc_area == MAP_FAILED) {
 		fprintf(stderr, "mmap of anonymous memory failed");
 		*alloc_area = NULL;
 	}


