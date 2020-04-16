Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81201ACBDA
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896134AbgDPNaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896135AbgDPNaA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:30:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 000C0206E9;
        Thu, 16 Apr 2020 13:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043800;
        bh=OAYfl77dFe7z5NHt4SZRihGZVn4j8EZMzz9u7uf5uoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sG29FhVPHxc+V+cfRRfyKqaie2/pbmOAQrFM+RGvUND9u5HkbjWGpzjghIxYP15IX
         mQAC9UraDrPgIn21nPT4EVK8RhCZeWUlpH52ixSYh6PyVk7lpteAJIKoUDnbm1iqrn
         7emJZd8Vd6jYYM3wKFECn6Y4wKH5QvwjIdqZrZfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 4.19 078/146] x86/entry/32: Add missing ASM_CLAC to general_protection entry
Date:   Thu, 16 Apr 2020 15:23:39 +0200
Message-Id: <20200416131253.580131849@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 3d51507f29f2153a658df4a0674ec5b592b62085 upstream.

All exception entry points must have ASM_CLAC right at the
beginning. The general_protection entry is missing one.

Fixes: e59d1b0a2419 ("x86-32, smap: Add STAC/CLAC instructions to 32-bit kernel entry")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Reviewed-by: Andy Lutomirski <luto@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200225220216.219537887@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_32.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1489,6 +1489,7 @@ ENTRY(int3)
 END(int3)
 
 ENTRY(general_protection)
+	ASM_CLAC
 	pushl	$do_general_protection
 	jmp	common_exception
 END(general_protection)


