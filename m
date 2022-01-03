Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCF34832C7
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbiACOap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbiACO3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:29:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537FFC06137A;
        Mon,  3 Jan 2022 06:29:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7E7D610F4;
        Mon,  3 Jan 2022 14:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD6E1C36AED;
        Mon,  3 Jan 2022 14:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220151;
        bh=kzFB35nUgKEGPQmA/GQT7vVblxDe8PHNHe1KRrpLT48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPNOfgOHHCP4WE3y2GL1YDBoD5r9d/f6pg3+1qHBaWkCl3dzrMtuq/AQb9ucMs7iH
         CO1Q6p1tL1pqUheYIbpSIWrxV5TuYH0Tm7Y1YR14aQh1AoVGTmgiF31WcHSR1axEHm
         5oyFyrSdznw0ncbtK0LQ5cHRhp+/z3CyboGnWBtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Jerome Marchand <jmarchan@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.10 08/48] recordmcount.pl: fix typo in s390 mcount regex
Date:   Mon,  3 Jan 2022 15:23:45 +0100
Message-Id: <20220103142053.762314158@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
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
@@ -252,7 +252,7 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "s390" && $bits == 64) {
     if ($cc =~ /-DCC_USING_HOTPATCH/) {
-	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*c0 04 00 00 00 00\\s*(bcrl\\s*0,|jgnop\\s*)[0-9a-f]+ <([^\+]*)>\$";
+	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*c0 04 00 00 00 00\\s*(brcl\\s*0,|jgnop\\s*)[0-9a-f]+ <([^\+]*)>\$";
 	$mcount_adjust = 0;
     } else {
 	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_(PC|PLT)32DBL\\s+_mcount\\+0x2\$";


