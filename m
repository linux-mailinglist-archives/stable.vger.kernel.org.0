Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A039F657FFB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiL1QNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:13:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234555AbiL1QL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:11:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB75CDC5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:09:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AE5FB8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AA9C433D2;
        Wed, 28 Dec 2022 16:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243796;
        bh=Az+C2DkIvphMvXJJFfptiK2CQLMYct9hBqhW2Scu1yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRdbjrppcmM0ClaHKLJChHLh0GBxnPRb3U2IxpPim/KoeoVMtnJ76TZjRK0jNiDCD
         Sofjhc9D+OknPBjPyWzC/KJ5aX7fFM+HoIDTKZyUug8dBM6kbXkT5jyKxKOm3UMy09
         SAuQoyThZGct42gOQk6a76RLQC3JYuWElgNnUk28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0557/1146] Bluetooth: Fix EALREADY and ELOOP cases in bt_status()
Date:   Wed, 28 Dec 2022 15:34:56 +0100
Message-Id: <20221228144345.298799241@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 63db780a93eb802ece1bbf61ab5894ad8827b56e ]

'err' is known to be <0 at this point.

So, some cases can not be reached because of a missing "-".
Add it.

Fixes: ca2045e059c3 ("Bluetooth: Add bt_status")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/lib.c b/net/bluetooth/lib.c
index 469a0c95b6e8..53a796ac078c 100644
--- a/net/bluetooth/lib.c
+++ b/net/bluetooth/lib.c
@@ -170,7 +170,7 @@ __u8 bt_status(int err)
 	case -EMLINK:
 		return 0x09;
 
-	case EALREADY:
+	case -EALREADY:
 		return 0x0b;
 
 	case -EBUSY:
@@ -191,7 +191,7 @@ __u8 bt_status(int err)
 	case -ECONNABORTED:
 		return 0x16;
 
-	case ELOOP:
+	case -ELOOP:
 		return 0x17;
 
 	case -EPROTONOSUPPORT:
-- 
2.35.1



