Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC1599E36
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389876AbfHVRWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389950AbfHVRWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:20 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDC37233FC;
        Thu, 22 Aug 2019 17:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494540;
        bh=Mh1/bHNMSZxjSXWuCew94BhzmXBwks+dNsCioYr3Aqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yK6iTG5nCEwS8x9IKn/ei8i/YhnlkaSJCIuaqHXX45r8j+WRkeuNMjgKReC9d07Qd
         6x7PgEgmILwDmpp9zQhrVwjfdcB/fNbHzievtc+SXX81T2FXinszh3BeN//br52vPl
         MBkA4sWUGSiidamOo+8hbZD+2NXnQQoNt0HWY+ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 02/78] sound: fix a memory leak bug
Date:   Thu, 22 Aug 2019 10:18:06 -0700
Message-Id: <20190822171832.115851286@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
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
@@ -287,7 +287,8 @@ retry:
 				goto retry;
 			}
 			spin_unlock(&sound_loader_lock);
-			return -EBUSY;
+			r = -EBUSY;
+			goto fail;
 		}
 	}
 


