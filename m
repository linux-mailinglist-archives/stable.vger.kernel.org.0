Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74EA52E3DE6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437919AbgL1OVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502324AbgL1OVL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F5F1221F0;
        Mon, 28 Dec 2020 14:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165230;
        bh=fv281GONAecwfU735Iudm85vXf0DXrWC57GJ8ZIqFEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EV5vz0UnRrD5WtGHlkk0u41TlfqG9GnySvYY3MvPf0zkcq0T4wcTQcbK/afsYk8LB
         RC6ofN5CWR90MfnXz6l3lLw9C15hY6stXwbrY9Hptlao5LYfnK1R5GtEGwasAStHa0
         bttz5VFQWfmfftt/s1rFEcQ1ajcQfSNl5/C6PBNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 459/717] checkpatch: fix unescaped left brace
Date:   Mon, 28 Dec 2020 13:47:37 +0100
Message-Id: <20201228125042.959231952@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dwaipayan Ray <dwaipayanray1@gmail.com>

[ Upstream commit 03f4935135b9efeb780b970ba023c201f81cf4e6 ]

There is an unescaped left brace in a regex in OPEN_BRACE check.  This
throws a runtime error when checkpatch is run with --fix flag and the
OPEN_BRACE check is executed.

Fix it by escaping the left brace.

Link: https://lkml.kernel.org/r/20201115202928.81955-1-dwaipayanray1@gmail.com
Fixes: 8d1824780f2f ("checkpatch: add --fix option for a couple OPEN_BRACE misuses")
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index fab38b493cef7..0ad235ee96f91 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4384,7 +4384,7 @@ sub process {
 			    $fix) {
 				fix_delete_line($fixlinenr, $rawline);
 				my $fixed_line = $rawline;
-				$fixed_line =~ /(^..*$Type\s*$Ident\(.*\)\s*){(.*)$/;
+				$fixed_line =~ /(^..*$Type\s*$Ident\(.*\)\s*)\{(.*)$/;
 				my $line1 = $1;
 				my $line2 = $2;
 				fix_insert_line($fixlinenr, ltrim($line1));
-- 
2.27.0



