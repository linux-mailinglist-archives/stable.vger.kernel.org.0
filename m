Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C344C551E75
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241574AbiFTOCC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351873AbiFTNzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:55:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BD5344F2;
        Mon, 20 Jun 2022 06:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE01A60FF3;
        Mon, 20 Jun 2022 13:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1747C341C5;
        Mon, 20 Jun 2022 13:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731299;
        bh=ytZ1+hFyV2RqybENQgs4g/BucLFJXxFLio4+veEmxzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOHp0NJYFhbjaHZAEJyIGQDQ1c13v0+AUXGErPd8Ajo6lFUol4rBIQu2pt+Ey0F1l
         wjovJDgCzsMat7lK43cxcKOwrIPbate8hhk8IGPu/IH5YDpc812xjUKY9Mehs1zRtq
         ULsJryZ2L0ngtMOLm2kLE5wvXgURGFNqNZ8cf9Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 216/240] faddr2line: Fix overlapping text section failures, the sequel
Date:   Mon, 20 Jun 2022 14:51:57 +0200
Message-Id: <20220620124745.230302229@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit dcea997beed694cbd8705100ca1a6eb0d886de69 ]

If a function lives in a section other than .text, but .text also exists
in the object, faddr2line may wrongly assume .text.  This can result in
comically wrong output.  For example:

  $ scripts/faddr2line vmlinux.o enter_from_user_mode+0x1c
  enter_from_user_mode+0x1c/0x30:
  find_next_bit at /home/jpoimboe/git/linux/./include/linux/find.h:40
  (inlined by) perf_clear_dirty_counters at /home/jpoimboe/git/linux/arch/x86/events/core.c:2504

Fix it by passing the section name to addr2line, unless the object file
is vmlinux, in which case the symbol table uses absolute addresses.

Fixes: 1d1a0e7c5100 ("scripts/faddr2line: Fix overlapping text section failures")
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lore.kernel.org/r/7d25bc1408bd3a750ac26e60d2f2815a5f4a8363.1654130536.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/faddr2line | 45 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff --git a/scripts/faddr2line b/scripts/faddr2line
index 0e6268d59883..94ed98dd899f 100755
--- a/scripts/faddr2line
+++ b/scripts/faddr2line
@@ -95,17 +95,25 @@ __faddr2line() {
 	local print_warnings=$4
 
 	local sym_name=${func_addr%+*}
-	local offset=${func_addr#*+}
-	offset=${offset%/*}
+	local func_offset=${func_addr#*+}
+	func_offset=${func_offset%/*}
 	local user_size=
+	local file_type
+	local is_vmlinux=0
 	[[ $func_addr =~ "/" ]] && user_size=${func_addr#*/}
 
-	if [[ -z $sym_name ]] || [[ -z $offset ]] || [[ $sym_name = $func_addr ]]; then
+	if [[ -z $sym_name ]] || [[ -z $func_offset ]] || [[ $sym_name = $func_addr ]]; then
 		warn "bad func+offset $func_addr"
 		DONE=1
 		return
 	fi
 
+	# vmlinux uses absolute addresses in the section table rather than
+	# section offsets.
+	local file_type=$(${READELF} --file-header $objfile |
+		${AWK} '$1 == "Type:" { print $2; exit }')
+	[[ $file_type = "EXEC" ]] && is_vmlinux=1
+
 	# Go through each of the object's symbols which match the func name.
 	# In rare cases there might be duplicates, in which case we print all
 	# matches.
@@ -114,9 +122,11 @@ __faddr2line() {
 		local sym_addr=0x${fields[1]}
 		local sym_elf_size=${fields[2]}
 		local sym_sec=${fields[6]}
+		local sec_size
+		local sec_name
 
 		# Get the section size:
-		local sec_size=$(${READELF} --section-headers --wide $objfile |
+		sec_size=$(${READELF} --section-headers --wide $objfile |
 			sed 's/\[ /\[/' |
 			${AWK} -v sec=$sym_sec '$1 == "[" sec "]" { print "0x" $6; exit }')
 
@@ -126,6 +136,17 @@ __faddr2line() {
 			return
 		fi
 
+		# Get the section name:
+		sec_name=$(${READELF} --section-headers --wide $objfile |
+			sed 's/\[ /\[/' |
+			${AWK} -v sec=$sym_sec '$1 == "[" sec "]" { print $2; exit }')
+
+		if [[ -z $sec_name ]]; then
+			warn "bad section name: section: $sym_sec"
+			DONE=1
+			return
+		fi
+
 		# Calculate the symbol size.
 		#
 		# Unfortunately we can't use the ELF size, because kallsyms
@@ -174,10 +195,10 @@ __faddr2line() {
 
 		sym_size=0x$(printf %x $sym_size)
 
-		# Calculate the section address from user-supplied offset:
-		local addr=$(($sym_addr + $offset))
+		# Calculate the address from user-supplied offset:
+		local addr=$(($sym_addr + $func_offset))
 		if [[ -z $addr ]] || [[ $addr = 0 ]]; then
-			warn "bad address: $sym_addr + $offset"
+			warn "bad address: $sym_addr + $func_offset"
 			DONE=1
 			return
 		fi
@@ -191,9 +212,9 @@ __faddr2line() {
 		fi
 
 		# Make sure the provided offset is within the symbol's range:
-		if [[ $offset -gt $sym_size ]]; then
+		if [[ $func_offset -gt $sym_size ]]; then
 			[[ $print_warnings = 1 ]] &&
-				echo "skipping $sym_name address at $addr due to size mismatch ($offset > $sym_size)"
+				echo "skipping $sym_name address at $addr due to size mismatch ($func_offset > $sym_size)"
 			continue
 		fi
 
@@ -202,11 +223,13 @@ __faddr2line() {
 		[[ $FIRST = 0 ]] && echo
 		FIRST=0
 
-		echo "$sym_name+$offset/$sym_size:"
+		echo "$sym_name+$func_offset/$sym_size:"
 
 		# Pass section address to addr2line and strip absolute paths
 		# from the output:
-		local output=$(${ADDR2LINE} -fpie $objfile $addr | sed "s; $dir_prefix\(\./\)*; ;")
+		local args="--functions --pretty-print --inlines --exe=$objfile"
+		[[ $is_vmlinux = 0 ]] && args="$args --section=$sec_name"
+		local output=$(${ADDR2LINE} $args $addr | sed "s; $dir_prefix\(\./\)*; ;")
 		[[ -z $output ]] && continue
 
 		# Default output (non --list):
-- 
2.35.1



