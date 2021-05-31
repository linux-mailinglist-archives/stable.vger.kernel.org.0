Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED268395DF8
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhEaNwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233256AbhEaNu2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:50:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AD3361431;
        Mon, 31 May 2021 13:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467919;
        bh=wfHtREpFmlGBcwyHVdlPE0JPPJA1LE83SdAOS4fMfQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsP8Qn4azXNpg1LzGOWl1RKzQ7B18zOLUlgxX5S0f+5E96i+UqjJ6vcmftrf6I/YZ
         h8KO++96HhUy7NeufVaf3S4So60Xuu3NdeCAuDhXTrSlYE2mGpKFy5gof/VNb7xAzl
         mO2hQevy4TMHA2EiJRf9H5/Dlx7ovdYV1O8yIW4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 5.10 050/252] kgdb: fix gcc-11 warnings harder
Date:   Mon, 31 May 2021 15:11:55 +0200
Message-Id: <20210531130659.678217373@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit bda7d3ab06f19c02dcef61fefcb9dd954dfd5e4f upstream.

40cc3a80bb42 ("kgdb: fix gcc-11 warning on indentation") tried to fix up
the gcc-11 complaints in this file by just reformatting the #defines.
That worked for gcc 11.1.0, but in gcc 11.1.1 as shipped by Fedora 34,
the warning came back for one of the #defines.

Fix this up again by putting { } around the if statement, now it is
quiet again.

Fixes: 40cc3a80bb42 ("kgdb: fix gcc-11 warning on indentation")
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
Link: https://lore.kernel.org/r/20210520130839.51987-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/kgdbts.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -100,8 +100,9 @@
 		printk(KERN_INFO a);	\
 } while (0)
 #define v2printk(a...) do {		\
-	if (verbose > 1)		\
+	if (verbose > 1) {		\
 		printk(KERN_INFO a);	\
+	}				\
 	touch_nmi_watchdog();		\
 } while (0)
 #define eprintk(a...) do {		\


