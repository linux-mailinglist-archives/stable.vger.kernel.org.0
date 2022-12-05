Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D16264316C
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbiLETOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiLETOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:14:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3218024969
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:14:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1F0A6130C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09D7C433D7;
        Mon,  5 Dec 2022 19:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267655;
        bh=PXwvJPOltNXmGwLknp+v8l9ID/o+1i+NqmxBiiANKv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dR7A7RaCrS4OVeCsPRCCONbKxPFzDNn5Ac2T34TV1KA2BBfc17PwgdczqG2/gzsNI
         lAgC7OOsgN/+yhnNXvRJ2YGoKaMwke/D36eci9AZLxXmI/vpprCWvBrE25ZV9zcVPV
         ZxzDPbzqLBoWpTMv9alV6oaGrXHynaW79zBD7spw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.9 48/62] tools/vm/slabinfo-gnuplot: use "grep -E" instead of "egrep"
Date:   Mon,  5 Dec 2022 20:09:45 +0100
Message-Id: <20221205190759.915942264@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190758.073114639@linuxfoundation.org>
References: <20221205190758.073114639@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit a435874bf626f55d7147026b059008c8de89fbb8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/vm/slabinfo-gnuplot.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/vm/slabinfo-gnuplot.sh
+++ b/tools/vm/slabinfo-gnuplot.sh
@@ -157,7 +157,7 @@ do_preprocess()
 	let lines=3
 	out=`basename "$in"`"-slabs-by-loss"
 	`cat "$in" | grep -A "$lines" 'Slabs sorted by loss' |\
-		egrep -iv '\-\-|Name|Slabs'\
+		grep -E -iv '\-\-|Name|Slabs'\
 		| awk '{print $1" "$4+$2*$3" "$4}' > "$out"`
 	if [ $? -eq 0 ]; then
 		do_slabs_plotting "$out"
@@ -166,7 +166,7 @@ do_preprocess()
 	let lines=3
 	out=`basename "$in"`"-slabs-by-size"
 	`cat "$in" | grep -A "$lines" 'Slabs sorted by size' |\
-		egrep -iv '\-\-|Name|Slabs'\
+		grep -E -iv '\-\-|Name|Slabs'\
 		| awk '{print $1" "$4" "$4-$2*$3}' > "$out"`
 	if [ $? -eq 0 ]; then
 		do_slabs_plotting "$out"


