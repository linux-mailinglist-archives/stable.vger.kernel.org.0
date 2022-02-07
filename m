Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D84F4ABAE7
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384129AbiBGLYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356374AbiBGLNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:13:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF226C043181;
        Mon,  7 Feb 2022 03:13:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68C696126D;
        Mon,  7 Feb 2022 11:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD47C004E1;
        Mon,  7 Feb 2022 11:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232379;
        bh=eVnM4/vWa5RlrsKSZ9YEG2ii+6AgOF8vjc0ymH0k7qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fqiONOXMNzP+APf21135WvfNLiYG3b02AC6gkANx8VzN/Puq+zOW2+RNGE5Cfx5v4
         1jJH5cgz/oHXDDNlN+PS8cJutEjJ8IoJSNdVBA8tDmWv62CAd/WK6kli0sv8jNGyOO
         ErLuXyc2QOYuWXEpeT8lWIoyxD/9ZYt6oVultNok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 60/69] net: macsec: Verify that send_sci is on when setting Tx sci explicitly
Date:   Mon,  7 Feb 2022 12:06:22 +0100
Message-Id: <20220207103757.598605103@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
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

From: Lior Nahmanson <liorna@nvidia.com>

commit d0cfa548dbde354de986911d3913897b5448faad upstream.

When setting Tx sci explicit, the Rx side is expected to use this
sci and not recalculate it from the packet.However, in case of Tx sci
is explicit and send_sci is off, the receiver is wrongly recalculate
the sci from the source MAC address which most likely be different
than the explicit sci.

Fix by preventing such configuration when macsec newlink is established
and return EINVAL error code on such cases.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Raed Salem <raeds@nvidia.com>
Link: https://lore.kernel.org/r/1643542672-29403-1-git-send-email-raeds@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3230,6 +3230,15 @@ static int macsec_newlink(struct net *ne
 
 	macsec->real_dev = real_dev;
 
+	/* send_sci must be set to true when transmit sci explicitly is set */
+	if ((data && data[IFLA_MACSEC_SCI]) &&
+	    (data && data[IFLA_MACSEC_INC_SCI])) {
+		u8 send_sci = !!nla_get_u8(data[IFLA_MACSEC_INC_SCI]);
+
+		if (!send_sci)
+			return -EINVAL;
+	}
+
 	if (data && data[IFLA_MACSEC_ICV_LEN])
 		icv_len = nla_get_u8(data[IFLA_MACSEC_ICV_LEN]);
 	mtu = real_dev->mtu - icv_len - macsec_extra_len(true);


