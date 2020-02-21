Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABD816733A
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732329AbgBUIK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:10:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:45640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732322AbgBUIK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:10:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59B8A20722;
        Fri, 21 Feb 2020 08:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272624;
        bh=ab0ALA7QeyFFt8xfeX1sv16lhosGZFNhWcq5ie5xykg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DIiK+6LEdtN8olsT1rJYyqVVC4gOUJVVXJ5U4MN8WTVLnBXz5NgaDkdm2JUJaKSY2
         IuGzoBITV0olEvv6FEx9yGjNgxAS+VWYiiV1bGi22ZlHEfkcrGvR5Ogy/eUcseIJtr
         K8AO68vL6L/8o44+KlLjOgP/v9tP+f+752hDSy8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhengyuan Liu <liuzhengyuan@kylinos.cn>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 212/344] raid6/test: fix a compilation warning
Date:   Fri, 21 Feb 2020 08:40:11 +0100
Message-Id: <20200221072408.444783593@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengyuan Liu <liuzhengyuan@kylinos.cn>

[ Upstream commit 5e5ac01c2b8802921fee680518a986011cb59820 ]

The compilation warning is redefination showed as following:

        In file included from tables.c:2:
        ../../../include/linux/export.h:180: warning: "EXPORT_SYMBOL" redefined
         #define EXPORT_SYMBOL(sym)  __EXPORT_SYMBOL(sym, "")

        In file included from tables.c:1:
        ../../../include/linux/raid/pq.h:61: note: this is the location of the previous definition
         #define EXPORT_SYMBOL(sym)

Fixes: 69a94abb82ee ("export.h, genksyms: do not make genksyms calculate CRC of trimmed symbols")
Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/raid/pq.h | 2 ++
 lib/raid6/mktables.c    | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 0b6e7ad9cd2a8..e0ddb47f44020 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -58,7 +58,9 @@ extern const char raid6_empty_zero_page[PAGE_SIZE];
 #define enable_kernel_altivec()
 #define disable_kernel_altivec()
 
+#undef	EXPORT_SYMBOL
 #define EXPORT_SYMBOL(sym)
+#undef	EXPORT_SYMBOL_GPL
 #define EXPORT_SYMBOL_GPL(sym)
 #define MODULE_LICENSE(licence)
 #define MODULE_DESCRIPTION(desc)
diff --git a/lib/raid6/mktables.c b/lib/raid6/mktables.c
index 9c485df1308fb..f02e10fa62381 100644
--- a/lib/raid6/mktables.c
+++ b/lib/raid6/mktables.c
@@ -56,8 +56,8 @@ int main(int argc, char *argv[])
 	uint8_t v;
 	uint8_t exptbl[256], invtbl[256];
 
-	printf("#include <linux/raid/pq.h>\n");
 	printf("#include <linux/export.h>\n");
+	printf("#include <linux/raid/pq.h>\n");
 
 	/* Compute multiplication table */
 	printf("\nconst u8  __attribute__((aligned(256)))\n"
-- 
2.20.1



