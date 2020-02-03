Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B75150D76
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgBCQ31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:29:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:41326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbgBCQ3Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:29:24 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D532620838;
        Mon,  3 Feb 2020 16:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747363;
        bh=c1kq3Vr1LqcekrWbgosoYhJ9/vuPtVzVuYR7vq0VoQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZybKV55ieXyMNW+OLzHdGErLg3d8MI4t3fxPxjd1oF1MXCTVmFry7183kE9r7HN6
         gsQiTkOJP0Fd/j7mprX5NNA3rJ1dU7Y/tA7QoHXZ519OfRYn4mevEYETRAHhennOPM
         oVDEfgLKnTwF00dQCeRSF4vwEX44vO4iC4tA575A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+5493b2a54d31d6aea629@syzkaller.appspotmail.com,
        Christian Brauner <christian.brauner@ubuntu.com>,
        =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.14 51/89] cgroup: Prevent double killing of css when enabling threaded cgroup
Date:   Mon,  3 Feb 2020 16:19:36 +0000
Message-Id: <20200203161923.701961119@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Koutný <mkoutny@suse.com>

commit 3bc0bb36fa30e95ca829e9cf480e1ef7f7638333 upstream.

The test_cgcore_no_internal_process_constraint_on_threads selftest when
running with subsystem controlling noise triggers two warnings:

> [  597.443115] WARNING: CPU: 1 PID: 28167 at kernel/cgroup/cgroup.c:3131 cgroup_apply_control_enable+0xe0/0x3f0
> [  597.443413] WARNING: CPU: 1 PID: 28167 at kernel/cgroup/cgroup.c:3177 cgroup_apply_control_disable+0xa6/0x160

Both stem from a call to cgroup_type_write. The first warning was also
triggered by syzkaller.

When we're switching cgroup to threaded mode shortly after a subsystem
was disabled on it, we can see the respective subsystem css dying there.

The warning in cgroup_apply_control_enable is harmless in this case
since we're not adding new subsys anyway.
The warning in cgroup_apply_control_disable indicates an attempt to kill
css of recently disabled subsystem repeatedly.

The commit prevents these situations by making cgroup_type_write wait
for all dying csses to go away before re-applying subtree controls.
When at it, the locations of WARN_ON_ONCE calls are moved so that
warning is triggered only when we are about to misuse the dying css.

Reported-by: syzbot+5493b2a54d31d6aea629@syzkaller.appspotmail.com
Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup/cgroup.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2884,8 +2884,6 @@ static int cgroup_apply_control_enable(s
 		for_each_subsys(ss, ssid) {
 			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
 
-			WARN_ON_ONCE(css && percpu_ref_is_dying(&css->refcnt));
-
 			if (!(cgroup_ss_mask(dsct) & (1 << ss->id)))
 				continue;
 
@@ -2895,6 +2893,8 @@ static int cgroup_apply_control_enable(s
 					return PTR_ERR(css);
 			}
 
+			WARN_ON_ONCE(percpu_ref_is_dying(&css->refcnt));
+
 			if (css_visible(css)) {
 				ret = css_populate_dir(css);
 				if (ret)
@@ -2930,11 +2930,11 @@ static void cgroup_apply_control_disable
 		for_each_subsys(ss, ssid) {
 			struct cgroup_subsys_state *css = cgroup_css(dsct, ss);
 
-			WARN_ON_ONCE(css && percpu_ref_is_dying(&css->refcnt));
-
 			if (!css)
 				continue;
 
+			WARN_ON_ONCE(percpu_ref_is_dying(&css->refcnt));
+
 			if (css->parent &&
 			    !(cgroup_ss_mask(dsct) & (1 << ss->id))) {
 				kill_css(css);
@@ -3221,7 +3221,8 @@ static ssize_t cgroup_type_write(struct
 	if (strcmp(strstrip(buf), "threaded"))
 		return -EINVAL;
 
-	cgrp = cgroup_kn_lock_live(of->kn, false);
+	/* drain dying csses before we re-apply (threaded) subtree control */
+	cgrp = cgroup_kn_lock_live(of->kn, true);
 	if (!cgrp)
 		return -ENOENT;
 


