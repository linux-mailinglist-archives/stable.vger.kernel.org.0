Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6206F378388
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhEJKqd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:46:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:52756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232465AbhEJKoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AA6061955;
        Mon, 10 May 2021 10:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642787;
        bh=qX4aE552V+ZvGDRJEDKE+hMFqE8Nie1wKexkE0JbW7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tyuJJ+aCjnKJDSUfEIR3SfAA4OKm70wBSXl04iVXhouEq0+cIXugUxqdf2/NWbwGx
         y4WVkb8Pc9b3j0Iu+6xbh6K94GEFWjFnOfB7lbcwxk+xpirvFv1ZLZ7jGccQbKMuSE
         AFYBRQFgTjyJRi/wo3Qfu3xqQAV3RSP8fyTBfcuE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.10 044/299] x86/build: Disable HIGHMEM64G selection for M486SX
Date:   Mon, 10 May 2021 12:17:21 +0200
Message-Id: <20210510102006.315682255@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 0ef3439cd80ba7770723edb0470d15815914bb62 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1414,7 +1414,7 @@ config HIGHMEM4G
 
 config HIGHMEM64G
 	bool "64GB"
-	depends on !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !WINCHIP3D && !MK6
+	depends on !M486SX && !M486 && !M586 && !M586TSC && !M586MMX && !MGEODE_LX && !MGEODEGX1 && !MCYRIXIII && !MELAN && !MWINCHIPC6 && !WINCHIP3D && !MK6
 	select X86_PAE
 	help
 	  Select this if you have a 32-bit processor and more than 4


