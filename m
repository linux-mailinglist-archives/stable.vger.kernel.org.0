Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879C1328B67
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhCASdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:33:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239869AbhCAS0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:26:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B1EC64DF1;
        Mon,  1 Mar 2021 17:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620798;
        bh=qS/DGxoW8XyHpTklI2QUa2QLcA8TgLWjoX4x1oTEIqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTgnskPmL5EiSJq9nj0khniMyIGoAyNTUtLdqiEt2CthfBuf/GXyMO+EgwO6onStV
         H0sqv/XvVNN5BsUzDFXt/U8/xQ512JREYCf7QXPSyYpJzuA0rP6gRYsqAJx/7YDeeg
         YEZZZvdZmLrNHiP8sc4fTtb0WnzvQJMadRt43TO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jairaj Arava <jairaj.arava@intel.com>,
        Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@intel.com>,
        Shuming Fan <shumingf@realtek.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 266/775] ASoC: rt5682: Fix panic in rt5682_jack_detect_handler happening during system shutdown
Date:   Mon,  1 Mar 2021 17:07:14 +0100
Message-Id: <20210301161214.775083524@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>

[ Upstream commit 45a2702ce10993eda7a5b12690294782d565519c ]

During Coldboot stress tests, system encountered the following panic.
Panic logs depicts rt5682_i2c_shutdown() happened first and then later
jack detect handler workqueue function triggered.
This situation causes panic as rt5682_i2c_shutdown() resets codec.
Fix this panic by cancelling all jack detection delayed work.

Panic log:
[   20.936124] sof_pci_shutdown
[   20.940248] snd_sof_device_shutdown
[   20.945023] snd_sof_shutdown
[   21.126849] rt5682_i2c_shutdown
[   21.286053] rt5682_jack_detect_handler
[   21.291235] BUG: kernel NULL pointer dereference, address: 000000000000037c
[   21.299302] #PF: supervisor read access in kernel mode
[   21.305254] #PF: error_code(0x0000) - not-present page
[   21.311218] PGD 0 P4D 0
[   21.314155] Oops: 0000 [#1] PREEMPT SMP NOPTI
[   21.319206] CPU: 2 PID: 123 Comm: kworker/2:3 Tainted: G     U            5.4.68 #10
[   21.333687] ACPI: Preparing to enter system sleep state S5
[   21.337669] Workqueue: events_power_efficient rt5682_jack_detect_handler [snd_soc_rt5682]
[   21.337671] RIP: 0010:rt5682_jack_detect_handler+0x6c/0x279 [snd_soc_rt5682]

Fixes: a50067d4f3c1d ('ASoC: rt5682: split i2c driver into separate module')
Signed-off-by: Jairaj Arava <jairaj.arava@intel.com>
Signed-off-by: Sathyanarayana Nujella <sathyanarayana.nujella@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@intel.com>
Reviewed-by: Shuming Fan <shumingf@realtek.com>
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20210205171428.2344210-1-ranjani.sridharan@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-i2c.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/rt5682-i2c.c b/sound/soc/codecs/rt5682-i2c.c
index 37d13120f5ba8..93c1603b42f10 100644
--- a/sound/soc/codecs/rt5682-i2c.c
+++ b/sound/soc/codecs/rt5682-i2c.c
@@ -273,6 +273,9 @@ static void rt5682_i2c_shutdown(struct i2c_client *client)
 {
 	struct rt5682_priv *rt5682 = i2c_get_clientdata(client);
 
+	cancel_delayed_work_sync(&rt5682->jack_detect_work);
+	cancel_delayed_work_sync(&rt5682->jd_check_work);
+
 	rt5682_reset(rt5682);
 }
 
-- 
2.27.0



