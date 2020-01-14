Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5196613A698
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731599AbgANKMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:48712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731650AbgANKMY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:12:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F86720678;
        Tue, 14 Jan 2020 10:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996744;
        bh=UnitqGIL4BayPEuh5GU0szWLUTtZK+Bm39PXTu23tIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjGR7VMIVAPasBgtl4BD7oxHU7XuI2MidihADS5y5pyXenubx8hCtTIScVLWIIIBo
         Bb/2S1sN6g+tKK1F1LkxojuaitYBmoGg8qbnDln88xSsFa8/oMSnbneL4OiylH3wqO
         6nqF0xasJCQd+FKgKgIXzv7WKkAQ7llU3BM4IccU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bart Van Assche <bart.vanassche@sandisk.com>,
        Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 4.4 01/28] kobject: Export kobject_get_unless_zero()
Date:   Tue, 14 Jan 2020 11:02:03 +0100
Message-Id: <20200114094337.305391779@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094336.845958665@linuxfoundation.org>
References: <20200114094336.845958665@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

---
 include/linux/kobject.h |    2 ++
 lib/kobject.c           |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -108,6 +108,8 @@ extern int __must_check kobject_rename(s
 extern int __must_check kobject_move(struct kobject *, struct kobject *);
 
 extern struct kobject *kobject_get(struct kobject *kobj);
+extern struct kobject * __must_check kobject_get_unless_zero(
+						struct kobject *kobj);
 extern void kobject_put(struct kobject *kobj);
 
 extern const void *kobject_namespace(struct kobject *kobj);
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -599,12 +599,15 @@ struct kobject *kobject_get(struct kobje
 }
 EXPORT_SYMBOL(kobject_get);
 
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


