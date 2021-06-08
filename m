Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E6039FF34
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhFHSb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234138AbhFHSbL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:31:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0445613BC;
        Tue,  8 Jun 2021 18:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623176957;
        bh=wd+BPha1Nb5yGMu5F8sdBCuibHKWsfyuWB9Y2bemk3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKv/bpk45/PMetoWIkjxGtcCplvRjhHW9/5tyYzsFhE3e0bzaEhjQESwDV3ZOpb4T
         0r7vdxrjvbG5bPLFm+cIEY9BihJccrJ1JWl6wkZ5fH+vd6r2mSC+FpEoVwYysixQ9L
         xWBqTGCrI00SbDwDb0xKZOykvgDMEXc2K98JG8mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 01/23] efi: cper: fix snprintf() use in cper_dimm_err_location()
Date:   Tue,  8 Jun 2021 20:26:53 +0200
Message-Id: <20210608175926.575148730@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175926.524658689@linuxfoundation.org>
References: <20210608175926.524658689@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit 942859d969de7f6f7f2659a79237a758b42782da ]

snprintf() should be given the full buffer size, not one less. And it
guarantees nul-termination, so doing it manually afterwards is
pointless.

It's even potentially harmful (though probably not in practice because
CPER_REC_LEN is 256), due to the "return how much would have been
written had the buffer been big enough" semantics. I.e., if the bank
and/or device strings are long enough that the "DIMM location ..."
output gets truncated, writing to msg[n] is a buffer overflow.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Fixes: 3760cd20402d4 ("CPER: Adjust code flow of some functions")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/cper.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index c0e54396f250..dc8d2603612e 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -257,8 +257,7 @@ static int cper_dimm_err_location(struct cper_mem_err_compact *mem, char *msg)
 	if (!msg || !(mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE))
 		return 0;
 
-	n = 0;
-	len = CPER_REC_LEN - 1;
+	len = CPER_REC_LEN;
 	dmi_memdev_name(mem->mem_dev_handle, &bank, &device);
 	if (bank && device)
 		n = snprintf(msg, len, "DIMM location: %s %s ", bank, device);
@@ -267,7 +266,6 @@ static int cper_dimm_err_location(struct cper_mem_err_compact *mem, char *msg)
 			     "DIMM location: not present. DMI handle: 0x%.4x ",
 			     mem->mem_dev_handle);
 
-	msg[n] = '\0';
 	return n;
 }
 
-- 
2.30.2



