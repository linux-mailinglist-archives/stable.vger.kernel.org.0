Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38A31B684D
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgDWXOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:14:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49910 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728466AbgDWXGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:49 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvV-0004id-C1; Fri, 24 Apr 2020 00:06:37 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvS-00E6s1-QP; Fri, 24 Apr 2020 00:06:34 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jens Axboe" <axboe@fb.com>, "Jan Kara" <jack@suse.cz>,
        "Tejun Heo" <tj@kernel.org>,
        "Bart Van Assche" <bart.vanassche@sandisk.com>
Date:   Fri, 24 Apr 2020 00:06:24 +0100
Message-ID: <lsq.1587683028.385675408@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 157/245] kobject: Export kobject_get_unless_zero()
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

From: Jan Kara <jack@suse.cz>

commit c70c176ff8c3ff0ac6ef9a831cd591ea9a66bd1a upstream.

Make the function available for outside use and fortify it against NULL
kobject.

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/kobject.h | 2 ++
 lib/kobject.c           | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -107,6 +107,8 @@ extern int __must_check kobject_rename(s
 extern int __must_check kobject_move(struct kobject *, struct kobject *);
 
 extern struct kobject *kobject_get(struct kobject *kobj);
+extern struct kobject * __must_check kobject_get_unless_zero(
+						struct kobject *kobj);
 extern void kobject_put(struct kobject *kobj);
 
 extern const void *kobject_namespace(struct kobject *kobj);
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -581,12 +581,15 @@ struct kobject *kobject_get(struct kobje
 	return kobj;
 }
 
-static struct kobject * __must_check kobject_get_unless_zero(struct kobject *kobj)
+struct kobject * __must_check kobject_get_unless_zero(struct kobject *kobj)
 {
+	if (!kobj)
+		return NULL;
 	if (!kref_get_unless_zero(&kobj->kref))
 		kobj = NULL;
 	return kobj;
 }
+EXPORT_SYMBOL(kobject_get_unless_zero);
 
 /*
  * kobject_cleanup - free kobject resources.

