Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDA747AC2D
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235173AbhLTOmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:42:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49514 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbhLTOkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:40:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAB6CB80EE3;
        Mon, 20 Dec 2021 14:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406AEC36AE8;
        Mon, 20 Dec 2021 14:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011248;
        bh=xevNN71LVY1590c+Mb0u1A4Tv0j38C6SG/2qB4Q5KjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D+niztgH8uN9n6bb4v8mvUx6xf7Iw543T9hCvv2JBC7JOHDgZ4IThXH05WXdawLxA
         nmrtz+K8tjKRg9rcVCU/ZJ49qLVztYjrXOCb5knAmiVqTXj+HY+mvczqntss1JrDMG
         9W1FrFLNcX3ghZVdbACyLRHFm7AQiM3XYJrFT41E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Marchand <jmarchan@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 4.19 11/56] recordmcount.pl: look for jgnop instruction as well as bcrl on s390
Date:   Mon, 20 Dec 2021 15:34:04 +0100
Message-Id: <20211220143023.827232404@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Marchand <jmarchan@redhat.com>

commit 85bf17b28f97ca2749968d8786dc423db320d9c2 upstream.

On s390, recordmcount.pl is looking for "bcrl 0,<xxx>" instructions in
the objdump -d outpout. However since binutils 2.37, objdump -d
display "jgnop <xxx>" for the same instruction. Update the
mcount_regex so that it accepts both.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211210093827.1623286-1-jmarchan@redhat.com
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/recordmcount.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -252,7 +252,7 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "s390" && $bits == 64) {
     if ($cc =~ /-DCC_USING_HOTPATCH/) {
-	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*c0 04 00 00 00 00\\s*brcl\\s*0,[0-9a-f]+ <([^\+]*)>\$";
+	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*c0 04 00 00 00 00\\s*(bcrl\\s*0,|jgnop\\s*)[0-9a-f]+ <([^\+]*)>\$";
 	$mcount_adjust = 0;
     } else {
 	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_(PC|PLT)32DBL\\s+_mcount\\+0x2\$";


