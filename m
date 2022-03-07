Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED0B4CF5CD
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbiCGJbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238193AbiCGJ2z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773786D392;
        Mon,  7 Mar 2022 01:26:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C12686112D;
        Mon,  7 Mar 2022 09:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20D6C340F3;
        Mon,  7 Mar 2022 09:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645201;
        bh=pmVijEbEFKYoe7HTA58/hzwzXUNDi38IO2jZxZuY5IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2LMriel1xSz5Gmsypsi4Nk5GHh0ko/FQKzT67WGOSoyqTL7VE6jBXl9veG3efVPc
         eNtE0Xwu/qGP25qBkLyfaxDxVV/3HdGSmO/bdUscJAyZ7uZT9EvCtTJkCG2UGyMb6x
         1xKxY7Cqo35thQC1VvPbrgdMNPztE1i8VMX38+yY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.4 19/64] xfrm: fix the if_id check in changelink
Date:   Mon,  7 Mar 2022 10:18:52 +0100
Message-Id: <20220307091639.692354714@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antony Antony <antony.antony@secunet.com>

commit 6d0d95a1c2b07270870e7be16575c513c29af3f1 upstream.

if_id will be always 0, because it was not yet initialized.

Fixes: 8dce43919566 ("xfrm: interface with if_id 0 should return error")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xfrm/xfrm_interface.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -695,12 +695,12 @@ static int xfrmi_changelink(struct net_d
 	struct net *net = xi->net;
 	struct xfrm_if_parms p = {};
 
+	xfrmi_netlink_parms(data, &p);
 	if (!p.if_id) {
 		NL_SET_ERR_MSG(extack, "if_id must be non zero");
 		return -EINVAL;
 	}
 
-	xfrmi_netlink_parms(data, &p);
 	xi = xfrmi_locate(net, &p);
 	if (!xi) {
 		xi = netdev_priv(dev);


