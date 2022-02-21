Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98464BE6C9
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350508AbiBUJdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:33:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350367AbiBUJcU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:32:20 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED64D27FFA;
        Mon, 21 Feb 2022 01:13:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 177A9CE0E92;
        Mon, 21 Feb 2022 09:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0D5C340E9;
        Mon, 21 Feb 2022 09:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434817;
        bh=7eP9GV9smWbWM1dmSH/hpT0rJMPPs4tjxlSzxYHcRbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzVm97yMIJEJAJ5D6/cfhmH0sz3uNeh9pIibmkWaVE7oJty29NV1Z1qGr3DLwsZL6
         T24VinTF23uigfb6/8grhUWqQEAOt19JXFC78A47bMjh2T95oGf5Mx7HP8M0xQMc0p
         1XLuEf28P6o/VUsPePlL/xeFxTr2g8SS4ZyZaFzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzkaller <syzkaller@googlegroups.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/196] HID: elo: fix memory leak in elo_probe
Date:   Mon, 21 Feb 2022 09:49:33 +0100
Message-Id: <20220221084935.638846630@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 817b8b9c5396d2b2d92311b46719aad5d3339dbe ]

When hid_parse() in elo_probe() fails, it forgets to call usb_put_dev to
decrease the refcount.

Fix this by adding usb_put_dev() in the error handling code of elo_probe().

Fixes: fbf42729d0e9 ("HID: elo: update the reference count of the usb device structure")
Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-elo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-elo.c b/drivers/hid/hid-elo.c
index 8e960d7b233b3..9b42b0cdeef06 100644
--- a/drivers/hid/hid-elo.c
+++ b/drivers/hid/hid-elo.c
@@ -262,6 +262,7 @@ static int elo_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	return 0;
 err_free:
+	usb_put_dev(udev);
 	kfree(priv);
 	return ret;
 }
-- 
2.34.1



