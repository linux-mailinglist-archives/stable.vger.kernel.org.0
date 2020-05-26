Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CADE1E2D68
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391285AbgEZTJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:09:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390033AbgEZTJu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:09:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 552D6208A7;
        Tue, 26 May 2020 19:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520189;
        bh=dx72DlEhizNWX/XIZA22NubdAcBm3H7jRg6ps1o/qVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzV70HqIYZPKrDIcO8Gdzm7lrnmAmzpvE4EL1OOyWdxwCs8WZeLC4Vx0wdKv6KKPP
         k55bA9zsyL8PD0OrAX6MJsDLE+/kMeEFq14cjNUsI8vXixyr01VmZ83z6VevETWxYz
         8POvaGhAFg4WX+aDfZsFu2L7lBNYmuKKicKlqd+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Philipp Rudo <prudo@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 093/111] s390/kaslr: add support for R_390_JMP_SLOT relocation type
Date:   Tue, 26 May 2020 20:53:51 +0200
Message-Id: <20200526183941.742153609@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

commit 4c1cbcbd6c56c79de2c07159be4f55386bb0bef2 upstream.

With certain kernel configurations, the R_390_JMP_SLOT relocation type
might be generated, which is not expected by the KASLR relocation code,
and the kernel stops with the message "Unknown relocation type".

This was found with a zfcpdump kernel config, where CONFIG_MODULES=n
and CONFIG_VFIO=n. In that case, symbol_get() is used on undefined
__weak symbols in virt/kvm/vfio.c, which results in the generation
of R_390_JMP_SLOT relocation types.

Fix this by handling R_390_JMP_SLOT similar to R_390_GLOB_DAT.

Fixes: 805bc0bc238f ("s390/kernel: build a relocatable kernel")
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Reviewed-by: Philipp Rudo <prudo@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/machine_kexec_reloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/s390/kernel/machine_kexec_reloc.c
+++ b/arch/s390/kernel/machine_kexec_reloc.c
@@ -28,6 +28,7 @@ int arch_kexec_do_relocs(int r_type, voi
 		break;
 	case R_390_64:		/* Direct 64 bit.  */
 	case R_390_GLOB_DAT:
+	case R_390_JMP_SLOT:
 		*(u64 *)loc = val;
 		break;
 	case R_390_PC16:	/* PC relative 16 bit.	*/


