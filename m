Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE1AB61E9F
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 14:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbfGHMmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 08:42:03 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42675 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727065AbfGHMmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 08:42:03 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 77B0B2102F;
        Mon,  8 Jul 2019 08:42:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 08 Jul 2019 08:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=+y+8X0
        j2qTXl3dL1dOGIpoFL4OxaPw2yUf9OziPzACs=; b=YX7O4mk5AP2d2UWwrCHuwd
        dIEqw9U4ER2C1AO9C+oCjQLT6bui8qGRCJfL36fB8i9elmgA4/syAB33IvtAmneu
        paWnHkm1DcE/SjWMpxg/3impRvaIA985xOqf56CaSRzhKgutmz3SZCeOiiSr8XcR
        9PXxPidmiEHn7FaEeIm3MbZkcPk5/IQdrwtQt8XF0Kxc2XHBbvBwJWabGPiJR4Ty
        Z5Wu9hfNcYlev+L4hRud+066RWCueGyJKuYLXlq0kRBn0LK2Y6BgAxQyHzXJEG35
        FtZPvoFe3YVlpCh3piza5GxKGrjKtvAzKG8jCSANcK/YR9KH9C/NE0k18ydU6C1A
        ==
X-ME-Sender: <xms:GjojXYI5_3aB4INcKlt1dD_G07TKa6NmQC7tI2zYLUrtzjBZ8fTvLw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgedtgdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:GjojXdDXoGs94YKElb7bHY_1lWC9VSYOJ5pXp6yDBAALiWsLVH6UXw>
    <xmx:GjojXelZyigL3ZPLrG6MjYBRMf6eHTyCB0o7Akl7b6BXLnx-Yu-D0g>
    <xmx:GjojXX1kWN_URwZJZGzqdWkZfvD5Gl4lvrkaueVlOuGFDxEJQ09nrQ>
    <xmx:GjojXRN9TyaKtyPWj4mglt1XM3u19is79MYFqZm3j6Ti7a4sQS2jMA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C3795380076;
        Mon,  8 Jul 2019 08:42:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] MIPS: have "plain" make calls build dtbs for selected" failed to apply to 4.14-stable tree
To:     Cedric_Hombourger@mentor.com, paul.burton@mips.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Jul 2019 14:42:00 +0200
Message-ID: <15625897204101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 637dfa0fad6d91a9a709dc70549a6d20fa77f615 Mon Sep 17 00:00:00 2001
From: Cedric Hombourger <Cedric_Hombourger@mentor.com>
Date: Thu, 13 Jun 2019 10:52:50 +0200
Subject: [PATCH] MIPS: have "plain" make calls build dtbs for selected
 platforms

scripts/package/builddeb calls "make dtbs_install" after executing
a plain make (i.e. no build targets specified). It will fail if dtbs
were not built beforehand. Match the arm64 architecture where DTBs get
built by the "all" target.

Signed-off-by: Cedric Hombourger <Cedric_Hombourger@mentor.com>
[paul.burton@mips.com: s/builddep/builddeb]
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: stable@vger.kernel.org # v4.1+

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index 8f4486c4415b..eceff9b75b22 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -17,6 +17,7 @@ archscripts: scripts_basic
 	$(Q)$(MAKE) $(build)=arch/mips/boot/tools relocs
 
 KBUILD_DEFCONFIG := 32r2el_defconfig
+KBUILD_DTBS      := dtbs
 
 #
 # Select the object file format to substitute into the linker script.
@@ -384,7 +385,7 @@ quiet_cmd_64 = OBJCOPY $@
 vmlinux.64: vmlinux
 	$(call cmd,64)
 
-all:	$(all-y)
+all:	$(all-y) $(KBUILD_DTBS)
 
 # boot
 $(boot-y): $(vmlinux-32) FORCE

