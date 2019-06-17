Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8668B493FA
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfFQVXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729798AbfFQVXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:23:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FED2063F;
        Mon, 17 Jun 2019 21:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806629;
        bh=kJ5JTwgCEYcI+hFwmE4jkYxJJCOO4tFsYdl/XPLK8vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c0xs6WL3CALJ6CNbhwZIz17iGw+930MPljVT/i8c794FTnNxxgfnzTgvwTbax4tnY
         6CdNsW4MTXPm7sWvUPDUsNcrTb6ZB9LVhH97p9GFco44fCd+xPVv5eYhOTEFad6h6H
         pAZmdEmBx8d0Xc1RWLrxZqNGDIcoKnpnSU0ahHGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Raspl <raspl@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 094/115] tools/kvm_stat: fix fields filter for child events
Date:   Mon, 17 Jun 2019 23:09:54 +0200
Message-Id: <20190617210804.722941384@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210759.929316339@linuxfoundation.org>
References: <20190617210759.929316339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 883d25e70b2f699fed9017e509d1ef8e36229b89 ]

The fields filter would not work with child fields, as the respective
parents would not be included. No parents displayed == no childs displayed.
To reproduce, run on s390 (would work on other platforms, too, but would
require a different filter name):
- Run 'kvm_stat -d'
- Press 'f'
- Enter 'instruct'
Notice that events like instruction_diag_44 or instruction_diag_500 are not
displayed - the output remains empty.
With this patch, we will filter by matching events and their parents.
However, consider the following example where we filter by
instruction_diag_44:

  kvm statistics - summary
                   regex filter: instruction_diag_44
   Event                                         Total %Total CurAvg/s
   exit_instruction                                276  100.0       12
     instruction_diag_44                           256   92.8       11
   Total                                           276              12

Note that the parent ('exit_instruction') displays the total events, but
the childs listed do not match its total (256 instead of 276). This is
intended (since we're filtering all but one child), but might be confusing
on first sight.

Signed-off-by: Stefan Raspl <raspl@linux.ibm.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/kvm/kvm_stat/kvm_stat     | 16 ++++++++++++----
 tools/kvm/kvm_stat/kvm_stat.txt |  2 ++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 2ed395b817cb..bc508dae286c 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -575,8 +575,12 @@ class TracepointProvider(Provider):
     def update_fields(self, fields_filter):
         """Refresh fields, applying fields_filter"""
         self.fields = [field for field in self._get_available_fields()
-                       if self.is_field_wanted(fields_filter, field) or
-                       ARCH.tracepoint_is_child(field)]
+                       if self.is_field_wanted(fields_filter, field)]
+        # add parents for child fields - otherwise we won't see any output!
+        for field in self._fields:
+            parent = ARCH.tracepoint_is_child(field)
+            if (parent and parent not in self._fields):
+                self.fields.append(parent)
 
     @staticmethod
     def _get_online_cpus():
@@ -735,8 +739,12 @@ class DebugfsProvider(Provider):
     def update_fields(self, fields_filter):
         """Refresh fields, applying fields_filter"""
         self._fields = [field for field in self._get_available_fields()
-                        if self.is_field_wanted(fields_filter, field) or
-                        ARCH.debugfs_is_child(field)]
+                        if self.is_field_wanted(fields_filter, field)]
+        # add parents for child fields - otherwise we won't see any output!
+        for field in self._fields:
+            parent = ARCH.debugfs_is_child(field)
+            if (parent and parent not in self._fields):
+                self.fields.append(parent)
 
     @property
     def fields(self):
diff --git a/tools/kvm/kvm_stat/kvm_stat.txt b/tools/kvm/kvm_stat/kvm_stat.txt
index 0811d860fe75..c057ba52364e 100644
--- a/tools/kvm/kvm_stat/kvm_stat.txt
+++ b/tools/kvm/kvm_stat/kvm_stat.txt
@@ -34,6 +34,8 @@ INTERACTIVE COMMANDS
 *c*::	clear filter
 
 *f*::	filter by regular expression
+ ::     *Note*: Child events pull in their parents, and parents' stats summarize
+                all child events, not just the filtered ones
 
 *g*::	filter by guest name/PID
 
-- 
2.20.1



