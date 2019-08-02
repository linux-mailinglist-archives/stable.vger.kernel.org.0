Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B73927F168
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391378AbfHBJdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391425AbfHBJdt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:33:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C132A21773;
        Fri,  2 Aug 2019 09:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738428;
        bh=TmMe6w4uJikcmWxDy9aha4me4xYkKfIJtTY9M5JoQRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HmGWduCfpuNb5De1hWaINbPTEwhljVXRc2/pj4c6LEHAgiFf1wbUMdLI/i9T90wSR
         Qm4vs1cNFC5NFKFBj75cmkGj6aQtSHBhUDVub3Ryka2+lpDLuwMatXnmwynqeLsFEy
         KEtNxtWYc0HsVKp3oNaE4fh4u/jh7Y37ydL0IgWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Jens Axboe <axboe@fb.com>
Subject: [PATCH 4.4 100/158] elevator: fix truncation of icq_cache_name
Date:   Fri,  2 Aug 2019 11:28:41 +0200
Message-Id: <20190802092224.860632666@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 9bd2bbc01d17ddd567cc0f81f77fe1163e497462 upstream.

gcc 7.1 reports the following warning:

    block/elevator.c: In function ‘elv_register’:
    block/elevator.c:898:5: warning: ‘snprintf’ output may be truncated before the last format character [-Wformat-truncation=]
         "%s_io_cq", e->elevator_name);
         ^~~~~~~~~~
    block/elevator.c:897:3: note: ‘snprintf’ output between 7 and 22 bytes into a destination of size 21
       snprintf(e->icq_cache_name, sizeof(e->icq_cache_name),
       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         "%s_io_cq", e->elevator_name);
         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The bug is that the name of the icq_cache is 6 characters longer than
the elevator name, but only ELV_NAME_MAX + 5 characters were reserved
for it --- so in the case of a maximum-length elevator name, the 'q'
character in "_io_cq" would be truncated by snprintf().  Fix it by
reserving ELV_NAME_MAX + 6 characters instead.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/elevator.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -97,7 +97,7 @@ struct elevator_type
 	struct module *elevator_owner;
 
 	/* managed by elevator core */
-	char icq_cache_name[ELV_NAME_MAX + 5];	/* elvname + "_io_cq" */
+	char icq_cache_name[ELV_NAME_MAX + 6];	/* elvname + "_io_cq" */
 	struct list_head list;
 };
 


