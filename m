Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8275E6E16A8
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 23:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbjDMVsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 17:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjDMVsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 17:48:10 -0400
X-Greylist: delayed 333 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Apr 2023 14:48:09 PDT
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6C059C9
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 14:48:08 -0700 (PDT)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1681422153; bh=M+XbNczh0eCfGiU8V4hdkpbBAUg5moUMwJisiRIA6Ec=;
        h=From:To:Cc:Subject:Date:From;
        b=E72D/v+5OBcBlIHLmWlWis3LJMS/Ho5XDcCkHVbjAE7ZDsRPi56/th7umTL0WF1fA
         EKiY98s3012O3nDr0vUrAM+CUfmVZzPVL8qc0o/tL3wv1k+uQzPbclqPzFkp/B9a51
         4VIT3MiFKeSAWl+ZG8K3a/MLfDB1P7kyiBj9B+7um/PXeonZFYvLtAny7W4AhCCULD
         Cm9UNwDYJXdgfXXjzTloPEB2JpBmTCpkgK03ZiKXiHCuydkoTqmxTcw20LBKiwcON+
         37oS8wbNwkzWhDuCvmuNOULb43lil+9bEAI+7Q00fe5/dQeC91OmqX1GfRHAu9oPWl
         cjL6CW8tnA5+w==
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Colin Ian King <colin.i.king@gmail.com>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] wifi: ath9k: Don't mark channelmap stack variable read-only in ath9k_mci_update_wlan_channels()
Date:   Thu, 13 Apr 2023 23:41:18 +0200
Message-Id: <20230413214118.153781-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This partially reverts commit e161d4b60ae3a5356e07202e0bfedb5fad82c6aa.

Turns out the channelmap variable is not actually read-only, it's modified
through the MCI_GPM_CLR_CHANNEL_BIT() macro further down in the function,
so making it read-only causes page faults when that code is hit.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217183
Fixes: e161d4b60ae3 ("wifi: ath9k: Make arrays prof_prio and channelmap static const")
Cc: stable@vger.kernel.org
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 drivers/net/wireless/ath/ath9k/mci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 3363fc4e8966..a0845002d6fe 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -646,9 +646,7 @@ void ath9k_mci_update_wlan_channels(struct ath_softc *sc, bool allow_all)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_hw_mci *mci = &ah->btcoex_hw.mci;
 	struct ath9k_channel *chan = ah->curchan;
-	static const u32 channelmap[] = {
-		0x00000000, 0xffff0000, 0xffffffff, 0x7fffffff
-	};
+	u32 channelmap[] = {0x00000000, 0xffff0000, 0xffffffff, 0x7fffffff};
 	int i;
 	s16 chan_start, chan_end;
 	u16 wlan_chan;
-- 
2.40.0

