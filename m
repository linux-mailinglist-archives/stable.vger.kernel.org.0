Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 985612348F
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389019AbfETM2K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389265AbfETM2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:28:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE73020815;
        Mon, 20 May 2019 12:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355287;
        bh=CsZ3fU+KNH8Lb2E/bENn7G/dAUdvCuX7xDC+u13lcI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FaERPTXFrOhN7Aq5eAjyYHb5o+5xAkePo8PlBWesWhLoOe1tGu8msYIu25zp95vyj
         LNuoxjJOGEZMAlA5aDQqoxXI65njW8G0FDlbq+leoosV33WPAiAJIazxx3/uq/s3nx
         8fOyWaj6emcsK3TGbjARBk6U1BR1EIsbgEggCbY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirish S <shirish.s@amd.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        x86-ml <x86@kernel.org>
Subject: [PATCH 5.0 021/123] x86/MCE/AMD: Turn off MC4_MISC thresholding on all family 0x15 models
Date:   Mon, 20 May 2019 14:13:21 +0200
Message-Id: <20190520115246.275461772@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shirish S <Shirish.S@amd.com>

commit c95b323dcd3598dd7ef5005d6723c1ba3b801093 upstream.

MC4_MISC thresholding is not supported on all family 0x15 processors,
hence skip the x86_model check when applying the quirk.

 [ bp: massage commit message. ]

Signed-off-by: Shirish S <shirish.s@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/1547106849-3476-2-git-send-email-shirish.s@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mce/core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1613,11 +1613,10 @@ static int __mcheck_cpu_apply_quirks(str
 			mce_flags.overflow_recov = 1;
 
 		/*
-		 * Turn off MC4_MISC thresholding banks on those models since
+		 * Turn off MC4_MISC thresholding banks on all models since
 		 * they're not supported there.
 		 */
-		if (c->x86 == 0x15 &&
-		    (c->x86_model >= 0x10 && c->x86_model <= 0x1f)) {
+		if (c->x86 == 0x15) {
 			int i;
 			u64 hwcr;
 			bool need_toggle;


