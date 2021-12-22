Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5390747D11E
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 12:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhLVLif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 06:38:35 -0500
Received: from avasout-ptp-003.plus.net ([84.93.230.244]:45489 "EHLO
        avasout-ptp-003.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244717AbhLVLie (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 06:38:34 -0500
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Dec 2021 06:38:34 EST
Received: from deneb.mcrowe.com ([80.229.24.9])
        by smtp with ESMTP
        id zzpimUplcZR9PzzpjmZ3PR; Wed, 22 Dec 2021 11:31:00 +0000
X-Clacks-Overhead: "GNU Terry Pratchett"
X-CM-Score: 0.00
X-CNFS-Analysis: v=2.4 cv=OeX7sjfY c=1 sm=1 tr=0 ts=61c30c74
 a=E/9URZZQ5L3bK/voZ0g0HQ==:117 a=E/9URZZQ5L3bK/voZ0g0HQ==:17
 a=IOMw9HtfNCkA:10 a=CCpqsmhAAAAA:8 a=D19gQVrFAAAA:8 a=-An2I_7KAAAA:8
 a=9qxNCY_qAAAA:8 a=VwQbUJbxAAAA:8 a=YyH_z52Fk-ja-1bQ6OcA:9
 a=ul9cdbp4aOFLsgKbc677:22 a=W4TVW4IDbPiebHqcZpNg:22 a=Sq34B_EcNBM9_nrAYB9S:22
 a=A2X48xt2e1hG9NJDz63Y:22 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mcrowe.com;
        s=20191005; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        In-Reply-To:References; bh=utmR9QeNiZBZ8h/FI3HecPMypJ030sfratlWW4ClVGY=; b=nD
        RRz3Q7kpv/iUFW7Sz69GAQbHA+/kh+4+cm0fPCs4xNB6Z/ugBsNtqLMXSuIG4gmu5QDKNAfYZkRTA
        O9ISqPykyeMPqgi0FvUZ0fHfp+SvRvghkUpVHme1B/qXypdtidqJxTWa75Lp8DSLR04/Ynpap9Q9B
        y9bUAQjWJL2MJrIb6GUCC6mYjxtcc9SFoR4k2RttAetLdZsH3zFR8+9ROUEydXFZGJYMpX3cTmuBe
        3Nxzr+ZsbLdqJy5iI0mqLVLFGJ5Ng4/m3lOd0MnDDV9Bi7Vh4bb225t7Ku0Spzj/WPfDK/iOASy54
        UILBy3ADUpVhRLTvDUmtR0H4IjHZh/eg==;
Received: from mac by deneb.mcrowe.com with local (Exim 4.94.2)
        (envelope-from <mac@mcrowe.com>)
        id 1mzzpg-0005z8-Ic; Wed, 22 Dec 2021 11:30:56 +0000
From:   Mike Crowe <mac@mcrowe.com>
To:     linux-kernel@vger.kernel.org
Cc:     Mike Crowe <mac@mcrowe.com>, Arnd Bergmann <arnd@arndb.de>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        stable@vger.kernel.org
Subject: [PATCH] kmsg: Return -ESPIPE rather than EBADF from llseek(SEEK_CUR)
Date:   Wed, 22 Dec 2021 11:30:54 +0000
Message-Id: <20211222113054.673553-1-mac@mcrowe.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfLvcgtUp4NIZBFCF1+GF1wG43aXAbDjAGEKeTLXmdbemKgtdOZd76lV+Ojlqe39/0INfEvqz7NlWCXD4aMry8zgmAvan4lWK9pmGI3lp/ZLkcQW8hPC9
 SQ0s5EPHyRQQAiOqEkFC0TZD6nazZ0pkNfRqpPUmASfIcGIldzt1UL5NZdjkFiKzdDgGxHeiZKghMw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

glibc's dprintf implementation tries to determine the current file position
by calling lseek(fd, 0, SEEK_CUR). Unfortunately it treats receiving EINVAL
as an error. See https://sourceware.org/bugzilla/show_bug.cgi?id=17830

From what I can tell prior to Kay Sievers printk record commit
e11fea92e13fb91c50bacca799a6131c81929986, calling lseek(fd, 0, SEEK_CUR)
with such a file descriptor would not return an error.

Prior to Kay's change, Arnd Bergmann's commit
6038f373a3dc1f1c26496e60b6c40b164716f07e seemed to go to some lengths to
preserve the successful return code rather than returning (the perhaps more
logical) -ESPIPE.

glibc is happy with either a successful return or -ESPIPE. It seems that
the consensus is to return -ESPIPE in this situation.

Alexander Sverdlin supplied this test case:
--8<--
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <fcntl.h>

 int main(int argc, char **argv)
 {
         return dprintf(open("/dev/kmsg", O_WRONLY), "\n") < 0;
 }
-->8--

A variant of this fix was originally proposed in 2015[1]. The problem
was woken up again in 2019[2] and this fix was posted[3] shortly
afterwards, but it did not land. This version has been rebased to fix
trivial conflicts.

[1] https://lkml.org/lkml/2015/1/15/575
[2] https://lkml.org/lkml/2019/3/21/172
[3] https://lkml.org/lkml/2019/3/24/279

Signed-off-by: Mike Crowe <mac@mcrowe.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Tested-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Cc: stable@vger.kernel.org
Fixes: e11fea92e1 ("kmsg: export printk records to the /dev/kmsg interface")
---
 kernel/printk/printk.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 57b132b658e1..6013ea991378 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -803,6 +803,11 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 		/* after the last record */
 		atomic64_set(&user->seq, prb_next_seq(prb));
 		break;
+	case SEEK_CUR:
+		/* For compatibility with userspace expecting SEEK_CUR
+		 * to not yield EINVAL. */
+		ret = -ESPIPE;
+		break;
 	default:
 		ret = -EINVAL;
 	}
-- 
2.30.2

