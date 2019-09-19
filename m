Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F0FB8593
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406860AbfISWWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406853AbfISWW3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:22:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69BA121927;
        Thu, 19 Sep 2019 22:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931748;
        bh=4pzk7W34Hwiym1j70wpXjtgVm/YZFf5dNu8qSh4DBXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OqomM5ShHsZ5G6UDpdAWEfxs6rcf+aLxfX40qJRXrvRy2FqNX8WuUdbl7CtkJdsaE
         KtZpknYtXntzKcmUeLEgUAPw1uIFQrrY0ESMBJoC5QSgDNp54JBbSzrOkY1VudgLEI
         aysrsw65M1B6auDsiyLacJOk/0SuLpPy+MSNt2UE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Ganesan Ramalingam <ganesanr@broadcom.com>,
        James Hogan <jhogan@kernel.org>,
        Jayachandran C <jnair@caviumnetworks.com>,
        John Crispin <john@phrozen.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 25/56] MIPS: netlogic: xlr: Remove erroneous check in nlm_fmn_send()
Date:   Fri, 20 Sep 2019 00:04:06 +0200
Message-Id: <20190919214755.209045371@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214742.483643642@linuxfoundation.org>
References: <20190919214742.483643642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@mips.com>

commit 02eec6c9fc0cb13169cc97a6139771768791f92b upstream.

In nlm_fmn_send() we have a loop which attempts to send a message
multiple times in order to handle the transient failure condition of a
lack of available credit. When examining the status register to detect
the failure we check for a condition that can never be true, which falls
foul of gcc 8's -Wtautological-compare:

  In file included from arch/mips/netlogic/common/irq.c:65:
  ./arch/mips/include/asm/netlogic/xlr/fmn.h: In function 'nlm_fmn_send':
  ./arch/mips/include/asm/netlogic/xlr/fmn.h:304:22: error: bitwise
    comparison always evaluates to false [-Werror=tautological-compare]
     if ((status & 0x2) == 1)
                        ^~

If the path taken if this condition were true all we do is print a
message to the kernel console. Since failures seem somewhat expected
here (making the console message questionable anyway) and the condition
has clearly never evaluated true we simply remove it, rather than
attempting to fix it to check status correctly.

Signed-off-by: Paul Burton <paul.burton@mips.com>
Patchwork: https://patchwork.linux-mips.org/patch/20174/
Cc: Ganesan Ramalingam <ganesanr@broadcom.com>
Cc: James Hogan <jhogan@kernel.org>
Cc: Jayachandran C <jnair@caviumnetworks.com>
Cc: John Crispin <john@phrozen.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/netlogic/xlr/fmn.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/mips/include/asm/netlogic/xlr/fmn.h
+++ b/arch/mips/include/asm/netlogic/xlr/fmn.h
@@ -301,8 +301,6 @@ static inline int nlm_fmn_send(unsigned
 	for (i = 0; i < 8; i++) {
 		nlm_msgsnd(dest);
 		status = nlm_read_c2_status0();
-		if ((status & 0x2) == 1)
-			pr_info("Send pending fail!\n");
 		if ((status & 0x4) == 0)
 			return 0;
 	}


