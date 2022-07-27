Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52623582C81
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbiG0QrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240297AbiG0QqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:46:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AA3460525;
        Wed, 27 Jul 2022 09:31:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05B4D61A39;
        Wed, 27 Jul 2022 16:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAFEC433C1;
        Wed, 27 Jul 2022 16:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939500;
        bh=2Vlo7M8NSNs8mY3VMCsSnVhil6Q8QE9JRpDlIGdKv1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgEeIzNPyBlDUUnEirXGbDJs6pS7FMv0XPS+o7lim3SOCPDmFgx1HChKHHBkPnOfF
         jQX+zRcPCMfx2+aGKqqRme61+iEJiZvtIRT7eKSsC9InQWGAOlDGMf7HTgXjk67KmM
         zx7n0Wr5JdcOVRBz4tWMbywIYFeSyUNpGmZ603ak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hillf Danton <hdanton@sina.com>,
        =?UTF-8?q?=E4=B8=80=E5=8F=AA=E7=8B=97?= <chennbnbnb@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 5.4 84/87] tty: extract tty_flip_buffer_commit() from tty_flip_buffer_push()
Date:   Wed, 27 Jul 2022 18:11:17 +0200
Message-Id: <20220727161012.464035141@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 716b10580283fda66f2b88140e3964f8a7f9da89 upstream.

We will need this new helper in the next patch.

Cc: Hillf Danton <hdanton@sina.com>
Cc: 一只狗 <chennbnbnb@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20220707082558.9250-1-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_buffer.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -523,6 +523,15 @@ static void flush_to_ldisc(struct work_s
 
 }
 
+static inline void tty_flip_buffer_commit(struct tty_buffer *tail)
+{
+	/*
+	 * Paired w/ acquire in flush_to_ldisc(); ensures flush_to_ldisc() sees
+	 * buffer data.
+	 */
+	smp_store_release(&tail->commit, tail->used);
+}
+
 /**
  *	tty_flip_buffer_push	-	terminal
  *	@port: tty port to push
@@ -538,11 +547,7 @@ void tty_flip_buffer_push(struct tty_por
 {
 	struct tty_bufhead *buf = &port->buf;
 
-	/*
-	 * Paired w/ acquire in flush_to_ldisc(); ensures flush_to_ldisc() sees
-	 * buffer data.
-	 */
-	smp_store_release(&buf->tail->commit, buf->tail->used);
+	tty_flip_buffer_commit(buf->tail);
 	queue_work(system_unbound_wq, &buf->work);
 }
 EXPORT_SYMBOL(tty_flip_buffer_push);


