Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 484782E38FE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731570AbgL1NRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:17:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731554AbgL1NR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:17:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A5820728;
        Mon, 28 Dec 2020 13:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161433;
        bh=InEEN5TLcf6aB59Y6YcfDqtxH4ByJKED1/yu9sBITZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0VscWeWvj5hX0BS46hRvrawO4XHFKI+WSNI6em3UuEVYjaSQ2JlzFR+/coWmVS10
         yzR5C5OaHPINnyt3JqcOO3sYzZ5rDQHMK/Cca+z1t/H0ooXcexdcNi2oUHnjCUdoRr
         g8qIBFZSQPJjAHPLxxFJOsJOOmoa2bXHCuce1uxM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 212/242] powerpc/rtas: Fix typo of ibm,open-errinjct in RTAS filter
Date:   Mon, 28 Dec 2020 13:50:17 +0100
Message-Id: <20201228124915.107833640@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

commit f10881a46f8914428110d110140a455c66bdf27b upstream.

Commit bd59380c5ba4 ("powerpc/rtas: Restrict RTAS requests from userspace")
introduced the following error when invoking the errinjct userspace
tool:

  [root@ltcalpine2-lp5 librtas]# errinjct open
  [327884.071171] sys_rtas: RTAS call blocked - exploit attempt?
  [327884.071186] sys_rtas: token=0x26, nargs=0 (called by errinjct)
  errinjct: Could not open RTAS error injection facility
  errinjct: librtas: open: Unexpected I/O error

The entry for ibm,open-errinjct in rtas_filter array has a typo where
the "j" is omitted in the rtas call name. After fixing this typo the
errinjct tool functions again as expected.

  [root@ltcalpine2-lp5 linux]# errinjct open
  RTAS error injection facility open, token = 1

Fixes: bd59380c5ba4 ("powerpc/rtas: Restrict RTAS requests from userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201208195434.8289-1-tyreld@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/rtas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -1094,7 +1094,7 @@ static struct rtas_filter rtas_filters[]
 	{ "ibm,display-message", -1, 0, -1, -1, -1 },
 	{ "ibm,errinjct", -1, 2, -1, -1, -1, 1024 },
 	{ "ibm,close-errinjct", -1, -1, -1, -1, -1 },
-	{ "ibm,open-errinct", -1, -1, -1, -1, -1 },
+	{ "ibm,open-errinjct", -1, -1, -1, -1, -1 },
 	{ "ibm,get-config-addr-info2", -1, -1, -1, -1, -1 },
 	{ "ibm,get-dynamic-sensor-state", -1, 1, -1, -1, -1 },
 	{ "ibm,get-indices", -1, 2, 3, -1, -1 },


