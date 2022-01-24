Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31220499E4B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1588301AbiAXWbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1584613AbiAXWV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:21:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48364C0424E9;
        Mon, 24 Jan 2022 12:52:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9D4060C11;
        Mon, 24 Jan 2022 20:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6450C340E5;
        Mon, 24 Jan 2022 20:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057528;
        bh=jVD31n0XfwWUjaU2jrHFkTVw1QFT1OP0Be3lL52UQb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLPlQndkHezvCwgKLSuspS8hQHfvoYiXYNiCoL/Jr32YOFaWrIaw+61NT8s66+OUI
         clauQy61Yb9Boampqq6+Z8C/QQzJ4+9O2T8P2SWoj2hffkklxAMu0tSd8ZS50wfl72
         JNuKnG3TXEQ+BHSaGznCHh+0RlC2fwDUGgavcDh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Lichvar <mlichvar@redhat.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 825/846] net: fix sock_timestamping_bind_phc() to release device
Date:   Mon, 24 Jan 2022 19:45:42 +0100
Message-Id: <20220124184129.359668763@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miroslav Lichvar <mlichvar@redhat.com>

commit 2a4d75bfe41232608f5596a6d1369f92ccb20817 upstream.

Don't forget to release the device in sock_timestamping_bind_phc() after
it was used to get the vclock indices.

Fixes: d463126e23f1 ("net: sock: extend SO_TIMESTAMPING for PHC binding")
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Yangbo Lu <yangbo.lu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -830,6 +830,8 @@ static int sock_timestamping_bind_phc(st
 	}
 
 	num = ethtool_get_phc_vclocks(dev, &vclock_index);
+	dev_put(dev);
+
 	for (i = 0; i < num; i++) {
 		if (*(vclock_index + i) == phc_index) {
 			match = true;


