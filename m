Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944AB29C738
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409498AbgJ0N4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 09:56:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:43248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409433AbgJ0N4v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 09:56:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25EB021D42;
        Tue, 27 Oct 2020 13:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807010;
        bh=HetbI1naAvC+cEhHBmp/imWS6k7q8A6CMq+9QPveTDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KocYeDDq1Mza2l18f5K3ERHt5jRBjhqVoncuXjXccp2NpF3wCsp5JDxyaupB4ZZt2
         TxU2uJbFRZjuanf4YnioDIjGpYCnYDVb7Hjypw9TK5OWXWjg2GX6v+05KW3Hfc8BEP
         5Ej/Vs6UITAbmJTd6LE0uEyiijCDuPY82UoikGj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 010/112] lib/strscpy: Shut up KASAN false-positives in strscpy()
Date:   Tue, 27 Oct 2020 14:48:40 +0100
Message-Id: <20201027134901.039218681@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ryabinin <aryabinin@virtuozzo.com>

commit 1a3241ff10d038ecd096d03380327f2a0b5840a6 upstream.

strscpy() performs the word-at-a-time optimistic reads.  So it may may
access the memory past the end of the object, which is perfectly fine
since strscpy() doesn't use that (past-the-end) data and makes sure the
optimistic read won't cross a page boundary.

Use new read_word_at_a_time() to shut up the KASAN.

Note that this potentially could hide some bugs.  In example bellow,
stscpy() will copy more than we should (1-3 extra uninitialized bytes):

        char dst[8];
        char *src;

        src = kmalloc(5, GFP_KERNEL);
        memset(src, 0xff, 5);
        strscpy(dst, src, 8);

Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/string.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/string.c
+++ b/lib/string.c
@@ -202,7 +202,7 @@ ssize_t strscpy(char *dest, const char *
 	while (max >= sizeof(unsigned long)) {
 		unsigned long c, data;
 
-		c = *(unsigned long *)(src+res);
+		c = read_word_at_a_time(src+res);
 		if (has_zero(c, &data, &constants)) {
 			data = prep_zero_mask(c, data, &constants);
 			data = create_zero_mask(data);


