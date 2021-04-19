Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5679364138
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 14:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbhDSMFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 08:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238882AbhDSMFN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 08:05:13 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A752C06174A;
        Mon, 19 Apr 2021 05:04:42 -0700 (PDT)
Date:   Mon, 19 Apr 2021 12:04:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1618833881;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vAsHv+kFEP05Q70rujNWIfj6DnEc9X02Qcf8rAYrwO0=;
        b=cDSr59HazjEWaSHoo/U+mXI/VO8ErhBQrTRSyYPTYwrQOmKc2RbQGdB8wvtbUZQBFYBI7u
        e/tQhAuBeio0VmAAmbDk0zJM52yB5TvqeWZyvslhwKquZ6D3ff4/cye2tMZDVACnxa6Ama
        o13LQq3R6lP+E0R/KrDoQ83aR7tbt2LLVed96EzTr+WmP40Qo+VA1M7oPJhzKMwZ8HokDi
        pQpwzaQGBcEcCLz2KqwjMzHZDgLrTz0X5amePQ7VQIiZ2r2NlCgXUXvmRXGSZQN4KEZ5Oy
        LA8cc/hU0Pd5EHnjnbbYJnTbXRyddtq3P41SSa/odOqiaLS+tTiqwlUZPDgGrg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1618833881;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vAsHv+kFEP05Q70rujNWIfj6DnEc9X02Qcf8rAYrwO0=;
        b=x+fOTpDEowqUkEkn7XHutr7ZRIRF7gJdzSFh+HPRvK2d8hXuaLPi+Lw50Uf6Rj7PobnPC2
        NCLjciqfv0FtACBg==
From:   "tip-bot2 for Maciej W. Rozycki" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/build] x86/build: Disable HIGHMEM64G selection for M486SX
Cc:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        #@tip-bot2.tec.linutronix.de, v5.5+@tip-bot2.tec.linutronix.de,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.21.2104141221340.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141221340.44318@angie.orcam.me.uk>
MIME-Version: 1.0
Message-ID: <161883388012.29796.15651608262748993332.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/build branch of tip:

Commit-ID:     0ef3439cd80ba7770723edb0470d15815914bb62
Gitweb:        https://git.kernel.org/tip/0ef3439cd80ba7770723edb0470d15815914bb62
Author:        Maciej W. Rozycki <macro@orcam.me.uk>
AuthorDate:    Wed, 14 Apr 2021 12:38:28 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 19 Apr 2021 14:02:12 +02:00

x86/build: Disable HIGHMEM64G selection for M486SX

Fix a regression caused by making the 486SX separately selectable in
Kconfig, for which the HIGHMEM64G setting has not been updated and
therefore has become exposed as a user-selectable option for the M486SX
configuration setting unlike with original M486 and all the other
settings that choose non-PAE-enabled processors:

  High Memory Support
  > 1. off (NOHIGHMEM)
    2. 4GB (HIGHMEM4G)
    3. 64GB (HIGHMEM64G)
  choice[1-3?]:

With the fix in place the setting is now correctly removed:

  High Memory Support
  > 1. off (NOHIGHMEM)
    2. 4GB (HIGHMEM4G)
  choice[1-2?]:

 [ bp: Massage commit message. ]

Fixes: 87d6021b8143 ("x86/math-emu: Limit MATH_EMULATION to 486SX compatibles")
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org # v5.5+
Link: https://lkml.kernel.org/r/alpine.DEB.2.21.2104141221340.44318@angie.orcam.me.uk
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2792879..268b7d5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1406,7 +1406,7 @@ config HIGHMEM4G
 
 config HIGHMEM64G
 	bool "64GB"
-	depends on !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !WINCHIP3D && !MK6
+	depends on !M486SX && !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !WINCHIP3D && !MK6
 	select X86_PAE
 	help
 	  Select this if you have a 32-bit processor and more than 4
