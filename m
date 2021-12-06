Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF1E469BF9
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357743AbhLFPTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359382AbhLFPRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:17:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9B3C061D7E;
        Mon,  6 Dec 2021 07:10:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE4C6B8111D;
        Mon,  6 Dec 2021 15:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352DFC341C2;
        Mon,  6 Dec 2021 15:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803423;
        bh=4GGXR8wK70ZravjoS71SnY+VtXZZ4oVVlOBySCYEqao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vjnS7U88TyuE9A/v3ve4UNGdP879T4XR1qL4kMB/n2azF3uXzW/DC1PrypnszsQuU
         Tsi4VP2u0O4ZfmcV2jevQp6ecTWYSnv8vFK98tzFj/2jELAsne1C5WORkwJ+/A224L
         lggpiyeth7PY4HCM/SeP5wsDH5z6/28uA3nmCiRc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 37/48] parisc: Fix KBUILD_IMAGE for self-extracting kernel
Date:   Mon,  6 Dec 2021 15:56:54 +0100
Message-Id: <20211206145550.105515547@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
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
 
 KBUILD_DEFCONFIG := default_defconfig
 


