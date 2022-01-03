Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3102748330C
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbiACOdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:33:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33898 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbiACOa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:30:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CADA0B80EF2;
        Mon,  3 Jan 2022 14:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D729CC36AED;
        Mon,  3 Jan 2022 14:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220255;
        bh=vBlXvtGXIBXY7k63cseuQewCD2slOaQoWOX0j3jkUOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqHiCYkEyz4+p9uG6ZdoQ5EFGgMA+eQj/GyCv+tdOqe/jupDef3kSCasLcD0mKpDy
         sXOnWXn8ZZ4LWi/LK/VhaBLDN5fVQNek5K3UVrP0WOrLhad/ew/Es8cqnPriOMB+IF
         STQlCf8IdKFpK3IyvrOeecNtBnp9tZvIjFGeZHAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Jerome Marchand <jmarchan@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.15 12/73] recordmcount.pl: fix typo in s390 mcount regex
Date:   Mon,  3 Jan 2022 15:23:33 +0100
Message-Id: <20220103142057.311935780@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
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
@@ -219,7 +219,7 @@ if ($arch eq "x86_64") {
 
 } elsif ($arch eq "s390" && $bits == 64) {
     if ($cc =~ /-DCC_USING_HOTPATCH/) {
-	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*c0 04 00 00 00 00\\s*(bcrl\\s*0,|jgnop\\s*)[0-9a-f]+ <([^\+]*)>\$";
+	$mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*c0 04 00 00 00 00\\s*(brcl\\s*0,|jgnop\\s*)[0-9a-f]+ <([^\+]*)>\$";
 	$mcount_adjust = 0;
     }
     $alignment = 8;


