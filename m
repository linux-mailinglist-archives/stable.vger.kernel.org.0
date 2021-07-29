Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72CB3DA4CD
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237764AbhG2N4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:56:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbhG2N4T (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:56:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BCE06023F;
        Thu, 29 Jul 2021 13:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627566975;
        bh=tHOekwRJ4MeSn4j5FHLQaDM0EqXA9pI/JdOvNmo6hXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BKaO6sh97jZ/K6zNQHOT87/jfw+WN4ggOCizgsoymkhKx2Tarx7cX1ndbFCIJGLW+
         TID8cwIcIKrMsXxQFlaWW2XoJquXUmpQvAbuliXW4g7Oxwh1S7RUNN7mWoy4x+tUHR
         rSu8BDQiHCMg/1/Ruux7WpSF2PM5/kUUojhBr3CI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 4.19 01/17] selftest: fix build error in tools/testing/selftests/vm/userfaultfd.c
Date:   Thu, 29 Jul 2021 15:54:02 +0200
Message-Id: <20210729135137.306383353@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.260993951@linuxfoundation.org>
References: <20210729135137.260993951@linuxfoundation.org>
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


