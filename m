Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EBF548F60
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355267AbiFMLkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355490AbiFMLjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:39:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4133D2C10E;
        Mon, 13 Jun 2022 03:48:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA01AB80E56;
        Mon, 13 Jun 2022 10:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F43C34114;
        Mon, 13 Jun 2022 10:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117314;
        bh=+hGjQKfDNGnTsMzTo9PMesAjDFTq1kh+tT1+3aPgf3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pA4JwC/EMPcuxiJ1L3iAWJN/vXtDumOrc6Wp8P67Ct5e8Ltq0zouLs6UKNSlbXt83
         D005e8AGR31/xtOBEraZTd4xAc8iFb8ytFGcIUmJwDHT+FCfKMDtIHPdONgMN3ZcBh
         qGl4cNeX2vHF4Owobyg8Uucps7QGymac068q5sDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Norris <briannorris@chromium.org>,
        Niels Dossche <dossche.niels@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/287] mwifiex: add mutex lock for call in mwifiex_dfs_chan_sw_work_queue
Date:   Mon, 13 Jun 2022 12:07:14 +0200
Message-Id: <20220613094924.163496151@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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



