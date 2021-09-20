Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698B8411CCD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346026AbhITRNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:34308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346596AbhITRLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:11:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1CE761881;
        Mon, 20 Sep 2021 16:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157022;
        bh=sAj9XCu0LPl0fCzYsXX4deIdhAbtwFtZSsxZRuuHYMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8saccrqBi4FxZOnazlVJ4q1FJsVwsJMsSxxAcYmlATg+9cqFO/kAeeSfEw35J363
         hGPAL7r0qJ+YrQsnBEzTpI5OUjFR4ff8NY0RK353JRf9RoTcfKPcEsX1DoYJZuXWLP
         OwEafkm416bfQ6xyLUQsqolPROxoMpeMmvtwod34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Gorbik <gor@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 4.14 018/217] s390/disassembler: correct disassembly lines alignment
Date:   Mon, 20 Sep 2021 18:40:39 +0200
Message-Id: <20210920163925.225825451@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.vnet.ibm.com>

commit 26f4e759ef9b8a2bab1823d692ed6d56d40b66e3 upstream.

176.718956 Krnl Code: 00000000004d38b0: a54c0018        llihh   %r4,24
176.718956 	   00000000004d38b4: b9080014        agr     %r1,%r4
           ^
Using a tab to align disassembly lines which follow the first line with
"Krnl Code: " doesn't always work, e.g. if there is a prefix (timestamp
or syslog prefix) which is not 8 chars aligned. Go back to alignment
with spaces.

Fixes: b192571d1ae3 ("s390/disassembler: increase show_code buffer size")
Signed-off-by: Vasily Gorbik <gor@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/dis.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -2018,7 +2018,7 @@ void show_code(struct pt_regs *regs)
 		start += opsize;
 		pr_cont("%s", buffer);
 		ptr = buffer;
-		ptr += sprintf(ptr, "\n\t  ");
+		ptr += sprintf(ptr, "\n          ");
 		hops++;
 	}
 	pr_cont("\n");


