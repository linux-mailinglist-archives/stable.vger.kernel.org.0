Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3115AB051
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbiIBMwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237792AbiIBMvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:51:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB918E340E;
        Fri,  2 Sep 2022 05:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C074F6211D;
        Fri,  2 Sep 2022 12:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B770DC433C1;
        Fri,  2 Sep 2022 12:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121754;
        bh=mHzs6d5hxU1i6+1Mo1KuGNkiU33DBxG/VTXMU/Qg5zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LtG509XWJPdOKuWPczs28bXumTt83PlwTGHtTgMS5SK+ha3Hvt91lFj3EXz7pqluJ
         I8uquRWBDBraAeNSSW4zziFE5JTAqKgyvnssehWLiE0XoD9ler9GjvCndz4nCklnnt
         PqBFNs759PlkrOCEroRxLUwr5WCt9iyCDaQm74WY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4 53/77] Bluetooth: L2CAP: Fix build errors in some archs
Date:   Fri,  2 Sep 2022 14:19:02 +0200
Message-Id: <20220902121405.425755290@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121403.569927325@linuxfoundation.org>
References: <20220902121403.569927325@linuxfoundation.org>
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

commit b840304fb46cdf7012722f456bce06f151b3e81b upstream.

This attempts to fix the follow errors:

In function 'memcmp',
    inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:347:9,
    inlined from 'l2cap_global_chan_by_psm' at
    net/bluetooth/l2cap_core.c:2003:15:
./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp'
specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
   44 | #define __underlying_memcmp     __builtin_memcmp
      |                                 ^
./include/linux/fortify-string.h:420:16: note: in expansion of macro
'__underlying_memcmp'
  420 |         return __underlying_memcmp(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~
In function 'memcmp',
    inlined from 'bacmp' at ./include/net/bluetooth/bluetooth.h:347:9,
    inlined from 'l2cap_global_chan_by_psm' at
    net/bluetooth/l2cap_core.c:2004:15:
./include/linux/fortify-string.h:44:33: error: '__builtin_memcmp'
specified bound 6 exceeds source size 0 [-Werror=stringop-overread]
   44 | #define __underlying_memcmp     __builtin_memcmp
      |                                 ^
./include/linux/fortify-string.h:420:16: note: in expansion of macro
'__underlying_memcmp'
  420 |         return __underlying_memcmp(p, q, size);
      |                ^~~~~~~~~~~~~~~~~~~

Fixes: 332f1795ca20 ("Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm regression")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1835,11 +1835,11 @@ static struct l2cap_chan *l2cap_global_c
 			src_match = !bacmp(&c->src, src);
 			dst_match = !bacmp(&c->dst, dst);
 			if (src_match && dst_match) {
-				c = l2cap_chan_hold_unless_zero(c);
-				if (c) {
-					read_unlock(&chan_list_lock);
-					return c;
-				}
+				if (!l2cap_chan_hold_unless_zero(c))
+					continue;
+
+				read_unlock(&chan_list_lock);
+				return c;
 			}
 
 			/* Closest match */


