Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408A3150C01
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730438AbgBCQca (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:32:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730099AbgBCQca (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:32:30 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9F45218AC;
        Mon,  3 Feb 2020 16:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747549;
        bh=3UhvI8O3+HQoLTBCTeoSba6nKdJFcCf8MRzo7M4mGKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UYQ+OjTVWbqFxiCCEqSOu6AgWLeGZVv/6pEc/yYivCuu5GDxteB7baBfclcrqIudF
         znVbUPDboMrBlqZCImG5L4KzcHu6JxB5jy07tXb5xiXaa2J9FgPR6KxLOtA/Kq3/bX
         G+cEZt9Sue2tE34EJwuczlg2pe4crd02fFQd5r20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/70] ASoC: sti: fix possible sleep-in-atomic
Date:   Mon,  3 Feb 2020 16:19:51 +0000
Message-Id: <20200203161918.083571185@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaud Pouliquen <arnaud.pouliquen@st.com>

[ Upstream commit ce780a47c3c01e1e179d0792df6b853a913928f1 ]

Change mutex and spinlock management to avoid sleep
in atomic issue.

Signed-off-by: Arnaud Pouliquen <arnaud.pouliquen@st.com>
Link: https://lore.kernel.org/r/20200113100400.30472-1-arnaud.pouliquen@st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sti/uniperif_player.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sti/uniperif_player.c b/sound/soc/sti/uniperif_player.c
index 313dab2857ef9..4b0beb372cd94 100644
--- a/sound/soc/sti/uniperif_player.c
+++ b/sound/soc/sti/uniperif_player.c
@@ -226,7 +226,6 @@ static void uni_player_set_channel_status(struct uniperif *player,
 	 * sampling frequency. If no sample rate is already specified, then
 	 * set one.
 	 */
-	mutex_lock(&player->ctrl_lock);
 	if (runtime) {
 		switch (runtime->rate) {
 		case 22050:
@@ -303,7 +302,6 @@ static void uni_player_set_channel_status(struct uniperif *player,
 		player->stream_settings.iec958.status[3 + (n * 4)] << 24;
 		SET_UNIPERIF_CHANNEL_STA_REGN(player, n, status);
 	}
-	mutex_unlock(&player->ctrl_lock);
 
 	/* Update the channel status */
 	if (player->ver < SND_ST_UNIPERIF_VERSION_UNI_PLR_TOP_1_0)
@@ -365,8 +363,10 @@ static int uni_player_prepare_iec958(struct uniperif *player,
 
 	SET_UNIPERIF_CTRL_ZERO_STUFF_HW(player);
 
+	mutex_lock(&player->ctrl_lock);
 	/* Update the channel status */
 	uni_player_set_channel_status(player, runtime);
+	mutex_unlock(&player->ctrl_lock);
 
 	/* Clear the user validity user bits */
 	SET_UNIPERIF_USER_VALIDITY_VALIDITY_LR(player, 0);
@@ -598,7 +598,6 @@ static int uni_player_ctl_iec958_put(struct snd_kcontrol *kcontrol,
 	iec958->status[1] = ucontrol->value.iec958.status[1];
 	iec958->status[2] = ucontrol->value.iec958.status[2];
 	iec958->status[3] = ucontrol->value.iec958.status[3];
-	mutex_unlock(&player->ctrl_lock);
 
 	spin_lock_irqsave(&player->irq_lock, flags);
 	if (player->substream && player->substream->runtime)
@@ -608,6 +607,8 @@ static int uni_player_ctl_iec958_put(struct snd_kcontrol *kcontrol,
 		uni_player_set_channel_status(player, NULL);
 
 	spin_unlock_irqrestore(&player->irq_lock, flags);
+	mutex_unlock(&player->ctrl_lock);
+
 	return 0;
 }
 
-- 
2.20.1



