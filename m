Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F741B3E51
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730860AbgDVK1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:27:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730849AbgDVK1S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:27:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B9B320784;
        Wed, 22 Apr 2020 10:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551236;
        bh=gBGl2Mpr3gMecv69cjvXn7IuOzZ3+xBLzvfmu0V5t70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EheM5fU1QZkwz5rZOnKtYcHC1vrI2vQa4rhVj9qxt0Gmid5CaZ53CJL926CTE0LIn
         /A5Z//ROfxd/SKqBP2dpVKroFpEyXkdR7nAeJQ5hiyDf+Hhvn60Cj66t/sZGXyzh/1
         j2eOiWrfmA7d6Ijx/h+/k4sNpe7caY6LJqtv1cpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.6 154/166] tty: evh_bytechan: Fix out of bounds accesses
Date:   Wed, 22 Apr 2020 11:58:01 +0200
Message-Id: <20200422095105.030657420@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>

commit 3670664b5da555a2a481449b3baafff113b0ac35 upstream.

ev_byte_channel_send() assumes that its third argument is a 16 byte
array. Some places where it is called it may not be (or we can't
easily tell if it is). Newer compilers have started producing warnings
about this, so make sure we actually pass a 16 byte array.

There may be more elegant solutions to this, but the driver is quite
old and hasn't been updated in many years.

The warnings (from a powerpc allyesconfig build) are:

  In file included from include/linux/byteorder/big_endian.h:5,
                   from arch/powerpc/include/uapi/asm/byteorder.h:14,
                   from include/asm-generic/bitops/le.h:6,
                   from arch/powerpc/include/asm/bitops.h:250,
                   from include/linux/bitops.h:29,
                   from include/linux/kernel.h:12,
                   from include/asm-generic/bug.h:19,
                   from arch/powerpc/include/asm/bug.h:109,
                   from include/linux/bug.h:5,
                   from include/linux/mmdebug.h:5,
                   from include/linux/gfp.h:5,
                   from include/linux/slab.h:15,
                   from drivers/tty/ehv_bytechan.c:24:
  drivers/tty/ehv_bytechan.c: In function ‘ehv_bc_udbg_putc’:
  arch/powerpc/include/asm/epapr_hcalls.h:298:20: warning: array subscript 1 is outside array bounds of ‘const char[1]’ [-Warray-bounds]
    298 |  r6 = be32_to_cpu(p[1]);
  include/uapi/linux/byteorder/big_endian.h:40:51: note: in definition of macro ‘__be32_to_cpu’
     40 | #define __be32_to_cpu(x) ((__force __u32)(__be32)(x))
        |                                                   ^
  arch/powerpc/include/asm/epapr_hcalls.h:298:7: note: in expansion of macro ‘be32_to_cpu’
    298 |  r6 = be32_to_cpu(p[1]);
        |       ^~~~~~~~~~~
  drivers/tty/ehv_bytechan.c:166:13: note: while referencing ‘data’
    166 | static void ehv_bc_udbg_putc(char c)
        |             ^~~~~~~~~~~~~~~~

Fixes: dcd83aaff1c8 ("tty/powerpc: introduce the ePAPR embedded hypervisor byte channel driver")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
[mpe: Trim warnings from change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200109183912.5fcb52aa@canb.auug.org.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/ehv_bytechan.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -136,6 +136,21 @@ static int find_console_handle(void)
 	return 1;
 }
 
+static unsigned int local_ev_byte_channel_send(unsigned int handle,
+					       unsigned int *count,
+					       const char *p)
+{
+	char buffer[EV_BYTE_CHANNEL_MAX_BYTES];
+	unsigned int c = *count;
+
+	if (c < sizeof(buffer)) {
+		memcpy(buffer, p, c);
+		memset(&buffer[c], 0, sizeof(buffer) - c);
+		p = buffer;
+	}
+	return ev_byte_channel_send(handle, count, p);
+}
+
 /*************************** EARLY CONSOLE DRIVER ***************************/
 
 #ifdef CONFIG_PPC_EARLY_DEBUG_EHV_BC
@@ -154,7 +169,7 @@ static void byte_channel_spin_send(const
 
 	do {
 		count = 1;
-		ret = ev_byte_channel_send(CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE,
+		ret = local_ev_byte_channel_send(CONFIG_PPC_EARLY_DEBUG_EHV_BC_HANDLE,
 					   &count, &data);
 	} while (ret == EV_EAGAIN);
 }
@@ -221,7 +236,7 @@ static int ehv_bc_console_byte_channel_s
 	while (count) {
 		len = min_t(unsigned int, count, EV_BYTE_CHANNEL_MAX_BYTES);
 		do {
-			ret = ev_byte_channel_send(handle, &len, s);
+			ret = local_ev_byte_channel_send(handle, &len, s);
 		} while (ret == EV_EAGAIN);
 		count -= len;
 		s += len;
@@ -401,7 +416,7 @@ static void ehv_bc_tx_dequeue(struct ehv
 			    CIRC_CNT_TO_END(bc->head, bc->tail, BUF_SIZE),
 			    EV_BYTE_CHANNEL_MAX_BYTES);
 
-		ret = ev_byte_channel_send(bc->handle, &len, bc->buf + bc->tail);
+		ret = local_ev_byte_channel_send(bc->handle, &len, bc->buf + bc->tail);
 
 		/* 'len' is valid only if the return code is 0 or EV_EAGAIN */
 		if (!ret || (ret == EV_EAGAIN))


