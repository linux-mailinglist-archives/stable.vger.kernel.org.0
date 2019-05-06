Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D60C114E82
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfEFOkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727257AbfEFOkQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:40:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B37D206A3;
        Mon,  6 May 2019 14:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153615;
        bh=nDIUlaxkvmhOAQSd1f4i2fv1g2yrDhaWLZ590WwfUB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kM2rs7TR+kzrHthIW4mzf5SjyXvr6ZEvav/dbQFrFDn61pw0YiF0Kk4Il1lWMmmP5
         5yoBzYnZcwBOqUP5mGMuhHtGz3TjzHJfVHXBbLNM9Zf7yfo2qjIcEeZi9UuLm272Gb
         ykNrrUW/tRBf4sYUptcm4GoEAuV4biq/C8BeaCzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Kao <alankao@andestech.com>,
        Greentime Hu <greentime@andestech.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 33/99] riscv: fix accessing 8-byte variable from RV32
Date:   Mon,  6 May 2019 16:32:06 +0200
Message-Id: <20190506143056.938968443@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.899356316@linuxfoundation.org>
References: <20190506143053.899356316@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit dbee9c9c45846f003ec2f819710c2f4835630a6a ]

A memory save operation to 8-byte variable in RV32 is divided into
two sw instructions in the put_user macro.  The current fixup returns
execution flow to the second sw instead of the one after it.

This patch fixes this fixup code according to the load access part.

Signed-off-by: Alan Kao<alankao@andestech.com>
Cc: Greentime Hu <greentime@andestech.com>
Cc: Vincent Chen <deanbo422@gmail.com>
Signed-off-by: Palmer Dabbelt <palmer@sifive.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index 8c3e3e3c8be1..f0ea3156192d 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -307,7 +307,7 @@ do {								\
 		"	.balign 4\n"				\
 		"4:\n"						\
 		"	li %0, %6\n"				\
-		"	jump 2b, %1\n"				\
+		"	jump 3b, %1\n"				\
 		"	.previous\n"				\
 		"	.section __ex_table,\"a\"\n"		\
 		"	.balign " RISCV_SZPTR "\n"			\
-- 
2.20.1



