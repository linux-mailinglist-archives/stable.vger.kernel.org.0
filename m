Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC126B41F
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727269AbgIOXRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:17:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727232AbgIOOj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:39:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 639F1224D1;
        Tue, 15 Sep 2020 14:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180159;
        bh=fDQMlWhRb6MDEGufmtaflUFVgQoXCGhC2fKN90BHfy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLnYWWTLTas0HTIZAwTxQ+4aM/rdta2NlhSxWYrfMZf+59ToU8BAA6HsIKl7mz5wh
         GP+0c65YhDlp208TI0bHxJrCtg4goOrr2mfgN4BAL8nRs+PZLAqHkAUWrXqCiZijK3
         tQsHXVdubQ/k+Jukva87ekZ6eaWokFZI+biAHxT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Qu Wenruo <wqu@suse.com>
Subject: [PATCH 5.8 132/177] kobject: Restore old behaviour of kobject_del(NULL)
Date:   Tue, 15 Sep 2020 16:13:23 +0200
Message-Id: <20200915140659.978304138@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 40b8b826a6998639dd1c26f0e127f18371e1058d upstream.

The commit 079ad2fb4bf9 ("kobject: Avoid premature parent object freeing in
kobject_cleanup()") inadvertently dropped a possibility to call kobject_del()
with NULL pointer. Restore the old behaviour.

Fixes: 079ad2fb4bf9 ("kobject: Avoid premature parent object freeing in kobject_cleanup()")
Cc: stable <stable@vger.kernel.org>
Reported-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Link: https://lore.kernel.org/r/20200803082706.65347-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/kobject.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -637,8 +637,12 @@ static void __kobject_del(struct kobject
  */
 void kobject_del(struct kobject *kobj)
 {
-	struct kobject *parent = kobj->parent;
+	struct kobject *parent;
 
+	if (!kobj)
+		return;
+
+	parent = kobj->parent;
 	__kobject_del(kobj);
 	kobject_put(parent);
 }


