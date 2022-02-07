Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9324ABD28
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379061AbiBGLjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386222AbiBGLeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:34:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3975AC043181;
        Mon,  7 Feb 2022 03:34:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC2E9B80EBD;
        Mon,  7 Feb 2022 11:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29714C004E1;
        Mon,  7 Feb 2022 11:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233637;
        bh=kXZdNLArO7qlWpDU7iG2egpXkmF2NNZxXC7x7oXDF0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYSgyyJiIUw42U6hSoh4I+xPe3pKQISWP4U3dzeVa5fmpl/KYawYS3xuJtqQXEpHo
         TSjofIxn0pxAqkvnmpM+BYlWFFWV3NuZbmhL2l/3lYXvIflMPBd+YZdXEcXFbomZYi
         ZjHiJRaDPvhkUtfv96ex2d+5W9t6fVnbIYRuUOiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lior Nahmanson <liorna@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 074/126] net: macsec: Verify that send_sci is on when setting Tx sci explicitly
Date:   Mon,  7 Feb 2022 12:06:45 +0100
Message-Id: <20220207103806.662170192@linuxfoundation.org>
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
@@ -4018,6 +4018,15 @@ static int macsec_newlink(struct net *ne
 	    !macsec_check_offload(macsec->offload, macsec))
 		return -EOPNOTSUPP;
 
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


