Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A77535C092
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240306AbhDLJOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:14:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:34282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240869AbhDLJLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BAC561379;
        Mon, 12 Apr 2021 09:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218422;
        bh=ycZ+K1QVjJVrFHKx6vy53aD6c9O5+ao7tn+zuFkruNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDcpZb1BC2PX9x5N/tTcWLWwvL7mZuOh/bedjF1etgxi0pFTNL97gwWEOhYM7jEpA
         JcNMF2SNtGvIAJPQOzF2JXjoO193Imp69XtT/EwPhNfJVOG8L2GqhDp0USWKZUClhR
         uJr0VpABhDHgCxN19etfaALmq9deW5YxbWkH5NEE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.11 192/210] lockdep: Address clang -Wformat warning printing for %hd
Date:   Mon, 12 Apr 2021 10:41:37 +0200
Message-Id: <20210412084022.410153507@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 6d48b7912cc72275dc7c59ff961c8bac7ef66a92 upstream.

Clang doesn't like format strings that truncate a 32-bit
value to something shorter:

  kernel/locking/lockdep.c:709:4: error: format specifies type 'short' but the argument has type 'int' [-Werror,-Wformat]

In this case, the warning is a slightly questionable, as it could realize
that both class->wait_type_outer and class->wait_type_inner are in fact
8-bit struct members, even though the result of the ?: operator becomes an
'int'.

However, there is really no point in printing the number as a 16-bit
'short' rather than either an 8-bit or 32-bit number, so just change
it to a normal %d.

Fixes: de8f5e4f2dc1 ("lockdep: Introduce wait-type checks")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210322115531.3987555-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/lockdep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -705,7 +705,7 @@ static void print_lock_name(struct lock_
 
 	printk(KERN_CONT " (");
 	__print_lock_name(class);
-	printk(KERN_CONT "){%s}-{%hd:%hd}", usage,
+	printk(KERN_CONT "){%s}-{%d:%d}", usage,
 			class->wait_type_outer ?: class->wait_type_inner,
 			class->wait_type_inner);
 }


