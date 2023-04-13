Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493A16E0818
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 09:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjDMHrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 03:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjDMHrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 03:47:10 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B40900B;
        Thu, 13 Apr 2023 00:47:04 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id si1so5005583ejb.10;
        Thu, 13 Apr 2023 00:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681372022; x=1683964022;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KOuwbnc4+41VpzVHB9p5nbmYtRThGGu7Mwdt155gh28=;
        b=qqTgVQmAL6UU97AE//TW9OjBsm6bBbg9WvGKt4vdlPzHDDn7S1FY1dgtuLcPJ5T59Z
         mEDCt3yjGEqd0k4CG8ocNxlDKlJb2mkPMuUw+8sWmse1wWXNIlYEUNE/Hd1Xq6gPNMwf
         iPaut3yVjByLOaaW+WzIbF7EEH3mnZVCtyPA5VV843tRtw6vZAwhIbwTY24jmD6C71Zx
         4zDqaiqUbvXV1OthH3sDnBhijxvpesuSTO+rz5Yrvp7o+AaFo7OCHTrZesM58IWmz5ow
         jkV8holglAhsu2yiIAp3MThSZIexkXu5678CcFCZdET765qe3Z8NgmcX+NygmQOOM56l
         Vk5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681372022; x=1683964022;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KOuwbnc4+41VpzVHB9p5nbmYtRThGGu7Mwdt155gh28=;
        b=lAFbbFmE+hF2t7KfecDAJ/o9e0lRBB1U7t78BJyp2oRS1bZesGlAOEKHutbrWJaVga
         y8paXzLdq0WHFiSwqp/rrXT2IrAQka4Ly26SQCPh6LTnA3Td4ZjjZoZOj3Mx4+H7fUmf
         WuMUUSx4Rxfz1E07SMVdLMg4ko4vOo8Gr8ukD2ZTagMqoRJ65V+chj+PfffCJZ4Owroe
         chSlppowIa9u1eRTWWVh/apfch8b+l0zDFpy6dnnOh8MPg2ruI7Og9q30P9hkmsjPiT5
         /XD+YpihR/zm7qWeHYBD6Lz26N9sqDuEV8yUocQOdAswYz33V420DfdsGUkOnhFz0Cb4
         kDyg==
X-Gm-Message-State: AAQBX9dTcOLfEv+XUEVUts1FVAAOUDUq1dBs03io0+MUKwwToW8Y1QM2
        eA9zAO6E/ekfBUka9Uk6HlObGEEgGYzqvQ==
X-Google-Smtp-Source: AKy350bp3iXlyEQbFjKGT5NZIccPNn9+rLYfP5Ln+3SubO5TqiLEFUZU6DhuulQ31aQNr5Shh+DN/g==
X-Received: by 2002:a17:906:2009:b0:94a:4cba:3302 with SMTP id 9-20020a170906200900b0094a4cba3302mr1593072ejo.64.1681372022279;
        Thu, 13 Apr 2023 00:47:02 -0700 (PDT)
Received: from [127.0.1.1] ([91.230.2.244])
        by smtp.gmail.com with ESMTPSA id q16-20020a1709060f9000b0094e954fd015sm565620ejj.175.2023.04.13.00.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 00:47:01 -0700 (PDT)
From:   Benjamin Bara <bbara93@gmail.com>
Subject: [PATCH v4 0/4] mfd: tps6586x: register restart handler
Date:   Thu, 13 Apr 2023 09:46:38 +0200
Message-Id: <20230327-tegra-pmic-reboot-v4-0-b24af219fb47@skidata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAF6zN2QC/32OwW7CMBBEfwX53EW210koJ/4DcVibTWKBY7S2I
 iqUf2+SU089Po3mzXxUYYlc1PnwUcJzLDFPK7ivgwojTQNDvK+srLao0XZQeRCCV4oBhH3OFZz
 pmr4/GUfOq7XnqTB4oSmMWzNRqSxb8BLu43sfu95W7iUnqKMw/Z3Q1mp0zdG4FttTBwa8J6Fvv
 AyJ4vMYctpkYyw1y89+fMZN+d/HGUEDBs2MTduxcZfyiHeqtOtuy7L8AhEdiJIKAQAA
To:     Wolfram Sang <wsa@kernel.org>, Lee Jones <lee@kernel.org>,
        rafael.j.wysocki@intel.com
Cc:     dmitry.osipenko@collabora.com, peterz@infradead.org,
        jonathanh@nvidia.com, richard.leitner@linux.dev,
        treding@nvidia.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

The Tegra20 requires an enabled VDE power domain during startup. As the
VDE is currently not used, it is disabled during runtime.
Since 8f0c714ad9be, there is a workaround for the "normal restart path"
which enables the VDE before doing PMC's warm reboot. This workaround is
not executed in the "emergency restart path", leading to a hang-up
during start.

This series implements and registers a new pmic-based restart handler
for boards with tps6586x. This cold reboot ensures that the VDE power
domain is enabled during startup on tegra20-based boards.

Since bae1d3a05a8b, i2c transfers are non-atomic while preemption is
disabled (which is e.g. done during panic()). This could lead to
warnings ("Voluntary context switch within RCU") in i2c-based restart
handlers during emergency restart. The state of preemption should be
detected by i2c_in_atomic_xfer_mode() to use atomic i2c xfer when
required. Beside the new system_state check, the check is the same as
the one pre v5.2.

v3: https://lore.kernel.org/r/20230327-tegra-pmic-reboot-v3-0-3c0ee3567e14@skidata.com
v2: https://lore.kernel.org/all/20230320220345.1463687-1-bbara93@gmail.com/
system_state: https://lore.kernel.org/all/20230320213230.1459532-1-bbara93@gmail.com/
v1: https://lore.kernel.org/all/20230316164703.1157813-1-bbara93@gmail.com/

v4:
- 1,2: add "Fixes" and adapt commit messages
- 4: reduce delay after requesting the restart (as suggested by Dmitry)

v3:
- bring system_state back in this series
- do atomic i2c xfer if not preemptible (as suggested by Dmitry)
- fix style issues mentioned by Dmitry
- add cc stable as suggested by Dmitry
- add explanation why this is needed for Jon

v2:
- use devm-based restart handler
- convert the existing power_off handler to a devm-based handler
- handle system_state in extra series

---
Benjamin Bara (4):
      kernel/reboot: emergency_restart: set correct system_state
      i2c: core: run atomic i2c xfer when !preemptible
      mfd: tps6586x: use devm-based power off handler
      mfd: tps6586x: register restart handler

 drivers/i2c/i2c-core.h |  2 +-
 drivers/mfd/tps6586x.c | 45 +++++++++++++++++++++++++++++++++++++--------
 kernel/reboot.c        |  1 +
 3 files changed, 39 insertions(+), 9 deletions(-)
---
base-commit: 197b6b60ae7bc51dd0814953c562833143b292aa
change-id: 20230327-tegra-pmic-reboot-4175ff814a4b

Best regards,
-- 
Benjamin Bara <benjamin.bara@skidata.com>

