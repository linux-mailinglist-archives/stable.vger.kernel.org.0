Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B6F643464
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234671AbiLETqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:46:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbiLETqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:46:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A27F306
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:42:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C28B1B8120F
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F88C433D7;
        Mon,  5 Dec 2022 19:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269343;
        bh=+WFqcAr1g/NY+Mqs7VndDxG92ngCZI81Fyv1D9QeYoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nlsMiRY9c5Wn5Ngth8n9qsD85FKeZThRfgNQ8lOsv8MmRXGU2CwOT9JSF5AOcKwCl
         4IWtgFGTbOpVsc2Agzq7JiJ/phMA5i6LK2UqSpqTvOvwq6yJtEhruCdz+NU0H9twRf
         AiKtXZ9GE/IoXiiIbZSjJ+rDAZy7mBw3IRzfIkL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/153] scripts/faddr2line: Fix regression in name resolution on ppc64le
Date:   Mon,  5 Dec 2022 20:10:17 +0100
Message-Id: <20221205190811.404573748@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

[ Upstream commit 2d77de1581bb5b470486edaf17a7d70151131afd ]

Commit 1d1a0e7c5100 ("scripts/faddr2line: Fix overlapping text section
failures") can cause faddr2line to fail on ppc64le on some
distributions, while it works fine on other distributions. The failure
can be attributed to differences in the readelf output.

  $ ./scripts/faddr2line vmlinux find_busiest_group+0x00
  no match for find_busiest_group+0x00

On ppc64le, readelf adds the localentry tag before the symbol name on
some distributions, and adds the localentry tag after the symbol name on
other distributions. This problem has been discussed previously:

  https://lore.kernel.org/bpf/20191211160133.GB4580@calabresa/

This problem can be overcome by filtering out the localentry tags in the
readelf output. Similar fixes are already present in the kernel by way
of the following commits:

  1fd6cee127e2 ("libbpf: Fix VERSIONED_SYM_COUNT number parsing")
  aa915931ac3e ("libbpf: Fix readelf output parsing for Fedora")

[jpoimboe: rework commit log]

Fixes: 1d1a0e7c5100 ("scripts/faddr2line: Fix overlapping text section failures")
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Link: https://lore.kernel.org/r/20220927075211.897152-1-srikar@linux.vnet.ibm.com
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/faddr2line | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/scripts/faddr2line b/scripts/faddr2line
index 57099687e5e1..9e730b805e87 100755
--- a/scripts/faddr2line
+++ b/scripts/faddr2line
@@ -73,7 +73,8 @@ command -v ${ADDR2LINE} >/dev/null 2>&1 || die "${ADDR2LINE} isn't installed"
 find_dir_prefix() {
 	local objfile=$1
 
-	local start_kernel_addr=$(${READELF} --symbols --wide $objfile | ${AWK} '$8 == "start_kernel" {printf "0x%s", $2}')
+	local start_kernel_addr=$(${READELF} --symbols --wide $objfile | sed 's/\[.*\]//' |
+		${AWK} '$8 == "start_kernel" {printf "0x%s", $2}')
 	[[ -z $start_kernel_addr ]] && return
 
 	local file_line=$(${ADDR2LINE} -e $objfile $start_kernel_addr)
@@ -177,7 +178,7 @@ __faddr2line() {
 				found=2
 				break
 			fi
-		done < <(${READELF} --symbols --wide $objfile | ${AWK} -v sec=$sym_sec '$7 == sec' | sort --key=2)
+		done < <(${READELF} --symbols --wide $objfile | sed 's/\[.*\]//' | ${AWK} -v sec=$sym_sec '$7 == sec' | sort --key=2)
 
 		if [[ $found = 0 ]]; then
 			warn "can't find symbol: sym_name: $sym_name sym_sec: $sym_sec sym_addr: $sym_addr sym_elf_size: $sym_elf_size"
@@ -258,7 +259,7 @@ __faddr2line() {
 
 		DONE=1
 
-	done < <(${READELF} --symbols --wide $objfile | ${AWK} -v fn=$sym_name '$4 == "FUNC" && $8 == fn')
+	done < <(${READELF} --symbols --wide $objfile | sed 's/\[.*\]//' | ${AWK} -v fn=$sym_name '$4 == "FUNC" && $8 == fn')
 }
 
 [[ $# -lt 2 ]] && usage
-- 
2.35.1



