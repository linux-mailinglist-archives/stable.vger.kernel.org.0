Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA56660B2A3
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbiJXQub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235140AbiJXQtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:49:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4888F967;
        Mon, 24 Oct 2022 08:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7080B81722;
        Mon, 24 Oct 2022 12:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E91C433B5;
        Mon, 24 Oct 2022 12:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616143;
        bh=OjZ0L2KyAgkZPt75DZB7YHk9PytepHMPjogVsy2mw0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EItp0bKSV2khg1Fsxc2zRjsX0xz0z7DiAoLgA9Fs1VS1nczOFSdgBNmCSHHmRZfxi
         htM+5cGbNWqJghQPJcYrmSWdmTHxh2jFBlnRFgWkQmeYNxDKXcFtQPqA3zJPc4jXNi
         NRyje8jV0env7w9y+8CDw/Rr71qnXz9Sk9y70T/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 517/530] net: ieee802154: return -EINVAL for unknown addr type
Date:   Mon, 24 Oct 2022 13:34:21 +0200
Message-Id: <20221024113108.408349468@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit 30393181fdbc1608cc683b4ee99dcce05ffcc8c7 upstream.

This patch adds handling to return -EINVAL for an unknown addr type. The
current behaviour is to return 0 as successful but the size of an
unknown addr type is not defined and should return an error like -EINVAL.

Fixes: 94160108a70c ("net/ieee802154: fix uninit value bug in dgram_sendmsg")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ieee802154_netdev.h |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -185,21 +185,27 @@ static inline int
 ieee802154_sockaddr_check_size(struct sockaddr_ieee802154 *daddr, int len)
 {
 	struct ieee802154_addr_sa *sa;
+	int ret = 0;
 
 	sa = &daddr->addr;
 	if (len < IEEE802154_MIN_NAMELEN)
 		return -EINVAL;
 	switch (sa->addr_type) {
+	case IEEE802154_ADDR_NONE:
+		break;
 	case IEEE802154_ADDR_SHORT:
 		if (len < IEEE802154_NAMELEN_SHORT)
-			return -EINVAL;
+			ret = -EINVAL;
 		break;
 	case IEEE802154_ADDR_LONG:
 		if (len < IEEE802154_NAMELEN_LONG)
-			return -EINVAL;
+			ret = -EINVAL;
+		break;
+	default:
+		ret = -EINVAL;
 		break;
 	}
-	return 0;
+	return ret;
 }
 
 static inline void ieee802154_addr_from_sa(struct ieee802154_addr *a,


