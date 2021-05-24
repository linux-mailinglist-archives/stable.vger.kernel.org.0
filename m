Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A87D38EF2D
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbhEXP4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:56:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234369AbhEXPz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:55:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C99861442;
        Mon, 24 May 2021 15:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870912;
        bh=AverE+4Aa7g78zpNJxtYS0wKkTAxqk0TcopGG5HvzAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aW/dVBQ67o2s1RC7l5jNKSgglMcMgh7j4Q7dODtGTVGgO8tselzTtFeXx0Q7Tk37s
         jNR+Ne7jzqtGtYp7MR2WMNRvSNCP8wfJ76fdq8wFlB42d8PDr13Rd0pwBqkZHkMtYW
         vZzkNPW1/s2VIUE2B4eGd0cXKPGVpB9J55TUDHgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 057/104] x86/sev-es: Dont return NULL from sev_es_get_ghcb()
Date:   Mon, 24 May 2021 17:25:52 +0200
Message-Id: <20210524152334.749954290@linuxfoundation.org>
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

From: Joerg Roedel <jroedel@suse.de>

commit b250f2f7792d15bcde98e0456781e2835556d5fa upstream.

sev_es_get_ghcb() is called from several places but only one of them
checks the return value. The reaction to returning NULL is always the
same: calling panic() and kill the machine.

Instead of adding checks to all call sites, move the panic() into the
function itself so that it will no longer return NULL.

Fixes: 0786138c78e7 ("x86/sev-es: Add a Runtime #VC Exception Handler")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # v5.10+
Link: https://lkml.kernel.org/r/20210519135251.30093-2-joro@8bytes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/sev-es.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

--- a/arch/x86/kernel/sev-es.c
+++ b/arch/x86/kernel/sev-es.c
@@ -191,8 +191,18 @@ static __always_inline struct ghcb *sev_
 	if (unlikely(data->ghcb_active)) {
 		/* GHCB is already in use - save its contents */
 
-		if (unlikely(data->backup_ghcb_active))
-			return NULL;
+		if (unlikely(data->backup_ghcb_active)) {
+			/*
+			 * Backup-GHCB is also already in use. There is no way
+			 * to continue here so just kill the machine. To make
+			 * panic() work, mark GHCBs inactive so that messages
+			 * can be printed out.
+			 */
+			data->ghcb_active        = false;
+			data->backup_ghcb_active = false;
+
+			panic("Unable to handle #VC exception! GHCB and Backup GHCB are already in use");
+		}
 
 		/* Mark backup_ghcb active before writing to it */
 		data->backup_ghcb_active = true;
@@ -1262,7 +1272,6 @@ static __always_inline bool on_vc_fallba
  */
 DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_communication)
 {
-	struct sev_es_runtime_data *data = this_cpu_read(runtime_data);
 	irqentry_state_t irq_state;
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -1288,16 +1297,6 @@ DEFINE_IDTENTRY_VC_SAFE_STACK(exc_vmm_co
 	 */
 
 	ghcb = sev_es_get_ghcb(&state);
-	if (!ghcb) {
-		/*
-		 * Mark GHCBs inactive so that panic() is able to print the
-		 * message.
-		 */
-		data->ghcb_active        = false;
-		data->backup_ghcb_active = false;
-
-		panic("Unable to handle #VC exception! GHCB and Backup GHCB are already in use");
-	}
 
 	vc_ghcb_invalidate(ghcb);
 	result = vc_init_em_ctxt(&ctxt, regs, error_code);


