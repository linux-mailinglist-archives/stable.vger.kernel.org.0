Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E644E59D559
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243189AbiHWIY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243222AbiHWIXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:23:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D602716;
        Tue, 23 Aug 2022 01:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1087AB81C3D;
        Tue, 23 Aug 2022 08:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEEDC433C1;
        Tue, 23 Aug 2022 08:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242372;
        bh=t9EAyhTB6WaOrs6vp1R5UqNAeAWhZro/XkIxBgAHZao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GM8m7WY0eBOAlOG5rnFv1r/zlR2EWfR4XyXsJkX2L9HaOfNTZXLlYMb0QtPGFsqds
         WwC2ahRSSPFV651EfBOCju6/mBD0zBu6NIijCTgAMPk6q5nSrIPaFi3jwbPRrQJHSR
         fdwKUzZjxJFTdo7f4hzUcH90SYpDGIWiz1NaLvnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 4.9 062/101] Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression
Date:   Tue, 23 Aug 2022 10:03:35 +0200
Message-Id: <20220823080036.947499547@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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
@@ -1804,11 +1804,11 @@ static struct l2cap_chan *l2cap_global_c
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
 
@@ -1827,11 +1827,10 @@ static struct l2cap_chan *l2cap_global_c
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


