Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7BA0E67CA
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732484AbfJ0VYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731856AbfJ0VYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:24:11 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B7002064A;
        Sun, 27 Oct 2019 21:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211451;
        bh=l+06AWxAeKb0gTOn8VVy4toEMu+SKlfr9RViXwvIcXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXupMkebjWBDnnQaw/Xkpj4VfXvVCubL1tvZGm+WD1m+yG8PdT1Z51lJB9oBAV/zt
         esIZ/7aFN75HXUR/+2kaipBdd4MN+R6dXMvNoVxwo8bVitHVgCDhxDeD+sPL/HV9yG
         HgPheExlimS1xxv2NxNUe8COHr43B6U0vdDrCHuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.3 156/197] xtensa: drop EXPORT_SYMBOL for outs*/ins*
Date:   Sun, 27 Oct 2019 22:01:14 +0100
Message-Id: <20191027203400.106459028@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit 8b39da985194aac2998dd9e3a22d00b596cebf1e upstream.

Custom outs*/ins* implementations are long gone from the xtensa port,
remove matching EXPORT_SYMBOLs.
This fixes the following build warnings issued by modpost since commit
15bfc2348d54 ("modpost: check for static EXPORT_SYMBOL* functions"):

  WARNING: "insb" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "insw" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "insl" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "outsb" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "outsw" [vmlinux] is a static EXPORT_SYMBOL
  WARNING: "outsl" [vmlinux] is a static EXPORT_SYMBOL

Cc: stable@vger.kernel.org
Fixes: d38efc1f150f ("xtensa: adopt generic io routines")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/kernel/xtensa_ksyms.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/xtensa/kernel/xtensa_ksyms.c
+++ b/arch/xtensa/kernel/xtensa_ksyms.c
@@ -119,13 +119,6 @@ EXPORT_SYMBOL(__invalidate_icache_range)
 // FIXME EXPORT_SYMBOL(screen_info);
 #endif
 
-EXPORT_SYMBOL(outsb);
-EXPORT_SYMBOL(outsw);
-EXPORT_SYMBOL(outsl);
-EXPORT_SYMBOL(insb);
-EXPORT_SYMBOL(insw);
-EXPORT_SYMBOL(insl);
-
 extern long common_exception_return;
 EXPORT_SYMBOL(common_exception_return);
 


