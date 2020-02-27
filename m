Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05DE171C13
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388264AbgB0OId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:08:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388252AbgB0OId (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:08:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34FCF21D7E;
        Thu, 27 Feb 2020 14:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812512;
        bh=7oJbFU+bhBED6CuMJZtavCeSHxcTQ/IBOQ85mSsX9oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xHY8iYb3b3qBVXPBDQ0KCz2whBX+ZHnzvVs2kVedbsJxhmkvph8PJAmRDEPHBwNKC
         5yxEMD8fzf7OybR0CrNiOLnHR1LNU59BhZ/iaNPu2VUGPYpABrFWAkb7Z5PPZQ3HV7
         17FDmH0b/kN/WeBX8ct3WY8/73RvZug7iKxgadmc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 046/135] powerpc/entry: Fix an #if which should be an #ifdef in entry_32.S
Date:   Thu, 27 Feb 2020 14:36:26 +0100
Message-Id: <20200227132235.935587437@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 9eb425b2e04e0e3006adffea5bf5f227a896f128 upstream.

Fixes: 12c3f1fd87bf ("powerpc/32s: get rid of CPU_FTR_601 feature")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/a99fc0ad65b87a1ba51cfa3e0e9034ee294c3e07.1582034961.git.christophe.leroy@c-s.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/entry_32.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -778,7 +778,7 @@ fast_exception_return:
 1:	lis	r3,exc_exit_restart_end@ha
 	addi	r3,r3,exc_exit_restart_end@l
 	cmplw	r12,r3
-#if CONFIG_PPC_BOOK3S_601
+#ifdef CONFIG_PPC_BOOK3S_601
 	bge	2b
 #else
 	bge	3f
@@ -786,7 +786,7 @@ fast_exception_return:
 	lis	r4,exc_exit_restart@ha
 	addi	r4,r4,exc_exit_restart@l
 	cmplw	r12,r4
-#if CONFIG_PPC_BOOK3S_601
+#ifdef CONFIG_PPC_BOOK3S_601
 	blt	2b
 #else
 	blt	3f


