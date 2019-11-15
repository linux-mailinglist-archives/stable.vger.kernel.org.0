Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0F65FD653
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfKOGVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:21:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbfKOGVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:21:42 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F93E20637;
        Fri, 15 Nov 2019 06:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798901;
        bh=yVJGv9t7sCYlVFIiE0CQuIFyDDiIizjCpMePLyQhcJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYSK5CguyM4/2s5Dr2mUIcKNiutOvfo2WZNMrGJOqlxxFl3bUcpThnI5Vr9+wdz0s
         2P0givgK8V1nWyZlOeLXc+dW/gnU8QqALDFcPoU8aDRP9INOR0CHBUFGgh+YO6GR6s
         so8QUa27evxOl7BG2gba2xSaeaagXV8c4qAAmlHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Donnellan <ajd@linux.ibm.com>
Subject: [PATCH 4.4 05/20] powerpc/boot: Request no dynamic linker for boot wrapper
Date:   Fri, 15 Nov 2019 14:20:34 +0800
Message-Id: <20191115062009.709977680@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
References: <20191115062006.854443935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit ff45000fcb56b5b0f1a14a865d3541746d838a0a upstream.

The boot wrapper performs its own relocations and does not require
PT_INTERP segment. However currently we don't tell the linker that.

Prior to binutils 2.28 that works OK. But since binutils commit
1a9ccd70f9a7 ("Fix the linker so that it will not silently generate ELF
binaries with invalid program headers. Fix readelf to report such
invalid binaries.") binutils tries to create a program header segment
due to PT_INTERP, and the link fails because there is no space for it:

  ld: arch/powerpc/boot/zImage.pseries: Not enough room for program headers, try linking with -N
  ld: final link failed: Bad value

So tell the linker not to do that, by passing --no-dynamic-linker.

Cc: stable@vger.kernel.org
Reported-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
[mpe: Drop dependency on ld-version.sh and massage change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[ajd: backport to v4.4 (resolve conflict with a comment line)]
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/boot/wrapper |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -161,6 +161,28 @@ case "$elfformat" in
     elf32-powerpc)	format=elf32ppc	;;
 esac
 
+ld_version()
+{
+    # Poached from scripts/ld-version.sh, but we don't want to call that because
+    # this script (wrapper) is distributed separately from the kernel source.
+    # Extract linker version number from stdin and turn into single number.
+    awk '{
+	gsub(".*\\)", "");
+	gsub(".*version ", "");
+	gsub("-.*", "");
+	split($1,a, ".");
+	print a[1]*100000000 + a[2]*1000000 + a[3]*10000;
+	exit
+    }'
+}
+
+# Do not include PT_INTERP segment when linking pie. Non-pie linking
+# just ignores this option.
+LD_VERSION=$(${CROSS}ld --version | ld_version)
+LD_NO_DL_MIN_VERSION=$(echo 2.26 | ld_version)
+if [ "$LD_VERSION" -ge "$LD_NO_DL_MIN_VERSION" ] ; then
+	nodl="--no-dynamic-linker"
+fi
 
 platformo=$object/"$platform".o
 lds=$object/zImage.lds
@@ -412,7 +434,7 @@ if [ "$platform" != "miboot" ]; then
     if [ -n "$link_address" ] ; then
         text_start="-Ttext $link_address"
     fi
-    ${CROSS}ld -m $format -T $lds $text_start $pie -o "$ofile" \
+    ${CROSS}ld -m $format -T $lds $text_start $pie $nodl -o "$ofile" \
 	$platformo $tmp $object/wrapper.a
     rm $tmp
 fi


