Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A94F81CB1
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731335AbfHEN0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:26:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731354AbfHEN0C (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:26:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD5E220651;
        Mon,  5 Aug 2019 13:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011562;
        bh=3Z6DPYk7EHqMo4PyHu7aIciu77HSTlyXUMfDnn5ZPgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/X1n+SI1TcWLR67MNhOmjKlC9Qm7nLxJJJm6xRj/e0ADK4SLXOHs9KjdsDcX9v4d
         VcUwmZ1G23r5+rZ7aBxesJpKRqwxdXtKEGpYKdNcaNK3kDkbbt2Q/KoUYAKTDdCXVe
         jVU3GwlxeYLt221y5PySFaLW2if6L8y3KBqgpkkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.2 109/131] parisc: Strip debug info from kernel before creating compressed vmlinuz
Date:   Mon,  5 Aug 2019 15:03:16 +0200
Message-Id: <20190805124959.261847620@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit e50beea8e7738377b4fa664078547be338038ff9 upstream.

Same as on x86-64, strip the .comment, .note and debug sections from the
Linux kernel before creating the compressed image for the boot loader.

Reported-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Reported-by: Sven Schnelle <svens@stackframe.org>
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/boot/compressed/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/parisc/boot/compressed/Makefile
+++ b/arch/parisc/boot/compressed/Makefile
@@ -56,7 +56,8 @@ $(obj)/misc.o: $(obj)/sizes.h
 CPPFLAGS_vmlinux.lds += -I$(objtree)/$(obj) -DBOOTLOADER
 $(obj)/vmlinux.lds: $(obj)/sizes.h
 
-$(obj)/vmlinux.bin: vmlinux
+OBJCOPYFLAGS_vmlinux.bin := -R .comment -R .note -S
+$(obj)/vmlinux.bin: vmlinux FORCE
 	$(call if_changed,objcopy)
 
 vmlinux.bin.all-y := $(obj)/vmlinux.bin


