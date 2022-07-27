Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A42582C7D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240267AbiG0QqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240292AbiG0Qp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:45:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318455F9B8;
        Wed, 27 Jul 2022 09:31:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7D4D61A39;
        Wed, 27 Jul 2022 16:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7D0C433D6;
        Wed, 27 Jul 2022 16:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939489;
        bh=TX+Sdx7vNb92kNhrkYvV7Qs/pncP26B1lxcQyV/riF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wpc5UJCw3JgZl678cP6ICwNIUiLNcP5IlhW+YtpW8zvr8L6iTksLKCMoM77MwPrDH
         EBzYg4k8g8mNtCoQYfzKTHpPTTCs1SufTfEVaow8yetEDAwKaIx/VrAF5xVFN07+FJ
         z6NFIujv/tbDvhbrtIJp48ag7s4EGA2Dvkp/b3KU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.4 80/87] Bluetooth: Fix bt_skb_sendmmsg not allocating partial chunks
Date:   Wed, 27 Jul 2022 18:11:13 +0200
Message-Id: <20220727161012.318635744@linuxfoundation.org>
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
@@ -423,8 +423,7 @@ static inline struct sk_buff *bt_skb_sen
 
 		tmp = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
 		if (IS_ERR(tmp)) {
-			kfree_skb(skb);
-			return tmp;
+			return skb;
 		}
 
 		len -= tmp->len;


