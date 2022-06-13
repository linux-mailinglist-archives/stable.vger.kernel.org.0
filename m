Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA75F548E26
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244015AbiFMKf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345861AbiFMKeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:34:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEFC28726;
        Mon, 13 Jun 2022 03:22:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 977EECE0EEB;
        Mon, 13 Jun 2022 10:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70999C34114;
        Mon, 13 Jun 2022 10:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115731;
        bh=+hGjQKfDNGnTsMzTo9PMesAjDFTq1kh+tT1+3aPgf3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HP8hr3jeFAkEK6XmGWYMs9Gq7RWlv3ziOrcg6UV8ppcmD8VVaztvKta1Iw+8aBmPZ
         g+9+mIm8Nl9AVu8fozc3l+Imz2CtOZvZ+KnD1JqgR7nLXrVJK1rWKZmnKXk3SiRyC+
         2QBtlKvIr92aNHigEo+MHYKIae8PSQ52iwKYmeqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Niels Dossche <dossche.niels@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 009/218] mwifiex: add mutex lock for call in mwifiex_dfs_chan_sw_work_queue
Date:   Mon, 13 Jun 2022 12:07:47 +0200
Message-Id: <20220613094910.533370585@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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
index 238accfe4f41..c4176e357b22 100644
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



