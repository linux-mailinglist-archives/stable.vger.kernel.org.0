Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97CCB1EFDB
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfEOLiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731226AbfEOLb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:31:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28A5A206BF;
        Wed, 15 May 2019 11:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919886;
        bh=6zO7tVXG4/5IUdBroFzjK/pJRlz3x3muihcqwl8q3JA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCV4y51TQguAiyFowtvoomoQiInWXefBFY0DnSyDNXMt/ysgQwWdAjZYN90nEbzHN
         OMr4ac1glrq6pYBkcpPrP6SO7q7F++OPOzRJgx+nlQ3rX9LWZaFUVWDegme6MerQ/N
         7thILZXbOwln+nEhrpp+emVvLWO9Jw82uZLZUJjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.0 132/137] powerpc/booke64: set RI in default MSR
Date:   Wed, 15 May 2019 12:56:53 +0200
Message-Id: <20190515090703.457545678@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurentiu Tudor <laurentiu.tudor@nxp.com>

commit 5266e58d6cd90ac85c187d673093ad9cb649e16d upstream.

Set RI in the default kernel's MSR so that the architected way of
detecting unrecoverable machine check interrupts has a chance to work.
This is inline with the MSR setup of the rest of booke powerpc
architectures configured here.

Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/reg_booke.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/include/asm/reg_booke.h
+++ b/arch/powerpc/include/asm/reg_booke.h
@@ -41,7 +41,7 @@
 #if defined(CONFIG_PPC_BOOK3E_64)
 #define MSR_64BIT	MSR_CM
 
-#define MSR_		(MSR_ME | MSR_CE)
+#define MSR_		(MSR_ME | MSR_RI | MSR_CE)
 #define MSR_KERNEL	(MSR_ | MSR_64BIT)
 #define MSR_USER32	(MSR_ | MSR_PR | MSR_EE)
 #define MSR_USER64	(MSR_USER32 | MSR_64BIT)


