Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828674ABB34
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384274AbiBGL1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381796AbiBGLRh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:17:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EB1C03FEF5;
        Mon,  7 Feb 2022 03:17:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53A216140B;
        Mon,  7 Feb 2022 11:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F168C004E1;
        Mon,  7 Feb 2022 11:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232633;
        bh=aW42/6zNvWJbAk4tUnC4FxoCpJ/vgzciBuyE2ZalzeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ghNoK9T3BfZUTOv1Xhx+uad7cCr1rHHsAPsrLQoj/vHKwdJEDll5lW617s9FvCAIK
         9LFcOuLDKyI413LCV8z9djhuJTnBt5kj0A+BMPNTzPAVJ3rKd3tnPI7NtqKAsJvfo5
         Dq1zpgOajxFhPzWVx79ROb3Nyy/iQDtoIouCCtLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 74/86] net: macsec: Verify that send_sci is on when setting Tx sci explicitly
Date:   Mon,  7 Feb 2022 12:06:37 +0100
Message-Id: <20220207103800.101513083@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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
@@ -3259,6 +3259,15 @@ static int macsec_newlink(struct net *ne
 
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


