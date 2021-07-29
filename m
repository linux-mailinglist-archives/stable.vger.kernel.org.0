Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C29B3DA4F1
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238154AbhG2N5L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:57:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238094AbhG2N5C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:57:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F240160F00;
        Thu, 29 Jul 2021 13:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567019;
        bh=OvZM0uo7ApYMZJQ6dgxIeOIydNDASSSdsVU+Klxy6ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7D0wW7DCjb/nw+00Ze8YD7/l59k/iUKUtAkiOpYJw17HjYquGjw4xQz3824DDYHn
         Geh5lNgMrUdP73Afkz/K6kf8z0UR+IyswwsmBs/K6ZNYpxILaKC0vbPzktp/l7WTlc
         SYwna3JdxI043HIpSjGWOtudip6MtShqmx4E+uc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.4 01/21] selftest: fix build error in tools/testing/selftests/vm/userfaultfd.c
Date:   Thu, 29 Jul 2021 15:54:08 +0200
Message-Id: <20210729135142.965758452@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135142.920143237@linuxfoundation.org>
References: <20210729135142.920143237@linuxfoundation.org>
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
@@ -141,7 +141,7 @@ static void anon_allocate_area(void **al
 {
 	*alloc_area = mmap(NULL, nr_pages * page_size, PROT_READ | PROT_WRITE,
 			   MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
-	if (*alloc_area == MAP_FAILED)
+	if (*alloc_area == MAP_FAILED) {
 		fprintf(stderr, "mmap of anonymous memory failed");
 		*alloc_area = NULL;
 	}


