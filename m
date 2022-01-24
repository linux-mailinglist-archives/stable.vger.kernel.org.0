Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC6049A4B3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371684AbiAYAJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2364587AbiAXXse (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:48:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2982C07E32C;
        Mon, 24 Jan 2022 13:43:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68BB8B812A5;
        Mon, 24 Jan 2022 21:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD08C340E5;
        Mon, 24 Jan 2022 21:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060622;
        bh=T7Qh6ncURuM95zleYtc/I17OlL/HQAyS5maJpXJereo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B24HB/VInSjEUzu1V/eOMNp09xh0p0tJDMUVR8qNcy+p9LwDp7MUuU9HMvnWTzs7F
         dwDuoRoJ9w/iamWdeJKfQlvzyU/e3KcVh8gY8lfwcEioZqgz7ju6i56Q98WyhhkkVK
         eMgpPkQqIhFut9o0eRvTiUE+A7MXQi0UIzeTSZIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miroslav Lichvar <mlichvar@redhat.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.16 1008/1039] net: fix sock_timestamping_bind_phc() to release device
Date:   Mon, 24 Jan 2022 19:46:37 +0100
Message-Id: <20220124184159.173240015@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
@@ -843,6 +843,8 @@ static int sock_timestamping_bind_phc(st
 	}
 
 	num = ethtool_get_phc_vclocks(dev, &vclock_index);
+	dev_put(dev);
+
 	for (i = 0; i < num; i++) {
 		if (*(vclock_index + i) == phc_index) {
 			match = true;


