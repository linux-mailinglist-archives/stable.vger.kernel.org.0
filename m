Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637B519283
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfEISpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727221AbfEISpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:45:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C5D7217F5;
        Thu,  9 May 2019 18:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427505;
        bh=0TjL81IqbnAkiwaGUHAMMPYNKAiIgC8Ggtg0x3pthj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7exAsSS9Fu9G0UggFJ0Cf7dJse9liUTOD5FMX5cWZi+RjuERf5dWxuONfc+dkBp9
         ExV0fW4jKUsaFVX55Cgm08BE2gibplL5vhg1hDncJC/+gd5gN2keadaHeysd3efLjo
         vA3LAwoyIYEGlQGNHqLhi5btNSJ8dih68q6X4NnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 28/28] timer/debug: Change /proc/timer_stats from 0644 to 0600
Date:   Thu,  9 May 2019 20:42:20 +0200
Message-Id: <20190509181256.196790585@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181247.647767531@linuxfoundation.org>
References: <20190509181247.647767531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

The timer_stats facility should filter and translate PIDs if opened
from a non-initial PID namespace, to avoid leaking information about
the wider system.  It should also not show kernel virtual addresses.
Unfortunately it has now been removed upstream (as redundant)
instead of being fixed.

For stable, fix the leak by restricting access to root only.  A
similar change was already made for the /proc/timer_list file.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/timer_stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


