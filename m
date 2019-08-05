Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0682181B86
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729269AbfHENHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729777AbfHENHV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:07:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B66F216B7;
        Mon,  5 Aug 2019 13:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565010440;
        bh=njhFZQxy19PcglwTow94+N5gzFX0PX+0iAdPg690j6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=itJdKXjE/j/pPzpV4ZaHz0GkUp3L8Vq2yTOAYSH92NVBqnW6F/QR79Fd3eYeiWp+O
         WSeerrr/T6wXkfYCql7afrHgGU4yegvcAWJ3ymtDIDzVB3ay92vihYVL+zOafE1fZv
         xlDQd0Z2GEIZmdtw/HYLHW0n3wkZq6aRc4O4C4ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>,
        Jan Harkes <jaharkes@cs.cmu.edu>,
        Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Howells <dhowells@redhat.com>,
        Fabian Frederick <fabf@skynet.be>,
        Mikko Rapeli <mikko.rapeli@iki.fi>,
        Yann Droneaud <ydroneaud@opteya.com>,
        Zhouyang Jia <jiazhouyang09@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 24/53] coda: fix build using bare-metal toolchain
Date:   Mon,  5 Aug 2019 15:02:49 +0200
Message-Id: <20190805124930.725959344@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124927.973499541@linuxfoundation.org>
References: <20190805124927.973499541@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b2a57e334086602be56b74958d9f29b955cd157f ]

The kernel is self-contained project and can be built with bare-metal
toolchain.  But bare-metal toolchain doesn't define __linux__.  Because
of this u_quad_t type is not defined when using bare-metal toolchain and
codafs build fails.  This patch fixes it by defining u_quad_t type
unconditionally.

Link: http://lkml.kernel.org/r/3cbb40b0a57b6f9923a9d67b53473c0b691a3eaa.1558117389.git.jaharkes@cs.cmu.edu
Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
Signed-off-by: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: Yann Droneaud <ydroneaud@opteya.com>
Cc: Zhouyang Jia <jiazhouyang09@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/coda.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/coda.h b/include/linux/coda.h
index d30209b9cef81..0ca0c83fdb1c4 100644
--- a/include/linux/coda.h
+++ b/include/linux/coda.h
@@ -58,8 +58,7 @@ Mellon the rights to redistribute these changes without encumbrance.
 #ifndef _CODA_HEADER_
 #define _CODA_HEADER_
 
-#if defined(__linux__)
 typedef unsigned long long u_quad_t;
-#endif
+
 #include <uapi/linux/coda.h>
 #endif 
-- 
2.20.1



