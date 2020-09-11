Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4C02666A7
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 19:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgIKRah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 13:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgIKMzi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 08:55:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 811DC22246;
        Fri, 11 Sep 2020 12:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599828893;
        bh=+h/p9gHHwVzsHz7LcGKUucRqugGoYlWRyIyoXbbg724=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+q+I1QVC2DWAnt32+Kz3cDUEHLc8gpeyXSGBJT76ovyOABEg+uREQWZNQ99CtSsI
         bFz3uuz39RuqVLDGU9H4SQnBwNNhCtSYFaiSWBT8pRO2rh5BU/vMqn+lECV8WtQSl5
         VGsoVlMbz2ROPfasYflUKrAfdAjBpdNJdUae7rgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mrinal Pandey <mrinalmni@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 47/62] checkpatch: fix the usage of capture group ( ... )
Date:   Fri, 11 Sep 2020 14:46:30 +0200
Message-Id: <20200911122504.739680751@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
References: <20200911122502.395450276@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mrinal Pandey <mrinalmni@gmail.com>

commit 13e45417cedbfc44b1926124b1846f5ee8c6ba4a upstream.

The usage of "capture group (...)" in the immediate condition after `&&`
results in `$1` being uninitialized.  This issues a warning "Use of
uninitialized value $1 in regexp compilation at ./scripts/checkpatch.pl
line 2638".

I noticed this bug while running checkpatch on the set of commits from
v5.7 to v5.8-rc1 of the kernel on the commits with a diff content in
their commit message.

This bug was introduced in the script by commit e518e9a59ec3
("checkpatch: emit an error when there's a diff in a changelog").  It
has been in the script since then.

The author intended to store the match made by capture group in variable
`$1`.  This should have contained the name of the file as `[\w/]+`
matched.  However, this couldn't be accomplished due to usage of capture
group and `$1` in the same regular expression.

Fix this by placing the capture group in the condition before `&&`.
Thus, `$1` can be initialized to the text that capture group matches
thereby setting it to the desired and required value.

Fixes: e518e9a59ec3 ("checkpatch: emit an error when there's a diff in a changelog")
Signed-off-by: Mrinal Pandey <mrinalmni@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Joe Perches <joe@perches.com>
Link: https://lkml.kernel.org/r/20200714032352.f476hanaj2dlmiot@mrinalpandey
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2195,8 +2195,8 @@ sub process {
 
 # Check if the commit log has what seems like a diff which can confuse patch
 		if ($in_commit_log && !$commit_log_has_diff &&
-		    (($line =~ m@^\s+diff\b.*a/[\w/]+@ &&
-		      $line =~ m@^\s+diff\b.*a/([\w/]+)\s+b/$1\b@) ||
+		    (($line =~ m@^\s+diff\b.*a/([\w/]+)@ &&
+		      $line =~ m@^\s+diff\b.*a/[\w/]+\s+b/$1\b@) ||
 		     $line =~ m@^\s*(?:\-\-\-\s+a/|\+\+\+\s+b/)@ ||
 		     $line =~ m/^\s*\@\@ \-\d+,\d+ \+\d+,\d+ \@\@/)) {
 			ERROR("DIFF_IN_COMMIT_MSG",


