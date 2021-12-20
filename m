Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD48C47AEF1
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240085AbhLTPGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238171AbhLTPEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:04:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694A3C0613B3;
        Mon, 20 Dec 2021 06:52:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E266BB80EE5;
        Mon, 20 Dec 2021 14:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373F1C36AE7;
        Mon, 20 Dec 2021 14:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011946;
        bh=Efl4B0OU/hQtolbPwo5fICrUBijafGjm3Jb2ld6/uV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gg6Dkl4+zWWK9EM4tlkM/XarJIJZg+QDJETRK5vqE9U7ZNf0j/ubDafnT6IR6Z5N7
         AjEr2IBV91JtE8STBBzMosFW8HAeZF1pC9UDpzAvNaSHTLnc42dw2Qup2u0Y24lGOo
         XnCiz16+nOwiWEdO6ZesuZh90jvu1MfURrfA2PBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Marchand <jmarchan@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 025/177] recordmcount.pl: look for jgnop instruction as well as bcrl on s390
Date:   Mon, 20 Dec 2021 15:32:55 +0100
Message-Id: <20211220143040.927771657@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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
@@ -219,7 +219,7 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "s390" && $bits == 64) {
     if ($cc =~ /-DCC_USING_HOTPATCH/) {
-	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*c0 04 00 00 00 00\\s*brcl\\s*0,[0-9a-f]+ <([^\+]*)>\$";
+	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*c0 04 00 00 00 00\\s*(bcrl\\s*0,|jgnop\\s*)[0-9a-f]+ <([^\+]*)>\$";
 	$mcount_adjust = 0;
     }
     $alignment = 8;


