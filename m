Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1FA5235A5
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391282AbfETMg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391279AbfETMg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:36:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9932216C4;
        Mon, 20 May 2019 12:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355786;
        bh=x62WriVRkN9FKAQvcN+jmk/ARSI//BBip78pCZHD35o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4Vu4e2G4ywWxIlwU80mLc84wlfF9z3n4fWONYj/sIKMmmSulAs3kiEnPdwWM1mcB
         ywZirRTRzJjX83H/DwE1lM9RzqIQlbSDCKT8cUHinCqwshYD6kM6C0tI+UOt7Y8G54
         q6MQZx3kMrefA7aReYbOiSa7PZioF2zou+CEtwZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Erhard F." <erhard_f@mailbox.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.1 123/128] powerpc/32s: fix flush_hash_pages() on SMP
Date:   Mon, 20 May 2019 14:15:10 +0200
Message-Id: <20190520115256.917618940@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 397d2300b08cdee052053e362018cdb6dd65eea2 upstream.

flush_hash_pages() runs with data translation off, so current
task_struct has to be accesssed using physical address.

Fixes: f7354ccac844 ("powerpc/32: Remove CURRENT_THREAD_INFO and rename TI_CPU")
Cc: stable@vger.kernel.org # v5.1+
Reported-by: Erhard F. <erhard_f@mailbox.org>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/hash_low_32.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/hash_low_32.S
+++ b/arch/powerpc/mm/hash_low_32.S
@@ -539,7 +539,8 @@ _GLOBAL(flush_hash_pages)
 #ifdef CONFIG_SMP
 	lis	r9, (mmu_hash_lock - PAGE_OFFSET)@ha
 	addi	r9, r9, (mmu_hash_lock - PAGE_OFFSET)@l
-	lwz	r8,TASK_CPU(r2)
+	tophys	(r8, r2)
+	lwz	r8, TASK_CPU(r8)
 	oris	r8,r8,9
 10:	lwarx	r0,0,r9
 	cmpi	0,r0,0


