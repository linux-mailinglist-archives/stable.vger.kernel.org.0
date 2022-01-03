Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFEC74831C4
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbiACOVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233273AbiACOVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:21:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3047CC061785;
        Mon,  3 Jan 2022 06:21:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A29FACE1105;
        Mon,  3 Jan 2022 14:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675BBC36AED;
        Mon,  3 Jan 2022 14:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219699;
        bh=ZQgnCo8OBOk9Ubp5ftiP95eaf1PHz3x3szgPpbV/w5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PghP+Xk8cGfOPl++nabmPotVKkcxeF8SEEymDQUYtuNWopNpaoyzVaEtHesSObekf
         +tg++ajBi0r58tPaeGXpSS8j1tyVuU9XtVB9ZEeelNQUhvpYQHyuzzIWpS8hCBOW9H
         1tWLQN9MYBBpKncXSO+BQoTZIwWok8NKeU9j72vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Jerome Marchand <jmarchan@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 4.4 02/11] recordmcount.pl: fix typo in s390 mcount regex
Date:   Mon,  3 Jan 2022 15:21:13 +0100
Message-Id: <20220103142050.853155290@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142050.763904028@linuxfoundation.org>
References: <20220103142050.763904028@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

commit 4eb1782eaa9fa1c224ad1fa0d13a9f09c3ab2d80 upstream.

Commit 85bf17b28f97 ("recordmcount.pl: look for jgnop instruction as well
as bcrl on s390") added a new alternative mnemonic for the existing brcl
instruction. This is required for the combination old gcc version (pre 9.0)
and binutils since version 2.37.
However at the same time this commit introduced a typo, replacing brcl with
bcrl. As a result no mcount locations are detected anymore with old gcc
versions (pre 9.0) and binutils before version 2.37.
Fix this by using the correct mnemonic again.

Reported-by: Miroslav Benes <mbenes@suse.cz>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: <stable@vger.kernel.org>
Fixes: 85bf17b28f97 ("recordmcount.pl: look for jgnop instruction as well as bcrl on s390")
Link: https://lore.kernel.org/r/alpine.LSU.2.21.2112230949520.19849@pobox.suse.cz
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/recordmcount.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -248,7 +248,7 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "s390" && $bits == 64) {
     if ($cc =~ /-DCC_USING_HOTPATCH/) {
-	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*c0 04 00 00 00 00\\s*(bcrl\\s*0,|jgnop\\s*)[0-9a-f]+ <([^\+]*)>\$";
+	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*c0 04 00 00 00 00\\s*(brcl\\s*0,|jgnop\\s*)[0-9a-f]+ <([^\+]*)>\$";
 	$mcount_adjust = 0;
     } else {
 	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_(PC|PLT)32DBL\\s+_mcount\\+0x2\$";


