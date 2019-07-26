Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFEAB76E23
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfGZPi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388182AbfGZP1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:27:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBF6A22CBD;
        Fri, 26 Jul 2019 15:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154822;
        bh=GH0024jItE3M+mrjJFsl1zzLd5bi+P+GwkHqwepwIG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FrT0P757tt40iw3Z/r78Yd3FbiOfimvQSiWdR1Vh062JVJms7i9Vg4tWf7aaEgU6s
         XYvG6ozc3Aj59GwkthMWDw9I8JPcP/HRVC8hUFJGUATV0hlmoaKw4wbCFDwAC8XEM/
         3iH8BrKxjnN+TWJ3obgAfRukfyHLhld0ru5PFazo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank de Brabander <debrabander@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 36/66] selftests: txring_overwrite: fix incorrect test of mmap() return value
Date:   Fri, 26 Jul 2019 17:24:35 +0200
Message-Id: <20190726152305.920273600@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank de Brabander <debrabander@gmail.com>

[ Upstream commit cecaa76b2919aac2aa584ce476e9fcd5b084add5 ]

If mmap() fails it returns MAP_FAILED, which is defined as ((void *) -1).
The current if-statement incorrectly tests if *ring is NULL.

Fixes: 358be656406d ("selftests/net: add txring_overwrite")
Signed-off-by: Frank de Brabander <debrabander@gmail.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/txring_overwrite.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/txring_overwrite.c
+++ b/tools/testing/selftests/net/txring_overwrite.c
@@ -113,7 +113,7 @@ static int setup_tx(char **ring)
 
 	*ring = mmap(0, req.tp_block_size * req.tp_block_nr,
 		     PROT_READ | PROT_WRITE, MAP_SHARED, fdt, 0);
-	if (!*ring)
+	if (*ring == MAP_FAILED)
 		error(1, errno, "mmap");
 
 	return fdt;


