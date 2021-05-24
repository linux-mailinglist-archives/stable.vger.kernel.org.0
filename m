Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B50A38EF2A
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbhEXP4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233634AbhEXPz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 634706143D;
        Mon, 24 May 2021 15:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870909;
        bh=2eixtHJtGhNm7iHprTMw6XRac/mdtTXk6JyXaKcgtyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nBKerwg30cn84AIFdnZINKdxEzX1w2CLZYckiDJfhMoBgWBJ/+bDgznl20CBtHGD
         5bVBr5pBdbVel7qI98KOs4bfi29l280TKBAJwpDN9CmIm3ooTaZJ5jBORTQKxHl5vM
         /w0zIC+dtht5SQS1GvPxgcnQQowEMBqMeN4Ft1WY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 056/104] x86/sev-es: Invalidate the GHCB after completing VMGEXIT
Date:   Mon, 24 May 2021 17:25:51 +0200
Message-Id: <20210524152334.720956848@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit a50c5bebc99c525e7fbc059988c6a5ab8680cb76 upstream.

Since the VMGEXIT instruction can be issued from userspace, invalidate
the GHCB after performing VMGEXIT processing in the kernel.

Invalidation is only required after userspace is available, so call
vc_ghcb_invalidate() from sev_es_put_ghcb(). Update vc_ghcb_invalidate()
to additionally clear the GHCB exit code so that it is always presented
as 0 when VMGEXIT has been issued by anything else besides the kernel.

Fixes: 0786138c78e79 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/5a8130462e4f0057ee1184509cd056eedd78742b.1621273353.git.thomas.lendacky@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev-es-shared.c |    1 +
 arch/x86/kernel/sev-es.c        |    5 +++++
 2 files changed, 6 insertions(+)

--- a/arch/x86/kernel/sev-es-shared.c
+++ b/arch/x86/kernel/sev-es-shared.c
@@ -63,6 +63,7 @@ static bool sev_es_negotiate_protocol(vo
 
 static __always_inline void vc_ghcb_invalidate(struct ghcb *ghcb)
 {
+	ghcb->save.sw_exit_code = 0;
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -430,6 +430,11 @@ static __always_inline void sev_es_put_g
 		data->backup_ghcb_active = false;
 		state->ghcb = NULL;
 	} else {
+		/*
+		 * Invalidate the GHCB so a VMGEXIT instruction issued
+		 * from userspace won't appear to be valid.
+		 */
+		vc_ghcb_invalidate(ghcb);
 		data->ghcb_active = false;
 	}
 }


