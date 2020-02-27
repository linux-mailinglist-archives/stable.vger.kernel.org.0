Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3030171D24
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389842AbgB0OSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:18:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:58762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389836AbgB0OSN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:18:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1A3524690;
        Thu, 27 Feb 2020 14:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582813092;
        bh=sTkbE07uYBnzZWy9lmP//6CmwEwxm85Ec6JFbqalEwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaD1ylT8Fp+3/r7Tf+kloiqZHB3nguVg2vmepAIbr3A5tRVjAPEvUthjgbnJUFX+2
         NxyC0AYAALFWnu2YSP3l3Mx/VmmLY4sXN4M20zXd4S4unjYWCvqYeCJ+HL8asIpCt5
         aoEPVhnQzW5TeAyP2WkTgAMmge0aay+5Vsg119BA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Joe Perches <joe@perches.com>, Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.5 133/150] scripts/get_maintainer.pl: deprioritize old Fixes: addresses
Date:   Thu, 27 Feb 2020 14:37:50 +0100
Message-Id: <20200227132252.076691216@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit 0ef82fcefb99300ede6f4d38a8100845b2dc8e30 upstream.

Recently, I found that get_maintainer was causing me to send emails to
the old addresses for maintainers.  Since I usually just trust the
output of get_maintainer to know the right email address, I didn't even
look carefully and fired off two patch series that went to the wrong
place.  Oops.

The problem was introduced recently when trying to add signatures from
Fixes.  The problem was that these email addresses were added too early
in the process of compiling our list of places to send.  Things added to
the list earlier are considered more canonical and when we later added
maintainer entries we ended up deduplicating to the old address.

Here are two examples using mainline commits (to make it easier to
replicate) for the two maintainers that I messed up recently:

  $ git format-patch d8549bcd0529~..d8549bcd0529
  $ ./scripts/get_maintainer.pl 0001-clk-Add-clk_hw*.patch | grep Boyd
  Stephen Boyd <sboyd@codeaurora.org>...

  $ git format-patch 6d1238aa3395~..6d1238aa3395
  $ ./scripts/get_maintainer.pl 0001-arm64-dts-qcom-qcs404*.patch | grep Andy
  Andy Gross <andy.gross@linaro.org>

Let's move the adding of addresses from Fixes: to the end since the
email addresses from these are much more likely to be older.

After this patch the above examples get the right addresses for the two
examples.

Link: http://lkml.kernel.org/r/20200127095001.1.I41fba9f33590bfd92cd01960161d8384268c6569@changeid
Fixes: 2f5bd343694e ("scripts/get_maintainer.pl: add signatures from Fixes: <badcommit> lines in commit message")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Andy Gross <agross@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/get_maintainer.pl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -932,10 +932,6 @@ sub get_maintainers {
 	}
     }
 
-    foreach my $fix (@fixes) {
-	vcs_add_commit_signers($fix, "blamed_fixes");
-    }
-
     foreach my $email (@email_to, @list_to) {
 	$email->[0] = deduplicate_email($email->[0]);
     }
@@ -974,6 +970,10 @@ sub get_maintainers {
 	}
     }
 
+    foreach my $fix (@fixes) {
+	vcs_add_commit_signers($fix, "blamed_fixes");
+    }
+
     my @to = ();
     if ($email || $email_list) {
 	if ($email) {


