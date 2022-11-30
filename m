Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD4E63E3B1
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 23:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiK3Wvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 17:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiK3Wvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 17:51:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3B25BD7C;
        Wed, 30 Nov 2022 14:51:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89DEC61E27;
        Wed, 30 Nov 2022 22:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5C0C43149;
        Wed, 30 Nov 2022 22:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848700;
        bh=OOIteqlvoPQw8BPcvmIlw3XJ75PpExMCG1HMTx/794M=;
        h=Date:To:From:Subject:From;
        b=OyjuQOQPSdKVPSZcHM6Ih++TPzMULeErfhzbuanGkNbbDaQxTOpyI+3yS8JZHI6P1
         CQGbbP4EMOxnaaArA2kGogo0mnmK9pBmLpEShZ9zx4j9IkY0Q2Ye0tA90zwTVmNfhT
         zskkK01Oe6nGib7MauD6At3KAsaar0RrM4bJ9mL8=
Date:   Wed, 30 Nov 2022 14:51:39 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        senozhatsky@chromium.org, yangtiezhu@loongson.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-vm-slabinfo-gnuplot-use-grep-e-instead-of-egrep.patch removed from -mm tree
Message-Id: <20221130225139.DE5C0C43149@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: tools/vm/slabinfo-gnuplot: use "grep -E" instead of "egrep"
has been removed from the -mm tree.  Its filename was
     tools-vm-slabinfo-gnuplot-use-grep-e-instead-of-egrep.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


