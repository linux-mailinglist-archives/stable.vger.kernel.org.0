Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E1748E60B
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240233AbiANIW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240318AbiANIVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:21:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E0EC06175A;
        Fri, 14 Jan 2022 00:21:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BA3261E45;
        Fri, 14 Jan 2022 08:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D5BC36AEC;
        Fri, 14 Jan 2022 08:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148487;
        bh=PWIEp0SwuyloDQYdOwsvlH39NhqCKMKAkhMQuOyesRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLxuV/vUEuIMDN/sSpILI2/z86C6TpxH74xp+bLzYI5OI981qQLMs7JzLq+UXZ4fB
         dlVlV+RCULhQTLc2fL21T2harWNNT+/7o9pxqJqUUuqZYM2cWLcQt2u/5v4gmE9Jvj
         zZ9N1MBARpJPVePwG70NuBWj0eJP/My+U9uvOJ2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 32/41] can: isotp: convert struct tpcon::{idx,len} to unsigned int
Date:   Fri, 14 Jan 2022 09:16:32 +0100
Message-Id: <20220114081546.236665396@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081545.158363487@linuxfoundation.org>
References: <20220114081545.158363487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 5f33a09e769a9da0482f20a6770a342842443776 upstream.

In isotp_rcv_ff() 32 bit of data received over the network is assigned
to struct tpcon::len. Later in that function the length is checked for
the maximal supported length against MAX_MSG_LENGTH.

As struct tpcon::len is an "int" this check does not work, if the
provided length overflows the "int".

Later on struct tpcon::idx is compared against struct tpcon::len.

To fix this problem this patch converts both struct tpcon::{idx,len}
to unsigned int.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://lore.kernel.org/all/20220105132429.1170627-1-mkl@pengutronix.de
Cc: stable@vger.kernel.org
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Reported-by: syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -119,8 +119,8 @@ enum {
 };
 
 struct tpcon {
-	int idx;
-	int len;
+	unsigned int idx;
+	unsigned int len;
 	u32 state;
 	u8 bs;
 	u8 sn;


