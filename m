Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766AD63D9D2
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 16:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiK3Pr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 10:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiK3Pr5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 10:47:57 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D70E2181B
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 07:47:45 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id gu23so24135188ejb.10
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 07:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:from:to:cc:subject:date:message-id:reply-to;
        bh=EcYtt4TvCK6BJCf6X9l4DaZy+QVb6a2ZN0d4hYVvO5M=;
        b=HkNQp9YU/g8x0KR+AJ4lyzhOvHqTcw8p0Lo+9qzPNb+bGgbOIGX+8QfYWOekwN10Y0
         j5Xy7dXUm2URn1NLg0LZ+uYuMwWrc7VWPI/adrLJ5KwaDGbDpK0KQDmECZYZLoC/ibPU
         qCk/dypWPhNOBgEQKAtUPvJGOv5/zvkocjG4A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:date:from:content-transfer-encoding:mime-version
         :subject:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EcYtt4TvCK6BJCf6X9l4DaZy+QVb6a2ZN0d4hYVvO5M=;
        b=V08pUHEkGf6Doffap/3fDNPSBFzpIji6y2mYY/7Vnx9u+ZjoCMcKS6frPcZjDCa/ye
         aiOWWgNAx6eYgcXLV/cWcNrbt+1c4ULXao8FYp2WRn3TRkH5Zyh75emz9kJ/1vPUY0ke
         AnGTUZhegdVvQvUfcSxvC+00L9v3B6k7QCkKPZg3oKYSqlWSxTeFqfGyKezFCGvwo+wG
         XpHD51ZWll3GqxXtYUxvlwjSd7Z7vPV/qDt6X+mnUa1VwXVFx+IK+hwOv3tm7hD/Z2jW
         Ith3+V7XX2VKhEqKPD1XY7OijjqpayEhW6YtTtjXSM6zCG2rw7G7thLa6PkPJTWnPVjm
         BRcg==
X-Gm-Message-State: ANoB5pmNGoTcRsRMK0nH5RCPpJUjtHO/8onZVQv1ZTUGZsugRqBmcvmu
        wB0tFjLy/nrFO2gzgxQcGO/nlg==
X-Google-Smtp-Source: AA0mqf6Z1je942r9oeXVz/mlwkUzKcyf4WjxIsYxEuWQeNcO0op0aSlw6z0KssbOi2JnutK+MAi57Q==
X-Received: by 2002:a17:907:9190:b0:78a:52bb:d904 with SMTP id bp16-20020a170907919000b0078a52bbd904mr35398243ejb.630.1669823263729;
        Wed, 30 Nov 2022 07:47:43 -0800 (PST)
Received: from alco.roam.corp.google.com ([2620:0:1059:10:5b33:e3f2:6a0b:dcdd])
        by smtp.gmail.com with ESMTPSA id j9-20020a17090623e900b007bf24b8f80csm775075ejg.63.2022.11.30.07.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 07:47:43 -0800 (PST)
Subject: [PATCH v6 0/2] ASoC: SOF: Fix deadlock when shutdown a frozen userspace
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAJ7h2MC/3XO0arCMAwG4FeRXltZ0q6bXvkeci7SNrqCdtC6wT
 mydz/RS9nIRfgDX5KXqlwSV3XavVThOdU0Zgluv1NhoHxjnaJkhQ0iAHa65qivhfmPNTCDNYi9Qa
 cEeKqsfaEcBiF5ut9lOKT6HMvv58AM0i6ru2bQjW4764CMcxzwHIYyPtL0OIzlpn5k04zbGkXHni
 y2TEfnzIo229qIJuRInYFAYFe03db2/bk4Z313RfIrut3WrWjLUco3vafmSy/L8g/3tjM2pAEAAA
 ==
