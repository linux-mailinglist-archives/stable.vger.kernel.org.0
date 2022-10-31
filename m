Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78526130B6
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJaGtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJaGtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:49:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981649FF0
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:49:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A3AAB8114A
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0EFC433D6;
        Mon, 31 Oct 2022 06:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667198960;
        bh=zncp7mPjd8uW8Ham84pRwyB4Oih9LzkmaUWH5VP+pmg=;
        h=Subject:To:Cc:From:Date:From;
        b=XtzG25zodIU1TUdrCwifVDhxJf7sN7NPUwVMM8FKzsyc2dmc1AjVYnDXqHPHePA0O
         0io+EvXR/68T6lGlZxnz+h5llu9AobZl9yYefiWPqYUDNKXsrvldS/gXH3n4VwSJ5K
         NgeiHdQQ4kmOB7L6z+Hmd/6kOmvn93FZlpFsN7VQ=
Subject: FAILED: patch "[PATCH] s390/boot: add secure boot trailer" failed to apply to 5.10-stable tree
To:     oberpar@linux.ibm.com, gor@linux.ibm.com, stable@vger.kernel.org,
        svens@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:50:00 +0100
Message-ID: <166719900010331@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

aa127a069ef3 ("s390/boot: add secure boot trailer")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aa127a069ef312aca02b730d5137e1778d0c3ba7 Mon Sep 17 00:00:00 2001
From: Peter Oberparleiter <oberpar@linux.ibm.com>
Date: Fri, 16 Sep 2022 15:01:36 +0200
Subject: [PATCH] s390/boot: add secure boot trailer

This patch enhances the kernel image adding a trailer as required for
secure boot by future firmware versions.

Cc: <stable@vger.kernel.org> # 5.2+
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/boot/vmlinux.lds.S b/arch/s390/boot/vmlinux.lds.S
index af5c6860e0a1..fa9d33b01b85 100644
--- a/arch/s390/boot/vmlinux.lds.S
+++ b/arch/s390/boot/vmlinux.lds.S
@@ -102,8 +102,17 @@ SECTIONS
 		_compressed_start = .;
 		*(.vmlinux.bin.compressed)
 		_compressed_end = .;
-		FILL(0xff);
-		. = ALIGN(4096);
+	}
+
+#define SB_TRAILER_SIZE 32
+	/* Trailer needed for Secure Boot */
+	. += SB_TRAILER_SIZE; /* make sure .sb.trailer does not overwrite the previous section */
+	. = ALIGN(4096) - SB_TRAILER_SIZE;
+	.sb.trailer : {
+		QUAD(0)
+		QUAD(0)
+		QUAD(0)
+		QUAD(0x000000207a49504c)
 	}
 	_end = .;
 

