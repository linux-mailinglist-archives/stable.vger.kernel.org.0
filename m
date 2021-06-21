Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382683AEF32
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhFUQgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233008AbhFUQfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:35:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F82F61261;
        Mon, 21 Jun 2021 16:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292851;
        bh=Od5Mwtx5ni8Q84eaXsJKkNh8qUj7gma3kMNQUgdn7GU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPHaV5znIlbAggPPUHPG466ZKKBIMHdPh2x6t60JVa9qwtqat8n9T5X9S7YAdyvND
         bUfHdz2BOZYcFfTvCxE05W4yTBnamlKeTazOO1ytDB/iS1Dvz8IeGJmIMD0L96/R0N
         uWl666ryEz59nfc24mdBBNFnMoTZoCfZgfV85+NY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 115/146] s390/mcck: fix calculation of SIE critical section size
Date:   Mon, 21 Jun 2021 18:15:45 +0200
Message-Id: <20210621154918.685443648@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

commit 5bcbe3285fb614c49db6b238253f7daff7e66312 upstream.

The size of SIE critical section is calculated wrongly
as result of a missed subtraction in commit 0b0ed657fe00
("s390: remove critical section cleanup from entry.S")

Fixes: 0b0ed657fe00 ("s390: remove critical section cleanup from entry.S")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -1284,7 +1284,7 @@ ENDPROC(stack_overflow)
 	je	1f
 	larl	%r13,.Lsie_entry
 	slgr	%r9,%r13
-	larl	%r13,.Lsie_skip
+	lghi	%r13,.Lsie_skip - .Lsie_entry
 	clgr	%r9,%r13
 	jh	1f
 	oi	__LC_CPU_FLAGS+7, _CIF_MCCK_GUEST


