Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC77BF864
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfD3LkE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728239AbfD3LkD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:40:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9903721670;
        Tue, 30 Apr 2019 11:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624403;
        bh=M2A9iqhs/KVUvfAoeL7RgXhLq80Db758QtOaHvcXZro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAGr0c0Fr4iGAAifOB61FRkcIWMtrb5r8DfY44zd3FKuIqwIzXegEajE7PrbMRItH
         J6tAZerXI9y1CiCfGSjCdSQ+v8qeG2ZvfhFFdaQ5MQtIvnYfFAM5Df8VJ07Hq5+L5K
         qpw1SqPpA3516oGe93V1i/me1RootfrOKfWOlKsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+45474c076a4927533d2e@syzkaller.appspotmail.com,
        Ben Hutchings <ben@decadent.org.uk>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 21/41] slip: make slhc_free() silently accept an error pointer
Date:   Tue, 30 Apr 2019 13:38:32 +0200
Message-Id: <20190430113530.104386858@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113524.451237916@linuxfoundation.org>
References: <20190430113524.451237916@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit baf76f0c58aec435a3a864075b8f6d8ee5d1f17e upstream.

This way, slhc_free() accepts what slhc_init() returns, whether that is
an error or not.

In particular, the pattern in sl_alloc_bufs() is

        slcomp = slhc_init(16, 16);
        ...
        slhc_free(slcomp);

for the error handling path, and rather than complicate that code, just
make it ok to always free what was returned by the init function.

That's what the code used to do before commit 4ab42d78e37a ("ppp, slip:
Validate VJ compression slot parameters completely") when slhc_init()
just returned NULL for the error case, with no actual indication of the
details of the error.

Reported-by: syzbot+45474c076a4927533d2e@syzkaller.appspotmail.com
Fixes: 4ab42d78e37a ("ppp, slip: Validate VJ compression slot parameters completely")
Acked-by: Ben Hutchings <ben@decadent.org.uk>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/slip/slhc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/slip/slhc.c
+++ b/drivers/net/slip/slhc.c
@@ -153,7 +153,7 @@ out_fail:
 void
 slhc_free(struct slcompress *comp)
 {
-	if ( comp == NULLSLCOMPR )
+	if ( IS_ERR_OR_NULL(comp) )
 		return;
 
 	if ( comp->tstate != NULLSLSTATE )


