Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182054ABD22
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiBGLjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386114AbiBGLdk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:33:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21BFEC043188;
        Mon,  7 Feb 2022 03:33:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70E7E60B20;
        Mon,  7 Feb 2022 11:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78667C004E1;
        Mon,  7 Feb 2022 11:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233618;
        bh=KWI6vSg9iJAy0sZw7ylDuPKoHk9LZwGvR0dTqATAMdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4qt7SZjbl8vHaAcNHvLu/sZpw4gsGAh+WATpV8aonEq9m/DlWq7VP9L2B5Klper1
         UUtgZoFYF2qoVcO3gC0JyUJ5CWwdxaByXgrpbB7tjmXOyi0s8ykEFaeVTezPO4CTWI
         lhdJvW8WAM2X2sR63Oqz4qqZXdUnFzlrmBN9Ovuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 5.16 069/126] net: ieee802154: Return meaningful error codes from the netlink helpers
Date:   Mon,  7 Feb 2022 12:06:40 +0100
Message-Id: <20220207103806.498790321@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 79c37ca73a6e9a33f7b2b7783ba6af07a448c8a9 upstream.

Returning -1 does not indicate anything useful.

Use a standard and meaningful error code instead.

Fixes: a26c5fd7622d ("nl802154: add support for security layer")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20220125121426.848337-6-miquel.raynal@bootlin.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ieee802154/nl802154.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1441,7 +1441,7 @@ static int nl802154_send_key(struct sk_b
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
@@ -1634,7 +1634,7 @@ static int nl802154_send_device(struct s
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
@@ -1812,7 +1812,7 @@ static int nl802154_send_devkey(struct s
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;
@@ -1988,7 +1988,7 @@ static int nl802154_send_seclevel(struct
 
 	hdr = nl802154hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
-		return -1;
+		return -ENOBUFS;
 
 	if (nla_put_u32(msg, NL802154_ATTR_IFINDEX, dev->ifindex))
 		goto nla_put_failure;


