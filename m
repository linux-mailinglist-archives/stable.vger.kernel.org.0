Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55716582B14
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbiG0Q1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236617AbiG0Q1B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:27:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3915E4D80E;
        Wed, 27 Jul 2022 09:23:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5A9D1B821B8;
        Wed, 27 Jul 2022 16:23:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C6EC433D6;
        Wed, 27 Jul 2022 16:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939032;
        bh=OeMS+8TS1at1GfNIVHLa7scKJS0eeyeXOoc2KuysgRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrFpfMWH+Oj9PNkwIHs494vxmmGaCSmpUmBwCrbo/DgJyiUeV7xU739n1qBMRbUYw
         kcCU+H5WMAWbdobFjZY3SB5cOPtIRhll7VxC/xu4KAuoCWWmAjgJ4bH1LkQRq6eOn9
         JjHNdTLlgJYusWsep90+2rx0BWvDUovpB0I57pGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 4.14 27/37] Bluetooth: Fix bt_skb_sendmmsg not allocating partial chunks
Date:   Wed, 27 Jul 2022 18:10:53 +0200
Message-Id: <20220727161001.937328879@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161000.822869853@linuxfoundation.org>
References: <20220727161000.822869853@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 29fb608396d6a62c1b85acc421ad7a4399085b9f upstream.

Since bt_skb_sendmmsg can be used with the likes of SOCK_STREAM it
shall return the partial chunks it could allocate instead of freeing
everything as otherwise it can cause problems like bellow.

Fixes: 81be03e026dc ("Bluetooth: RFCOMM: Replace use of memcpy_from_msg with bt_skb_sendmmsg")
Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://lore.kernel.org/r/d7206e12-1b99-c3be-84f4-df22af427ef5@molgen.mpg.de
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215594
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Tested-by: Paul Menzel <pmenzel@molgen.mpg.de> (Nokia N9 (MeeGo/Harmattan)
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/bluetooth.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -420,8 +420,7 @@ static inline struct sk_buff *bt_skb_sen
 
 		tmp = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
 		if (IS_ERR(tmp)) {
-			kfree_skb(skb);
-			return tmp;
+			return skb;
 		}
 
 		len -= tmp->len;


