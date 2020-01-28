Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5636E14BB26
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgA1OLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:11:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728745AbgA1OLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:11:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7613324694;
        Tue, 28 Jan 2020 14:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220661;
        bh=ASF5vP46lpF5TKK1BJytUEm2I5lL2WyNXko7tgaDhic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAN9m/VwDTZ7OpNEmY2oeSAI4G9e2EO62C4o19lp9mRX7liDo/WsxQxAbS3Z2gBF5
         jU0R5vcjTL53IwabEh+2mg4feXXvYGVzWWfXir8NlAzArhZX9qCYJ2wXzO9yvreG+I
         rQmDryqm6OetZfSX4QrkTAAVFSFGIqdYuF1Jj360=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Hines <srhines@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 096/183] misc: sgi-xp: Properly initialize buf in xpc_get_rsvd_page_pa
Date:   Tue, 28 Jan 2020 15:05:15 +0100
Message-Id: <20200128135839.677193372@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135829.486060649@linuxfoundation.org>
References: <20200128135829.486060649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit b0576f9ecb5c51e9932531d23c447b2739261841 ]

Clang warns:

drivers/misc/sgi-xp/xpc_partition.c:73:14: warning: variable 'buf' is
uninitialized when used within its own initialization [-Wuninitialized]
        void *buf = buf;
              ~~~   ^~~
1 warning generated.

Arnd's explanation during review:

  /*
   * Returns the physical address of the partition's reserved page through
   * an iterative number of calls.
   *
   * On first call, 'cookie' and 'len' should be set to 0, and 'addr'
   * set to the nasid of the partition whose reserved page's address is
   * being sought.
   * On subsequent calls, pass the values, that were passed back on the
   * previous call.
   *
   * While the return status equals SALRET_MORE_PASSES, keep calling
   * this function after first copying 'len' bytes starting at 'addr'
   * into 'buf'. Once the return status equals SALRET_OK, 'addr' will
   * be the physical address of the partition's reserved page. If the
   * return status equals neither of these, an error as occurred.
   */
  static inline s64
  sn_partition_reserved_page_pa(u64 buf, u64 *cookie, u64 *addr, u64 *len)

  so *len is set to zero on the first call and tells the bios how many
  bytes are accessible at 'buf', and it does get updated by the BIOS to
  tell us how many bytes it needs, and then we allocate that and try again.

Fixes: 279290294662 ("[IA64-SGI] cleanup the way XPC locates the reserved page")
Link: https://github.com/ClangBuiltLinux/linux/issues/466
Suggested-by: Stephen Hines <srhines@google.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/sgi-xp/xpc_partition.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/sgi-xp/xpc_partition.c b/drivers/misc/sgi-xp/xpc_partition.c
index 6956f7e7d4392..ca5f0102daef4 100644
--- a/drivers/misc/sgi-xp/xpc_partition.c
+++ b/drivers/misc/sgi-xp/xpc_partition.c
@@ -70,7 +70,7 @@ xpc_get_rsvd_page_pa(int nasid)
 	unsigned long rp_pa = nasid;	/* seed with nasid */
 	size_t len = 0;
 	size_t buf_len = 0;
-	void *buf = buf;
+	void *buf = NULL;
 	void *buf_base = NULL;
 	enum xp_retval (*get_partition_rsvd_page_pa)
 		(void *, u64 *, unsigned long *, size_t *) =
-- 
2.20.1



