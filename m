Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CBB31BC85
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhBOPaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:30:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:45436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230326AbhBOP3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:29:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 615DA64DC3;
        Mon, 15 Feb 2021 15:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613402906;
        bh=fRJDX+cENMlG/2vYLBrfqFvQ8pafD1lpb2lwu6ZThbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z/s80luRzdtm/dOEWU5iNs8vwOtexQ4yOqS4KwVkXwHfbKav/qDCgjuLQ/VFk30Ka
         dSqIacwbKJ7O2DePv/pH3AVMm0gf9+574dVBWFjHrT8AoY1LDgVE46BVfhbqo2jxEW
         a/29u2usWybTnNXPCYsWnGx49eu4DBGtps9puyJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Odin Ugedal <odin@uged.al>,
        Suren Baghdasaryan <surenb@google.com>,
        Dan Schatzberg <dschatzberg@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.4 06/60] cgroup: fix psi monitor for root cgroup
Date:   Mon, 15 Feb 2021 16:26:54 +0100
Message-Id: <20210215152715.593729352@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152715.401453874@linuxfoundation.org>
References: <20210215152715.401453874@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Odin Ugedal <odin@uged.al>

commit 385aac1519417b89cb91b77c22e4ca21db563cd0 upstream.

Fix NULL pointer dereference when adding new psi monitor to the root
cgroup. PSI files for root cgroup was introduced in df5ba5be742 by using
system wide psi struct when reading, but file write/monitor was not
properly fixed. Since the PSI config for the root cgroup isn't
initialized, the current implementation tries to lock a NULL ptr,
resulting in a crash.

Can be triggered by running this as root:
$ tee /sys/fs/cgroup/cpu.pressure <<< "some 10000 1000000"

Signed-off-by: Odin Ugedal <odin@uged.al>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Dan Schatzberg <dschatzberg@fb.com>
Fixes: df5ba5be7425 ("kernel/sched/psi.c: expose pressure metrics on root cgroup")
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@vger.kernel.org # 5.2+
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cgroup.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3627,6 +3627,7 @@ static ssize_t cgroup_pressure_write(str
 {
 	struct psi_trigger *new;
 	struct cgroup *cgrp;
+	struct psi_group *psi;
 
 	cgrp = cgroup_kn_lock_live(of->kn, false);
 	if (!cgrp)
@@ -3635,7 +3636,8 @@ static ssize_t cgroup_pressure_write(str
 	cgroup_get(cgrp);
 	cgroup_kn_unlock(of->kn);
 
-	new = psi_trigger_create(&cgrp->psi, buf, nbytes, res);
+	psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
+	new = psi_trigger_create(psi, buf, nbytes, res);
 	if (IS_ERR(new)) {
 		cgroup_put(cgrp);
 		return PTR_ERR(new);


