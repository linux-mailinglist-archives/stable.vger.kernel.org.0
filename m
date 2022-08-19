Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4D859A453
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354418AbiHSQyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354421AbiHSQxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:53:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3E931DED;
        Fri, 19 Aug 2022 09:15:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3DEC4CE26AC;
        Fri, 19 Aug 2022 16:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D11EC433C1;
        Fri, 19 Aug 2022 16:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925609;
        bh=3CxRal1Wz7dBYYhtwSv0Lq8UgsO8mOKXA/8E1KJSgzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNYe5B+99BccbWn/3SSx+uUspZpdoQ9ARa7pYGjyX8RO/SXphcRXWpkP1CwnwM1Gu
         fD6OAPwDtc2KgVvkAYs69y/PVGEKFD1PyMMBMy2yJAj0CyoBP9HbrP29OkjeWj4dBI
         JfLARyOKsL/DF+65f+JruKK1RckjpEZOHkkjr02Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 537/545] Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression
Date:   Fri, 19 Aug 2022 17:45:07 +0200
Message-Id: <20220819153853.617121540@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 332f1795ca202489c665a75e62e18ff6284de077 upstream.

The patch d0be8347c623: "Bluetooth: L2CAP: Fix use-after-free caused
by l2cap_chan_put" from Jul 21, 2022, leads to the following Smatch
static checker warning:

        net/bluetooth/l2cap_core.c:1977 l2cap_global_chan_by_psm()
        error: we previously assumed 'c' could be null (see line 1996)

Fixes: d0be8347c623 ("Bluetooth: L2CAP: Fix use-after-free caused by l2cap_chan_put")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1966,11 +1966,11 @@ static struct l2cap_chan *l2cap_global_c
 						   bdaddr_t *dst,
 						   u8 link_type)
 {
-	struct l2cap_chan *c, *c1 = NULL;
+	struct l2cap_chan *c, *tmp, *c1 = NULL;
 
 	read_lock(&chan_list_lock);
 
-	list_for_each_entry(c, &chan_list, global_l) {
+	list_for_each_entry_safe(c, tmp, &chan_list, global_l) {
 		if (state && c->state != state)
 			continue;
 
@@ -1989,11 +1989,10 @@ static struct l2cap_chan *l2cap_global_c
 			dst_match = !bacmp(&c->dst, dst);
 			if (src_match && dst_match) {
 				c = l2cap_chan_hold_unless_zero(c);
-				if (!c)
-					continue;
-
-				read_unlock(&chan_list_lock);
-				return c;
+				if (c) {
+					read_unlock(&chan_list_lock);
+					return c;
+				}
 			}
 
 			/* Closest match */


