Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75B8438EF29
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234927AbhEXP4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234318AbhEXPz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A8DE613FC;
        Mon, 24 May 2021 15:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870907;
        bh=i4wAM3elN/z5Vsa8a3mnqbLfx3fRITuI3zFmbTOua8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DwyZvqo0Bq7Smx1Aza6kzsYWa+xR1ReWFlUKzuVQYdGfb3K0sME5mcIEBiMh3oMNL
         kQQxnpUs/ajYjJdmBlfhlunRjMylgEhEcirFlgWsGuSKeKsys/2+jd7835oOCyCWg8
         B8ZxqQtWZE+R8ZOfigpbMoAnK/loWxxCIr5XX9rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 055/104] x86/sev-es: Move sev_es_put_ghcb() in prep for follow on patch
Date:   Mon, 24 May 2021 17:25:50 +0200
Message-Id: <20210524152334.676899619@linuxfoundation.org>
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

commit fea63d54f7a3e74f8ab489a8b82413a29849a594 upstream.

Move the location of sev_es_put_ghcb() in preparation for an update to it
in a follow-on patch. This will better highlight the changes being made
to the function.

No functional change.

Fixes: 0786138c78e79 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/8c07662ec17d3d82e5c53841a1d9e766d3bdbab6.1621273353.git.thomas.lendacky@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev-es.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -209,24 +209,6 @@ static __always_inline struct ghcb *sev_
 	return ghcb;
 }
 
-static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
-{
-	struct sev_es_runtime_data *data;
-	struct ghcb *ghcb;
-
-	data = this_cpu_read(runtime_data);
-	ghcb = &data->ghcb_page;
-
-	if (state->ghcb) {
-		/* Restore GHCB from Backup */
-		*ghcb = *state->ghcb;
-		data->backup_ghcb_active = false;
-		state->ghcb = NULL;
-	} else {
-		data->ghcb_active = false;
-	}
-}
-
 /* Needed in vc_early_forward_exception */
 void do_early_exception(struct pt_regs *regs, int trapnr);
 
@@ -434,6 +416,24 @@ static enum es_result vc_slow_virt_to_ph
 /* Include code shared with pre-decompression boot stage */
 #include "sev-es-shared.c"
 
+static __always_inline void sev_es_put_ghcb(struct ghcb_state *state)
+{
+	struct sev_es_runtime_data *data;
+	struct ghcb *ghcb;
+
+	data = this_cpu_read(runtime_data);
+	ghcb = &data->ghcb_page;
+
+	if (state->ghcb) {
+		/* Restore GHCB from Backup */
+		*ghcb = *state->ghcb;
+		data->backup_ghcb_active = false;
+		state->ghcb = NULL;
+	} else {
+		data->ghcb_active = false;
+	}
+}
+
 void noinstr __sev_es_nmi_complete(void)
 {
 	struct ghcb_state state;


