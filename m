Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3F71FE850
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgFRCrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728453AbgFRBKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F6CA214DB;
        Thu, 18 Jun 2020 01:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442618;
        bh=ygnmffc6E/5pFy7Ll49LQ6rLAHAwoxGSATRztms2DHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EB1Dw6B0AEP1+BBL9WjF6BtxbBAO/4LiGEMK099lZDhyFy7gcMsEKETaLJRLaNQAL
         MX7Ps4m9SNo9DDjldG6993T7RW5/WUTRcDNmU/yzHmoGK4u2KFknsxOfuS8nq8w7Sm
         HOLKvn648Do3F3OgO+/TaFVF8/OyHn5JaU9Ipx0Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 098/388] apparmor: fix introspection of of task mode for unconfined tasks
Date:   Wed, 17 Jun 2020 21:03:15 -0400
Message-Id: <20200618010805.600873-98-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 470693239e64..6c3acae701ef 100644
--- a/security/apparmor/label.c
+++ b/security/apparmor/label.c
@@ -1531,13 +1531,13 @@ static const char *label_modename(struct aa_ns *ns, struct aa_label *label,
 
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

