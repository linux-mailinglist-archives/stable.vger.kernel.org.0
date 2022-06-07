Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3F95417B7
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358751AbiFGVEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378622AbiFGVEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:04:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474FB18C05D;
        Tue,  7 Jun 2022 11:48:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 755746168E;
        Tue,  7 Jun 2022 18:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF2EC385A5;
        Tue,  7 Jun 2022 18:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627729;
        bh=zLKqJ7YRx9+AQT3UXBkTEmxLVA2wtgkhaELDhD9VzXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srM6ZS3jlJ0Dwzh9hWoMGJb/d6JQlGSvNLcXyE2m19JV7Cb5BsiAMzVmvVt/x4Kw+
         gnUlaCuu3XY7IGe48caK4QIt32XzhRzkTcfzE2iqJ98H9EHhHi6n49VY21tgLeVN6A
         CmR2v1Q2WLNrA5oUo0rCz4Ujhry65kB2HcxC9eRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Niels Dossche <dossche.niels@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 065/879] mwifiex: add mutex lock for call in mwifiex_dfs_chan_sw_work_queue
Date:   Tue,  7 Jun 2022 18:53:03 +0200
Message-Id: <20220607165004.579924791@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 3e12968f6d12a34b540c39cbd696a760cc4616f0 ]

cfg80211_ch_switch_notify uses ASSERT_WDEV_LOCK to assert that
net_device->ieee80211_ptr->mtx (which is the same as priv->wdev.mtx)
is held during the function's execution.
mwifiex_dfs_chan_sw_work_queue is one of its callers, which does not
hold that lock, therefore violating the assertion.
Add a lock around the call.

Disclaimer:
I am currently working on a static analyser to detect missing locks.
This was a reported case. I manually verified the report by looking
at the code, so that I do not send wrong information or patches.
After concluding that this seems to be a true positive, I created
this patch.
However, as I do not in fact have this particular hardware,
I was unable to test it.

Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220321225515.32113-1-dossche.niels@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/11h.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/11h.c b/drivers/net/wireless/marvell/mwifiex/11h.c
index d2ee6469e67b..3fa25cd64cda 100644
--- a/drivers/net/wireless/marvell/mwifiex/11h.c
+++ b/drivers/net/wireless/marvell/mwifiex/11h.c
@@ -303,5 +303,7 @@ void mwifiex_dfs_chan_sw_work_queue(struct work_struct *work)
 
 	mwifiex_dbg(priv->adapter, MSG,
 		    "indicating channel switch completion to kernel\n");
+	mutex_lock(&priv->wdev.mtx);
 	cfg80211_ch_switch_notify(priv->netdev, &priv->dfs_chandef);
+	mutex_unlock(&priv->wdev.mtx);
 }
-- 
2.35.1



