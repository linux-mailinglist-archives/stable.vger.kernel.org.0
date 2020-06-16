Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA591FB7E7
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732631AbgFPPu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:47260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732629AbgFPPu7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:50:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37EC521508;
        Tue, 16 Jun 2020 15:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322658;
        bh=NfyeYBv3Ytqvwx2GLkdolh2/BfKmm02Zfnl6JpkxPis=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdAKucZCj33lAc0HlDjczRDVopbtP/HX9JdKLmpVYzua8F1iZkuBoRtkTQe9Xw2Ep
         esrciZ6z91ynXxeQZ0KCjx7mRS2xGAprhahqbz1bW7OIxWTjpcsQspIkOm8zP6HeLN
         +ZiqM0IhPJcTPD4ks3Yj971Os1kr6+uMsAleKe4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anthony Steinhauser <asteinhauser@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.6 053/161] x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for indirect branches.
Date:   Tue, 16 Jun 2020 17:34:03 +0200
Message-Id: <20200616153108.905780865@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.402291280@linuxfoundation.org>
References: <20200616153106.402291280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Steinhauser <asteinhauser@google.com>

commit 4d8df8cbb9156b0a0ab3f802b80cb5db57acc0bf upstream.

Currently, it is possible to enable indirect branch speculation even after
it was force-disabled using the PR_SPEC_FORCE_DISABLE option. Moreover, the
PR_GET_SPECULATION_CTRL command gives afterwards an incorrect result
(force-disabled when it is in fact enabled). This also is inconsistent
vs. STIBP and the documention which cleary states that
PR_SPEC_FORCE_DISABLE cannot be undone.

Fix this by actually enforcing force-disabled indirect branch
speculation. PR_SPEC_ENABLE called after PR_SPEC_FORCE_DISABLE now fails
with -EPERM as described in the documentation.

Fixes: 9137bb27e60e ("x86/speculation: Add prctl() control for indirect branch speculation")
Signed-off-by: Anthony Steinhauser <asteinhauser@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/bugs.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1268,11 +1268,14 @@ static int ib_prctl_set(struct task_stru
 			return 0;
 		/*
 		 * Indirect branch speculation is always disabled in strict
-		 * mode.
+		 * mode. It can neither be enabled if it was force-disabled
+		 * by a  previous prctl call.
+
 		 */
 		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
 		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED ||
+		    task_spec_ib_force_disable(task))
 			return -EPERM;
 		task_clear_spec_ib_disable(task);
 		task_update_spec_tif(task);


