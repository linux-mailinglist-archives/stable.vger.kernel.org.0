Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C1E50833
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbfFXKNy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:13:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728715AbfFXKEC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:04:02 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B92E213F2;
        Mon, 24 Jun 2019 10:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370641;
        bh=0Tuv9WLmua8GzdXQkqqEv0t3CuaXw/uKeuI6XH6NamM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjBMFrSo0ZCcNVAJQJfAxh2qvoNznEp+yKsvJFZy+pywSxOwkCvqycUFTdzZaMRFk
         hPoBSVOhD5ItfPUWSEAjfG0dlJc4kcMOQlPgR1O2ZORxRj18PJ2T7LE7ACwzxQJWbn
         Qqrsedaqjr9HwL1KM5sNFwk8SxZ5eCtXnxBuyeZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/90] s390/jump_label: Use "jdd" constraint on gcc9
Date:   Mon, 24 Jun 2019 17:56:00 +0800
Message-Id: <20190624092314.669022460@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 146448524bddbf6dfc62de31957e428de001cbda ]

[heiko.carstens@de.ibm.com]:
-----
Laura Abbott reported that the kernel doesn't build anymore with gcc 9,
due to the "X" constraint. Ilya provided the gcc 9 patch "S/390:
Introduce jdd constraint" which introduces the new "jdd" constraint
which fixes this.
-----

The support for section anchors on S/390 introduced in gcc9 has changed
the behavior of "X" constraint, which can now produce register
references. Since existing constraints, in particular, "i", do not fit
the intended use case on S/390, the new machine-specific "jdd"
constraint was introduced. This patch makes jump labels use "jdd"
constraint when building with gcc9.

Reported-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/jump_label.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jump_label.h
index 40f651292aa7..9c7dc970e966 100644
--- a/arch/s390/include/asm/jump_label.h
+++ b/arch/s390/include/asm/jump_label.h
@@ -10,6 +10,12 @@
 #define JUMP_LABEL_NOP_SIZE 6
 #define JUMP_LABEL_NOP_OFFSET 2
 
+#if __GNUC__ < 9
+#define JUMP_LABEL_STATIC_KEY_CONSTRAINT "X"
+#else
+#define JUMP_LABEL_STATIC_KEY_CONSTRAINT "jdd"
+#endif
+
 /*
  * We use a brcl 0,2 instruction for jump labels at compile time so it
  * can be easily distinguished from a hotpatch generated instruction.
@@ -19,9 +25,9 @@ static __always_inline bool arch_static_branch(struct static_key *key, bool bran
 	asm_volatile_goto("0:	brcl 0,"__stringify(JUMP_LABEL_NOP_OFFSET)"\n"
 		".pushsection __jump_table, \"aw\"\n"
 		".balign 8\n"
-		".quad 0b, %l[label], %0\n"
+		".quad 0b, %l[label], %0+%1\n"
 		".popsection\n"
-		: : "X" (&((char *)key)[branch]) : : label);
+		: : JUMP_LABEL_STATIC_KEY_CONSTRAINT (key), "i" (branch) : : label);
 
 	return false;
 label:
@@ -33,9 +39,9 @@ static __always_inline bool arch_static_branch_jump(struct static_key *key, bool
 	asm_volatile_goto("0:	brcl 15, %l[label]\n"
 		".pushsection __jump_table, \"aw\"\n"
 		".balign 8\n"
-		".quad 0b, %l[label], %0\n"
+		".quad 0b, %l[label], %0+%1\n"
 		".popsection\n"
-		: : "X" (&((char *)key)[branch]) : : label);
+		: : JUMP_LABEL_STATIC_KEY_CONSTRAINT (key), "i" (branch) : : label);
 
 	return false;
 label:
-- 
2.20.1



