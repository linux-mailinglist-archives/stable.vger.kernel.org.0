Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E34C48E65E
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiANI0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:26:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240908AbiANIYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:24:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D29AC061779;
        Fri, 14 Jan 2022 00:23:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05BD9B8243F;
        Fri, 14 Jan 2022 08:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34585C36AE9;
        Fri, 14 Jan 2022 08:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148595;
        bh=PWIEp0SwuyloDQYdOwsvlH39NhqCKMKAkhMQuOyesRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucSli0+lnekfM3EnwwOnk4M/IGSCOJ5ljyWccsrVWRX/iFW8dCPpGY39ywFH88BeY
         /kaTQIOc5WkWNDjoMmtY6yiV9gCyEAftOUcTVkcmGxWTrijXjZFAPI8BRwmRk4zXZT
         YtQRSUS5WblOd0FhN17vyOIqwNeyYhbtHecYEBe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.16 28/37] can: isotp: convert struct tpcon::{idx,len} to unsigned int
Date:   Fri, 14 Jan 2022 09:16:42 +0100
Message-Id: <20220114081545.771745068@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
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