From:   Ricardo Ribalda <ribalda@chromium.org>
Date:   Wed, 30 Nov 2022 16:47:14 +0100
Message-Id: <20221127-snd-freeze-v6-0-3e90553f64a5@chromium.org>
To:     Chromeos Kdump <chromeos-kdump@google.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Mark Brown <broonie@kernel.org>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Takashi Iwai <tiwai@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        kexec@lists.infradead.org, sound-open-firmware@alsa-project.org
X-Mailer: b4 0.11.0-dev-696ae
X-Developer-Signature: v=1; a=openpgp-sha256; l=2401; i=ribalda@chromium.org;
 h=from:subject:message-id; bh=0IpYWvaM1nSCLes2AAhkL8u1zUltWsSBA7Q7jAHaGa0=;
 b=owEBbQKS/ZANAwAKAdE30T7POsSIAcsmYgBjh3sRb5TNdySmknidfqXIO/9uwnM15fXaAOYH1a7B
 CsZYzoyJAjMEAAEKAB0WIQREDzjr+/4oCDLSsx7RN9E+zzrEiAUCY4d7EQAKCRDRN9E+zzrEiHMJD/
 wOyrlwuTrdzgZKh/vpQf1F1krDwjjxFuxAWO6DF7eyp/O92Lm0IMo6CSCttg4VXQz1Dh33wT1nsAbz
 OtCKyiQx+Uxj9D2fv4V1pxus4Bt4eaG1Q7rUMDaFOf/6+w/XOmcZCsSRc3T8b6fYlzqHi5y1pafgb8
 0J3nsBlYFU8LwiWXkVJ3FR9Q2vqc8ft/ttb9p7S9NWL96g6MxuviygZN7+SUVvLzh18h0pMXyo0u4k
 bXZJdZgj743SD5Jgq1dAC+EDo7SzwSfeMqdPv9pmTHiWLcPkAmlTCDBaG1921XxGfAwdRh9D0BArwR
 kcMFumuoEBMYPnkCcdmGpcPfoJKJ9nFV6mz2dri01o+cCf0YbCWYZRITxOVlOZgoq0hXhaK/PeAeaZ
 NmeA2bYOe/HTSDUyCqfGurAQf7WC7OFqwvd5YCQkHXBDfdEIThvDWtCqz/iE/4a/BX6zwkhBuPAnTR
 I81RRoUr6wNJ1JNAqsgDlEXsGvhalrV/EZkkIQN4PZeXedA/nm0Vxmwcv4HLy/q4O4S5uAbBBWChOv
 PiZwAjkYcVc1TZm8+yGlWkYaXA3E72DdKdi6g4fsRKXSNcX7wh3Rvtjr+3PprsuFOSbMZbqJafyvCh
 JHhakZZOqmtBsIsR4TrkSzSw9TosMuXQZxnGgsNl562FPWAnz7D2Yk+c7Ulg==
X-Developer-Key: i=ribalda@chromium.org; a=openpgp;
 fpr=9EC3BB66E2FC129A6F90B39556A0D81F9F782DA9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since: 83bfc7e793b5 ("ASoC: SOF: core: unregister clients and machine drivers in .shutdown")
we wait for all the workloads to be completed during shutdown. This was done to 
avoid a stall once the device is started again.

Unfortunately this has the side effect of stalling kexec(), if the userspace
is frozen. Let's handle that case.

To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To: Liam Girdwood <lgirdwood@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
To: Bard Liao <yung-chuan.liao@linux.intel.com>
To: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
To: Kai Vehmanen <kai.vehmanen@linux.intel.com>
To: Daniel Baluta <daniel.baluta@nxp.com>
To: Mark Brown <broonie@kernel.org>
To: Jaroslav Kysela <perex@perex.cz>
To: Takashi Iwai <tiwai@suse.com>
To: Eric Biederman <ebiederm@xmission.com>
To: Chromeos Kdump <chromeos-kdump@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: stable@vger.kernel.org
Cc: sound-open-firmware@alsa-project.org
Cc: alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Cc: kexec@lists.infradead.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
Changes in v6:
- Check if we are in kexec with the userspace frozen.
- Link to v5: https://lore.kernel.org/r/20221127-snd-freeze-v5-0-4ededeb08ba0@chromium.org

Changes in v5:
- Edit subject prefix.
- Link to v4: https://lore.kernel.org/r/20221127-snd-freeze-v4-0-51ca64b7f2ab@chromium.org

Changes in v4:
- Do not call snd_sof_machine_unregister from shutdown.
- Link to v3: https://lore.kernel.org/r/20221127-snd-freeze-v3-0-a2eda731ca14@chromium.org

Changes in v3:
- Wrap pm_freezing in a function.
- Link to v2: https://lore.kernel.org/r/20221127-snd-freeze-v2-0-d8a425ea9663@chromium.org

Changes in v2:
- Only use pm_freezing if CONFIG_FREEZER .
- Link to v1: https://lore.kernel.org/r/20221127-snd-freeze-v1-0-57461a366ec2@chromium.org

---
Ricardo Ribalda (2):
      kexec: Introduce kexec_with_frozen_processes
      ASoC: SOF: Fix deadlock when shutdown a frozen userspace

 include/linux/kexec.h | 3 +++
 kernel/kexec_core.c   | 5 +++++
 sound/soc/sof/core.c  | 4 +++-
 3 files changed, 11 insertions(+), 1 deletion(-)
---
base-commit: 4312098baf37ee17a8350725e6e0d0e8590252d4
change-id: 20221127-snd-freeze-1ee143228326

Best regards,
-- 
Ricardo Ribalda <ribalda@chromium.org>
