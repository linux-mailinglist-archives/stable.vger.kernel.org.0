Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7161F32920B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243608AbhCAUie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:38:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:49318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242318AbhCAUba (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:31:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2997B6501D;
        Mon,  1 Mar 2021 18:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622115;
        bh=Qfn0aUat3ceZQ1ghd+EeB4wkAMI8sShpeAtkKyiVw5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DigOWceppACPXVr1OkAyQytyzAAm+lL9FO4qDGuvw6kWB2uW7o+SzqNyIq3e7Jxju
         pY/J6IRrRTQqGT+9wSYs6VFD34bJ/lqagOHSwhd4Uk2iLKzStSblkg+hmo2wgx0+sR
         0MHFmDxZQncQAAGAsMrfTauOkWpKO+CasDllMVAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.11 732/775] s390/vtime: fix inline assembly clobber list
Date:   Mon,  1 Mar 2021 17:15:00 +0100
Message-Id: <20210301161237.512333324@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

commit b29c5093820d333eef22f58cd04ec0d089059c39 upstream.

The stck/stckf instruction used within the inline assembly within
do_account_vtime() changes the condition code. This is not reflected
with the clobber list, and therefore might result in incorrect code
generation.

It seems unlikely that the compiler could generate incorrect code
considering the surrounding C code, but it must still be fixed.

Cc: <stable@vger.kernel.org>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/vtime.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -136,7 +136,8 @@ static int do_account_vtime(struct task_
 		"	stck	%1"	/* Store current tod clock value */
 #endif
 		: "=Q" (S390_lowcore.last_update_timer),
-		  "=Q" (S390_lowcore.last_update_clock));
+		  "=Q" (S390_lowcore.last_update_clock)
+		: : "cc");
 	clock = S390_lowcore.last_update_clock - clock;
 	timer -= S390_lowcore.last_update_timer;
 


