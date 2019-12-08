Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76D711621A
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfLHN5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:57:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60162 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726720AbfLHNym (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:42 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1D-0007ec-86; Sun, 08 Dec 2019 13:54:39 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1B-0002NS-Ox; Sun, 08 Dec 2019 13:54:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        "Eric Dumazet" <edumazet@google.com>,
        "syzbot" <syzkaller@googlegroups.com>
Date:   Sun, 08 Dec 2019 13:53:22 +0000
Message-ID: <lsq.1575813165.194100818@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 38/72] sch_netem: fix a divide by zero in tabledist()
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit b41d936b5ecfdb3a4abc525ce6402a6c49cffddc upstream.

syzbot managed to crash the kernel in tabledist() loading
an empty distribution table.

	t = dist->table[rnd % dist->size];

Simply return an error when such load is attempted.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sched/sch_netem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -737,7 +737,7 @@ static int get_dist_table(struct Qdisc *
 	int i;
 	size_t s;
 
-	if (n > NETEM_DIST_MAX)
+	if (!n || n > NETEM_DIST_MAX)
 		return -EINVAL;
 
 	s = sizeof(struct disttable) + n * sizeof(s16);

