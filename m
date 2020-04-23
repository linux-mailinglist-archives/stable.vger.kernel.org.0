Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790671B6969
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgDWXX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:23:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48476 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728181AbgDWXGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:31 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvL-0004bg-Ec; Fri, 24 Apr 2020 00:06:27 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvK-00E6ih-35; Fri, 24 Apr 2020 00:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mike Snitzer" <snitzer@redhat.com>,
        "Wei Yongjun" <weiyj.lk@gmail.com>
Date:   Fri, 24 Apr 2020 00:04:44 +0100
Message-ID: <lsq.1587683028.17766012@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 057/245] dm flakey: return -EINVAL on interval bounds
 error in flakey_ctr()
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <weiyj.lk@gmail.com>

commit bff7e067ee518f9ed7e1cbc63e4c9e01670d0b71 upstream.

Fix to return error code -EINVAL instead of 0, as is done elsewhere in
this function.

Fixes: e80d1c805a3b ("dm: do not override error code returned from dm_get_device()")
Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-flakey.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -200,11 +200,13 @@ static int flakey_ctr(struct dm_target *
 
 	if (!(fc->up_interval + fc->down_interval)) {
 		ti->error = "Total (up + down) interval is zero";
+		r = -EINVAL;
 		goto bad;
 	}
 
 	if (fc->up_interval + fc->down_interval < fc->up_interval) {
 		ti->error = "Interval overflow";
+		r = -EINVAL;
 		goto bad;
 	}
 

