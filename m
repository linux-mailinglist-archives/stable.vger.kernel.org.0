Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D37469D0D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356666AbhLFP2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41336 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357730AbhLFPW5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:22:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 813C861331;
        Mon,  6 Dec 2021 15:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C15C341C1;
        Mon,  6 Dec 2021 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803967;
        bh=JY+Wv0SOirE7UpuK3AObj9lwLRWcwiAQicAXkAAJmrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eM8WycTkSPZDdBSDWzHWV7UYg6JAOJDb3sJU1xDMOkczHtLA+J9VYVjI0/mdebNSR
         nCUq9cWR7I92Te7ieRaJd0mVp1Vm3ENdBeAppU4kw/XAucjPerSLTgXByjPEExL3pl
         kx/5EvEirWsbjTJv7Lvq5N8crOl9gZdILLfYkxS0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 111/130] parisc: Fix KBUILD_IMAGE for self-extracting kernel
Date:   Mon,  6 Dec 2021 15:57:08 +0100
Message-Id: <20211206145603.476618109@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 1d7c29b77725d05faff6754d2f5e7c147aedcf93 upstream.

Default KBUILD_IMAGE to $(boot)/bzImage if a self-extracting
(CONFIG_PARISC_SELF_EXTRACT=y) kernel is to be built.
This fixes the bindeb-pkg make target.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/Makefile |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/parisc/Makefile
+++ b/arch/parisc/Makefile
@@ -17,7 +17,12 @@
 # Mike Shaver, Helge Deller and Martin K. Petersen
 #
 
+ifdef CONFIG_PARISC_SELF_EXTRACT
+boot := arch/parisc/boot
+KBUILD_IMAGE := $(boot)/bzImage
+else
 KBUILD_IMAGE := vmlinuz
+endif
 
 NM		= sh $(srctree)/arch/parisc/nm
 CHECKFLAGS	+= -D__hppa__=1


