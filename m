Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2333826B5F3
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbgIOXzA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727054AbgIOObc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:31:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D57A22272;
        Tue, 15 Sep 2020 14:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179803;
        bh=ifnurhpycPLGZeFJBQdmcEfPl/nA6hUm+yrAbyQdj3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QI0wI9nbvhNFHclCHyY4Wi4Qw0o6X3I562xWDtrNKjRNPJFuGZPjGairFkVvFWKKU
         6hK1OW9x9QuI8eNL2xPItI9i67VKoEiEpWJy/e0D1s+qzAvh+3IOh43ilNy2nksGyE
         LjY4HOJQb6Rq77rP+pd4MfUmbefQtFF+RqYN5tsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Qu Wenruo <wqu@suse.com>
Subject: [PATCH 5.4 095/132] kobject: Restore old behaviour of kobject_del(NULL)
Date:   Tue, 15 Sep 2020 16:13:17 +0200
Message-Id: <20200915140648.902771537@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
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
@@ -630,8 +630,12 @@ static void __kobject_del(struct kobject
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


