Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E4F632F8F
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 23:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiKUWII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 17:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiKUWIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 17:08:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD22F5DBBE;
        Mon, 21 Nov 2022 14:08:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97A18CE1989;
        Mon, 21 Nov 2022 22:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA6FC433C1;
        Mon, 21 Nov 2022 22:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669068476;
        bh=84a33Ogcqv5TQEIxzQQy/3mFG/b/pjGUbruVNlB9PfE=;
        h=Date:To:From:Subject:From;
        b=guWgsHHVQpsnmNKyEStsRwmFnAUfsvW7SrlJI2JJAa5MvIndrDeA8lAOFdgi3VR6I
         nd6gNEzzD75BlxTyHevDeSmELxQhlpIcM3PHMgAiA+NGlkESrHPzVt6E1/R4JSLkLZ
         Z6JFNFytU7IBK6mZSucAVNchIIk+1DcXtkcxfylw=
Date:   Mon, 21 Nov 2022 14:07:56 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        senozhatsky@chromium.org, yangtiezhu@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-vm-slabinfo-gnuplot-use-grep-e-instead-of-egrep.patch added to mm-hotfixes-unstable branch
Message-Id: <20221121220756.CDA6FC433C1@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo-gnuplot: use "grep -E" instead of "egrep"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-vm-slabinfo-gnuplot-use-grep-e-instead-of-egrep.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-vm-slabinfo-gnuplot-use-grep-e-instead-of-egrep.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: tools/vm/slabinfo-gnuplot: use "grep -E" instead of "egrep"
Date: Sat, 19 Nov 2022 10:36:59 +0800

The latest version of grep claims the egrep is now obsolete so the build
now contains warnings that look like:

	egrep: warning: egrep is obsolescent; using grep -E

fix this up by moving the related file to use "grep -E" instead.

  sed -i "s/egrep/grep -E/g" `grep egrep -rwl tools/vm`

Here are the steps to install the latest grep:

  wget http://ftp.gnu.org/gnu/grep/grep-3.8.tar.gz
  tar xf grep-3.8.tar.gz
  cd grep-3.8 && ./configure && make
  sudo make install
  export PATH=/usr/local/bin:$PATH

Link: https://lkml.kernel.org/r/1668825419-30584-1-git-send-email-yangtiezhu@loongson.cn
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo-gnuplot.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/vm/slabinfo-gnuplot.sh~tools-vm-slabinfo-gnuplot-use-grep-e-instead-of-egrep
+++ a/tools/vm/slabinfo-gnuplot.sh
@@ -150,7 +150,7 @@ do_preprocess()
 	let lines=3
 	out=`basename "$in"`"-slabs-by-loss"
 	`cat "$in" | grep -A "$lines" 'Slabs sorted by loss' |\
-		egrep -iv '\-\-|Name|Slabs'\
+		grep -E -iv '\-\-|Name|Slabs'\
 		| awk '{print $1" "$4+$2*$3" "$4}' > "$out"`
 	if [ $? -eq 0 ]; then
 		do_slabs_plotting "$out"
@@ -159,7 +159,7 @@ do_preprocess()
 	let lines=3
 	out=`basename "$in"`"-slabs-by-size"
 	`cat "$in" | grep -A "$lines" 'Slabs sorted by size' |\
-		egrep -iv '\-\-|Name|Slabs'\
+		grep -E -iv '\-\-|Name|Slabs'\
 		| awk '{print $1" "$4" "$4-$2*$3}' > "$out"`
 	if [ $? -eq 0 ]; then
 		do_slabs_plotting "$out"
_

Patches currently in -mm which might be from yangtiezhu@loongson.cn are

tools-vm-slabinfo-gnuplot-use-grep-e-instead-of-egrep.patch

