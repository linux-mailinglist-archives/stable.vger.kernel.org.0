Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EB033B697
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCON6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:58:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230290AbhCON5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A35C64EED;
        Mon, 15 Mar 2021 13:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816651;
        bh=MHqxtauWUZmnwi1hBw6ubfs75cX/l+DmR8i5N+NavgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYdnnVReLAR7ZLl9Y1lihgGZQzd8czkumWOgUeT2v/XrHMYmhkRV6cWUXECWfZcHm
         BJA6D+avPKyAQBXDk5/YQBW83Zm2tcjN4sKyQCCgsqMXr7v4vrnf7XL58D247i0PCT
         GoP+wdrvyAiVjeUOnbX1gZjyhTc8dZm3vwValbjw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 034/290] docs: networking: drop special stable handling
Date:   Mon, 15 Mar 2021 14:52:07 +0100
Message-Id: <20210315135543.076297906@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Jakub Kicinski <kuba@kernel.org>

commit dbbe7c962c3a8163bf724dbc3c9fdfc9b16d3117 upstream.

Leave it to Greg.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/networking/netdev-FAQ.rst       |   78 ++------------------------
 Documentation/process/stable-kernel-rules.rst |    6 --
 Documentation/process/submitting-patches.rst  |    5 -
 3 files changed, 7 insertions(+), 82 deletions(-)

--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -144,77 +144,13 @@ Please send incremental versions on top
 the patches the way they would look like if your latest patch series was to be
 merged.
 
-Q: How can I tell what patches are queued up for backporting to the various stable releases?
---------------------------------------------------------------------------------------------
-A: Normally Greg Kroah-Hartman collects stable commits himself, but for
-networking, Dave collects up patches he deems critical for the
-networking subsystem, and then hands them off to Greg.
-
-There is a patchworks queue that you can see here:
-
-  https://patchwork.kernel.org/bundle/netdev/stable/?state=*
-
-It contains the patches which Dave has selected, but not yet handed off
-to Greg.  If Greg already has the patch, then it will be here:
-
-  https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
-
-A quick way to find whether the patch is in this stable-queue is to
-simply clone the repo, and then git grep the mainline commit ID, e.g.
-::
-
-  stable-queue$ git grep -l 284041ef21fdf2e
-  releases/3.0.84/ipv6-fix-possible-crashes-in-ip6_cork_release.patch
-  releases/3.4.51/ipv6-fix-possible-crashes-in-ip6_cork_release.patch
-  releases/3.9.8/ipv6-fix-possible-crashes-in-ip6_cork_release.patch
-  stable/stable-queue$
-
-Q: I see a network patch and I think it should be backported to stable.
------------------------------------------------------------------------
-Q: Should I request it via stable@vger.kernel.org like the references in
-the kernel's Documentation/process/stable-kernel-rules.rst file say?
-A: No, not for networking.  Check the stable queues as per above first
-to see if it is already queued.  If not, then send a mail to netdev,
-listing the upstream commit ID and why you think it should be a stable
-candidate.
-
-Before you jump to go do the above, do note that the normal stable rules
-in :ref:`Documentation/process/stable-kernel-rules.rst <stable_kernel_rules>`
-still apply.  So you need to explicitly indicate why it is a critical
-fix and exactly what users are impacted.  In addition, you need to
-convince yourself that you *really* think it has been overlooked,
-vs. having been considered and rejected.
-
-Generally speaking, the longer it has had a chance to "soak" in
-mainline, the better the odds that it is an OK candidate for stable.  So
-scrambling to request a commit be added the day after it appears should
-be avoided.
-
-Q: I have created a network patch and I think it should be backported to stable.
---------------------------------------------------------------------------------
-Q: Should I add a Cc: stable@vger.kernel.org like the references in the
-kernel's Documentation/ directory say?
-A: No.  See above answer.  In short, if you think it really belongs in
-stable, then ensure you write a decent commit log that describes who
-gets impacted by the bug fix and how it manifests itself, and when the
-bug was introduced.  If you do that properly, then the commit will get
-handled appropriately and most likely get put in the patchworks stable
-queue if it really warrants it.
-
-If you think there is some valid information relating to it being in
-stable that does *not* belong in the commit log, then use the three dash
-marker line as described in
-:ref:`Documentation/process/submitting-patches.rst <the_canonical_patch_format>`
-to temporarily embed that information into the patch that you send.
-
-Q: Are all networking bug fixes backported to all stable releases?
-------------------------------------------------------------------
-A: Due to capacity, Dave could only take care of the backports for the
-last two stable releases. For earlier stable releases, each stable
-branch maintainer is supposed to take care of them. If you find any
-patch is missing from an earlier stable branch, please notify
-stable@vger.kernel.org with either a commit ID or a formal patch
-backported, and CC Dave and other relevant networking developers.
+Q: Are there special rules regarding stable submissions on netdev?
+---------------------------------------------------------------
+While it used to be the case that netdev submissions were not supposed
+to carry explicit ``CC: stable@vger.kernel.org`` tags that is no longer
+the case today. Please follow the standard stable rules in
+:ref:`Documentation/process/stable-kernel-rules.rst <stable_kernel_rules>`,
+and make sure you include appropriate Fixes tags!
 
 Q: Is the comment style convention different for the networking content?
 ------------------------------------------------------------------------
--- a/Documentation/process/stable-kernel-rules.rst
+++ b/Documentation/process/stable-kernel-rules.rst
@@ -35,12 +35,6 @@ Rules on what kind of patches are accept
 Procedure for submitting patches to the -stable tree
 ----------------------------------------------------
 
- - If the patch covers files in net/ or drivers/net please follow netdev stable
-   submission guidelines as described in
-   :ref:`Documentation/networking/netdev-FAQ.rst <netdev-FAQ>`
-   after first checking the stable networking queue at
-   https://patchwork.kernel.org/bundle/netdev/stable/?state=*
-   to ensure the requested patch is not already queued up.
  - Security patches should not be handled (solely) by the -stable review
    process but should follow the procedures in
    :ref:`Documentation/admin-guide/security-bugs.rst <securitybugs>`.
--- a/Documentation/process/submitting-patches.rst
+++ b/Documentation/process/submitting-patches.rst
@@ -250,11 +250,6 @@ should also read
 :ref:`Documentation/process/stable-kernel-rules.rst <stable_kernel_rules>`
 in addition to this file.
 
-Note, however, that some subsystem maintainers want to come to their own
-conclusions on which patches should go to the stable trees.  The networking
-maintainer, in particular, would rather not see individual developers
-adding lines like the above to their patches.
-
 If changes affect userland-kernel interfaces, please send the MAN-PAGES
 maintainer (as listed in the MAINTAINERS file) a man-pages patch, or at
 least a notification of the change, so that some information makes its way


