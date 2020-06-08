Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627E71F2CC8
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgFHXPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729259AbgFHXPx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 844A120760;
        Mon,  8 Jun 2020 23:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658153;
        bh=LfOx7hZICOMMpNKBAODLweZ8DDtcz6noxEHhmIyjwqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsZc8GiZ2mi2B9afjLLJEM4MNiHjNP5qTEsj+uDvsQj7ZDafy7dbrtPPgKTN3XCDL
         m2vHTlid0/tIju00z87CW4D4eHKXZ71XMWLSfIqfXmZoUiQXlGgXNYX1pr3c0GOpq/
         ivw1f+cZ3m3gtz0NUM7sMSYZ1udYYqrtUF4v1OIs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Philipp Rudo <prudo@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 185/606] s390/kaslr: add support for R_390_JMP_SLOT relocation type
Date:   Mon,  8 Jun 2020 19:05:10 -0400
Message-Id: <20200608231211.3363633-185-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 arch/s390/kernel/machine_kexec_reloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kernel/machine_kexec_reloc.c b/arch/s390/kernel/machine_kexec_reloc.c
index d5035de9020e..b7182cec48dc 100644
--- a/arch/s390/kernel/machine_kexec_reloc.c
+++ b/arch/s390/kernel/machine_kexec_reloc.c
@@ -28,6 +28,7 @@ int arch_kexec_do_relocs(int r_type, void *loc, unsigned long val,
 		break;
 	case R_390_64:		/* Direct 64 bit.  */
 	case R_390_GLOB_DAT:
+	case R_390_JMP_SLOT:
 		*(u64 *)loc = val;
 		break;
 	case R_390_PC16:	/* PC relative 16 bit.	*/
-- 
2.25.1

