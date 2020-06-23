Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CF2206195
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404008AbgFWUpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392685AbgFWUp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:45:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA13120781;
        Tue, 23 Jun 2020 20:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945129;
        bh=08kRE9xJpAdoX2wEKMab3pugKkKAumuZV7XRl7t29kA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkTyD2vx19fjPPwgchpbD3MjxPcfxE8t/OKYi4LAD5oNyfMdqh5Jbd6An7xSPm1d9
         ZTNuNcAp8tRg7EjFYcc139818z61JVDgUFj3fVbftlUbb3/d5wjSVzpEy6dJC2/con
         AsctDGmCtSJ5DeYPeoLmMTzTWOXOsbwtbT24/KE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 033/136] apparmor: fix introspection of of task mode for unconfined tasks
Date:   Tue, 23 Jun 2020 21:58:09 +0200
Message-Id: <20200623195305.315757092@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit dd2569fbb053719f7df7ef8fdbb45cf47156a701 ]

Fix two issues with introspecting the task mode.

1. If a task is attached to a unconfined profile that is not the
   ns->unconfined profile then. Mode the mode is always reported
   as -

      $ ps -Z
      LABEL                               PID TTY          TIME CMD
      unconfined                         1287 pts/0    00:00:01 bash
      test (-)                           1892 pts/0    00:00:00 ps

   instead of the correct value of (unconfined) as shown below

      $ ps -Z
      LABEL                               PID TTY          TIME CMD
      unconfined                         2483 pts/0    00:00:01 bash
      test (unconfined)                  3591 pts/0    00:00:00 ps

2. if a task is confined by a stack of profiles that are unconfined
   the output of label mode is again the incorrect value of (-) like
   above, instead of (unconfined). This is because the visibile
   profile count increment is skipped by the special casing of
   unconfined.

Fixes: f1bd904175e8 ("apparmor: add the base fns() for domain labels")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/label.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/label.c b/security/apparmor/label.c
index ea63710442ae5..212a0f39ddae8 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1536,13 +1536,13 @@ static const char *label_modename(struct aa_ns *ns, struct aa_label *label,
 
 	label_for_each(i, label, profile) {
 		if (aa_ns_visible(ns, profile->ns, flags & FLAG_VIEW_SUBNS)) {
-			if (profile->mode == APPARMOR_UNCONFINED)
+			count++;
+			if (profile == profile->ns->unconfined)
 				/* special case unconfined so stacks with
 				 * unconfined don't report as mixed. ie.
 				 * profile_foo//&:ns1:unconfined (mixed)
 				 */
 				continue;
-			count++;
 			if (mode == -1)
 				mode = profile->mode;
 			else if (mode != profile->mode)
-- 
2.25.1



