Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A40D81C0F
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729972AbfHENTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729942AbfHENTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:19:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 987742075B;
        Mon,  5 Aug 2019 13:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011192;
        bh=xdCYdjfiBaSQZRO9aUNInNiabgYff/7tlTke98MlrR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDEXqrpyqp6BujLhpnnmmmh+eBd889w4C6Lje44j35+/qJC6zDC/2dGzth9W69GSC
         gMmLQno+Qs+ays/ilga+JKLDD2qnm1rf95nns27/be9fQ3TUt9zCSldHec8t8md0CG
         I7837q7x6gK3WzWKBHxoszeglkcyNex97trXFzus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Down <chris@chrisdown.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 55/74] cgroup: kselftest: relax fs_spec checks
Date:   Mon,  5 Aug 2019 15:03:08 +0200
Message-Id: <20190805124940.331222447@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
References: <20190805124935.819068648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Down <chris@chrisdown.name>

commit b59b1baab789eacdde809135542e3d4f256f6878 upstream.

On my laptop most memcg kselftests were being skipped because it claimed
cgroup v2 hierarchy wasn't mounted, but this isn't correct.  Instead, it
seems current systemd HEAD mounts it with the name "cgroup2" instead of
"cgroup":

    % grep cgroup /proc/mounts
    cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate 0 0

I can't think of a reason to need to check fs_spec explicitly
since it's arbitrary, so we can just rely on fs_vfstype.

After these changes, `make TARGETS=cgroup kselftest` actually runs the
cgroup v2 tests in more cases.

Link: http://lkml.kernel.org/r/20190723210737.GA487@chrisdown.name
Signed-off-by: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/cgroup/cgroup_util.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -181,8 +181,7 @@ int cg_find_unified_root(char *root, siz
 		strtok(NULL, delim);
 		strtok(NULL, delim);
 
-		if (strcmp(fs, "cgroup") == 0 &&
-		    strcmp(type, "cgroup2") == 0) {
+		if (strcmp(type, "cgroup2") == 0) {
 			strncpy(root, mount, len);
 			return 0;
 		}


