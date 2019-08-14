Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24B458D994
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbfHNRJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:09:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730391AbfHNRJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:09:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DA982084D;
        Wed, 14 Aug 2019 17:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802587;
        bh=Bdw0sl1aWne9A7zIwsKJUivc8ei5zDfDpTfnzUxJBYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzcobyzkANO3Kk4zLs8ygxP4qY/1mWorEWzLUu8voTxdFdi7SWLwSSzXlqmVevUFo
         8u9WQgp5U1d43RLSZruJr4QyZXaaiJrk6S7VBYa3ARGDLqWXeG7xrCnk8yKhzQ9NBt
         3jZfWuP4ZY//h3dumNJhg6m7jjiGnjUXfMkHg6o4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 10/91] sound: fix a memory leak bug
Date:   Wed, 14 Aug 2019 19:00:33 +0200
Message-Id: <20190814165750.046750688@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

commit c7cd7c748a3250ca33509f9235efab9c803aca09 upstream.

In sound_insert_unit(), the controlling structure 's' is allocated through
kmalloc(). Then it is added to the sound driver list by invoking
__sound_insert_unit(). Later on, if __register_chrdev() fails, 's' is
removed from the list through __sound_remove_unit(). If 'index' is not less
than 0, -EBUSY is returned to indicate the error. However, 's' is not
deallocated on this execution path, leading to a memory leak bug.

To fix the above issue, free 's' before -EBUSY is returned.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/sound_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -280,7 +280,8 @@ retry:
 				goto retry;
 			}
 			spin_unlock(&sound_loader_lock);
-			return -EBUSY;
+			r = -EBUSY;
+			goto fail;
 		}
 	}
 


