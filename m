Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC80738F01B
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235654AbhEXQBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234649AbhEXQAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEF2B6198D;
        Mon, 24 May 2021 15:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871166;
        bh=i4wAM3elN/z5Vsa8a3mnqbLfx3fRITuI3zFmbTOua8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExB38X0pB1792kKpLSm6teNWKbwekWnlJyobP1nYgkEjh1j28keGeMabYreqiuDvQ
         bycq/tN4dYLvgjnXjd4FQzlVyC1WOHzJcj+nRurs+OsfcvOZHJhMvkoKsBTmOcU4OF
         DBHtYllSmdp2CnUACHUfFvQ3I7EzDvBJ1RG9Y8+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.12 069/127] x86/sev-es: Move sev_es_put_ghcb() in prep for follow on patch
Date:   Mon, 24 May 2021 17:26:26 +0200
Message-Id: <20210524152337.182851186@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
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


