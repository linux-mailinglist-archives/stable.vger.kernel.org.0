Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1A27122055
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbfLQAyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:54:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35514 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727174AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0003Mi-15; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0005cK-Af; Tue, 17 Dec 2019 00:51:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Yihui ZENG" <yzeng56@asu.edu>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Heiko Carstens" <heiko.carstens@de.ibm.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date:   Tue, 17 Dec 2019 00:47:25 +0000
Message-ID: <lsq.1576543535.376923680@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 111/136] s390/cmm: fix information leak in
 cmm_timeout_handler()
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yihui ZENG <yzeng56@asu.edu>

commit b8e51a6a9db94bc1fb18ae831b3dab106b5a4b5f upstream.

The problem is that we were putting the NUL terminator too far:

	buf[sizeof(buf) - 1] = '\0';

If the user input isn't NUL terminated and they haven't initialized the
whole buffer then it leads to an info leak.  The NUL terminator should
be:

	buf[len - 1] = '\0';

Signed-off-by: Yihui Zeng <yzeng56@asu.edu>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
[heiko.carstens@de.ibm.com: keep semantics of how *lenp and *ppos are handled]
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/mm/cmm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -306,16 +306,16 @@ static int cmm_timeout_handler(struct ct
 	}
 
 	if (write) {
-		len = *lenp;
-		if (copy_from_user(buf, buffer,
-				   len > sizeof(buf) ? sizeof(buf) : len))
+		len = min(*lenp, sizeof(buf));
+		if (copy_from_user(buf, buffer, len))
 			return -EFAULT;
-		buf[sizeof(buf) - 1] = '\0';
+		buf[len - 1] = '\0';
 		cmm_skip_blanks(buf, &p);
 		nr = simple_strtoul(p, &p, 0);
 		cmm_skip_blanks(p, &p);
 		seconds = simple_strtoul(p, &p, 0);
 		cmm_set_timeout(nr, seconds);
+		*ppos += *lenp;
 	} else {
 		len = sprintf(buf, "%ld %ld\n",
 			      cmm_timeout_pages, cmm_timeout_seconds);
@@ -323,9 +323,9 @@ static int cmm_timeout_handler(struct ct
 			len = *lenp;
 		if (copy_to_user(buffer, buf, len))
 			return -EFAULT;
+		*lenp = len;
+		*ppos += len;
 	}
-	*lenp = len;
-	*ppos += len;
 	return 0;
 }
 

