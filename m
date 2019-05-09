Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBB3C18B5F
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 16:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfEIONK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 10:13:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46916 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbfEIONK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 May 2019 10:13:10 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-00012A-Nf; Thu, 09 May 2019 15:13:08 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hOjnI-0006MU-Fx; Thu, 09 May 2019 15:13:08 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Date:   Thu, 09 May 2019 15:08:17 +0100
Message-ID: <lsq.1557410897.804323871@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 09/10] timer/debug: Change /proc/timer_stats from
 0644 to 0600
In-Reply-To: <lsq.1557410896.171359878@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.67-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

The timer_stats facility should filter and translate PIDs if opened
from a non-initial PID namespace, to avoid leaking information about
the wider system.  It should also not show kernel virtual addresses.
Unfortunately it has now been removed upstream (as redundant)
instead of being fixed.

For stable, fix the leak by restricting access to root only.  A
similar change was already made for the /proc/timer_list file.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -417,7 +417,7 @@ static int __init init_tstats_procfs(voi
 {
 	struct proc_dir_entry *pe;
 
-	pe = proc_create("timer_stats", 0644, NULL, &tstats_fops);
+	pe = proc_create("timer_stats", 0600, NULL, &tstats_fops);
 	if (!pe)
 		return -ENOMEM;
 	return 0;

