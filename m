Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84136328765
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238181AbhCARXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237987AbhCARQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:16:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B90861606;
        Mon,  1 Mar 2021 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617176;
        bh=F3uOmjDRirqlt+F07n7sLAB9NP0IpsyjcYsORllsl2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=md/xotTxZbPa7/EV779be1vOdENgMqRDP5Ou6cAvvLtmA+uUgqDXA3R4nazP19vTX
         4+0k6DsQUkdmSMQGecn0W2B+FKX7olSmIJK2LiQD1mGEaPaCz9B+Jf/O+PhHfzzi7F
         BsA25SU+o2jqugx03umm8mxSj4sDPO53Zfpt9Dp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 230/247] sparc32: fix a user-triggerable oops in clear_user()
Date:   Mon,  1 Mar 2021 17:14:10 +0100
Message-Id: <20210301161042.956038531@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 7780918b36489f0b2f9a3749d7be00c2ceaec513 upstream.

Back in 2.1.29 the clear_user() guts (__bzero()) had been merged
with memset().  Unfortunately, while all exception handlers had been
copied, one of the exception table entries got lost.  As the result,
clear_user() starting at 128*n bytes before the end of page and
spanning between 8 and 127 bytes into the next page would oops when
the second page is unmapped.  It's trivial to reproduce - all
it takes is

main()
{
	int fd = open("/dev/zero", O_RDONLY);
	char *p = mmap(NULL, 16384, PROT_READ|PROT_WRITE,
			MAP_PRIVATE|MAP_ANON, -1, 0);
	munmap(p + 8192, 8192);
	read(fd, p + 8192 - 128, 192);
}

which had been oopsing since March 1997.  Says something about
the quality of test coverage... ;-/  And while today sparc32 port
is nearly dead, back in '97 it had been very much alive; in fact,
sparc64 had only been in mainline for 3 months by that point...

Cc: stable@kernel.org
Fixes: v2.1.29
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/lib/memset.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/lib/memset.S
+++ b/arch/sparc/lib/memset.S
@@ -142,6 +142,7 @@ __bzero:
 	ZERO_LAST_BLOCKS(%o0, 0x48, %g2)
 	ZERO_LAST_BLOCKS(%o0, 0x08, %g2)
 13:
+	EXT(12b, 13b, 21f)
 	be	8f
 	 andcc	%o1, 4, %g0
 


