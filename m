Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18E661691
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbfGGTks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:40:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58038 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727670AbfGGTiR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:17 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCzG-0006jU-Fs; Sun, 07 Jul 2019 20:38:14 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz8-0005fX-Mg; Sun, 07 Jul 2019 20:38:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Brendan Higgins" <brendanhiggins@google.com>,
        "Kees Cook" <keescook@chromium.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Luis Chamberlain" <mcgrof@kernel.org>,
        "Zev Weiss" <zev@bewilderbeest.net>,
        "Iurii Zaikin" <yzaikin@google.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.956578027@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 113/129] kernel/sysctl.c: add missing range check in
 do_proc_dointvec_minmax_conv
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Zev Weiss <zev@bewilderbeest.net>

commit 8cf7630b29701d364f8df4a50e4f1f5e752b2778 upstream.

This bug has apparently existed since the introduction of this function
in the pre-git era (4500e91754d3 in Thomas Gleixner's history.git,
"[NET]: Add proc_dointvec_userhz_jiffies, use it for proper handling of
neighbour sysctls.").

As a minimal fix we can simply duplicate the corresponding check in
do_proc_dointvec_conv().

Link: http://lkml.kernel.org/r/20190207123426.9202-3-zev@bewilderbeest.net
Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/sysctl.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2179,7 +2179,16 @@ static int do_proc_dointvec_minmax_conv(
 {
 	struct do_proc_dointvec_minmax_conv_param *param = data;
 	if (write) {
-		int val = *negp ? -*lvalp : *lvalp;
+		int val;
+		if (*negp) {
+			if (*lvalp > (unsigned long) INT_MAX + 1)
+				return -EINVAL;
+			val = -*lvalp;
+		} else {
+			if (*lvalp > (unsigned long) INT_MAX)
+				return -EINVAL;
+			val = *lvalp;
+		}
 		if ((param->min && *param->min > val) ||
 		    (param->max && *param->max < val))
 			return -EINVAL;

