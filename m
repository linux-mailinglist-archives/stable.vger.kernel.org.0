Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A520D6ECE80
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbjDXNdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbjDXNcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:32:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16C27AB8
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:32:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 817A86237A
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95153C433EF;
        Mon, 24 Apr 2023 13:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343153;
        bh=xoulg0rPLojomnlsHTGdXMTCg2+NeqGJ+rernlM3i6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jvVAEMt652oaI/RWOay2KjfMUYRN3/rJuSOIZilXg84wvFtuCT1A5n/ETYJKqpk/u
         wZbI4ESaqu22d7OwhKaWtG9m2+fEiA7l3AmpeJ6xxDqFzpjiJOuh8HqwG8c3wFumhN
         P9JSCubOzpWHM2FL5qAtPWTijU2gD0YGTB38GE5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.2 067/110] wifi: ath9k: Dont mark channelmap stack variable read-only in ath9k_mci_update_wlan_channels()
Date:   Mon, 24 Apr 2023 15:17:29 +0200
Message-Id: <20230424131138.872623973@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@toke.dk>

commit 0f2a4af27b649c13ba76431552fe49c60120d0f6 upstream.

This partially reverts commit e161d4b60ae3a5356e07202e0bfedb5fad82c6aa.

Turns out the channelmap variable is not actually read-only, it's modified
through the MCI_GPM_CLR_CHANNEL_BIT() macro further down in the function,
so making it read-only causes page faults when that code is hit.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217183
Link: https://lore.kernel.org/r/20230413214118.153781-1-toke@toke.dk
Fixes: e161d4b60ae3 ("wifi: ath9k: Make arrays prof_prio and channelmap static const")
Cc: stable@vger.kernel.org
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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



