Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60EA47AC98
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbhLTOpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:45:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36322 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236236AbhLTOoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:44:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AE3A611A3;
        Mon, 20 Dec 2021 14:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E96C36AE8;
        Mon, 20 Dec 2021 14:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011462;
        bh=xevNN71LVY1590c+Mb0u1A4Tv0j38C6SG/2qB4Q5KjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SD+FxMrBggqLxR+zf7JwnosNnWThce9+MB9YH7wXK0G9IvKqosRyfzD1V2WwAY/Lq
         mtv3r5/ThWks+hryvcoGCvRQF+bwq+kVaAOy16Gm81QRjVvRdB/KD1LMPmhJLZnCYQ
         NXOHUE9AI3rkYQAOgk7+oXsrnr/lssMONx78TyYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Marchand <jmarchan@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.4 06/71] recordmcount.pl: look for jgnop instruction as well as bcrl on s390
Date:   Mon, 20 Dec 2021 15:33:55 +0100
Message-Id: <20211220143025.896806171@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
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


