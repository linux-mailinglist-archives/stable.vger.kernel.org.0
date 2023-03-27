Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D738A6CA69E
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 15:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbjC0N6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 09:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbjC0N6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 09:58:23 -0400
Received: from mail-ua1-x92b.google.com (mail-ua1-x92b.google.com [IPv6:2607:f8b0:4864:20::92b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BAC40C6;
        Mon, 27 Mar 2023 06:58:23 -0700 (PDT)
Received: by mail-ua1-x92b.google.com with SMTP id e12so6412002uaa.3;
        Mon, 27 Mar 2023 06:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679925502;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1qEU+rVkkUYYrGZNXDs/pQnJ83BJ29d49Lt+otVxVFE=;
        b=LZw+Ahx3Sz/7Hld2hIznRMoIHfqDMwgi70ei0cwNtIXsYZcPV/v8rdaUJR7urFL4Pi
         qJyyL545n0F+BjgZRgqIxH9REKjoJHPJw78MZGi8R1oH9Jy31yZSm6qHM5oCHuZVYGzI
         Wz0BGH+4Hj1NMe7HbsEizU01xT7butFL1EwapDeSIH2zSs8g40M+d02ifX5UWlPa/x08
         jptoar7N2WE4nWnz3J+AGkk34rKlUEWHi/lgnWWtbsjo4PocFtIUncArs7+/TZMDR82G
         mZWoB8kXFcBrI1LdqPyABTqHKNZIoFt7Z9tFsuXQI24xhySmhnNZK3ivhinVBae31yn+
         pSOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679925502;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1qEU+rVkkUYYrGZNXDs/pQnJ83BJ29d49Lt+otVxVFE=;
        b=4RWnuGp/PqB+4X/ZwbjfZAz1FHl8DuzT8Z5hMhE9QP1mQ2CEbARqEXqR1Y1hmGRAmn
         QRCow9sANobLHJxLkHRaA7AM/M0B6EsizIbqSmeZxZDJCjkCXgpjOCA4Q9cdM4WpNmSC
         X0GXsSDFDJ0Hv8s6+POtnduoo9WCBdj0W0M0QsQyhlVW38I/al3QOSpFG9nVKG7Xk6xW
         af8nmBhOgipu7Pfyiym39xatn1/akQXNabuQbA/T0CkxBye77Ssv7oypCmNtcW+ATskt
         FiipQoN3Jk3adKjgnxYjuvASQFzFGs3f0Q4yHqH29BV6uDa4IFzHKSMloO0OpeTQNcjb
         CTwQ==
X-Gm-Message-State: AAQBX9fj8jaihPZfxzOlU19VaRBi1pL03JkkaeQLx/iczc/m5dC7Iq45
        2YkRKxM9zEGPTU9+kUQ2OXSVaRPxnAkGYw==
X-Google-Smtp-Source: AKy350aT4afuu9AX6nZPRvmuDTh8nc/qT7WitUHEbe8BszQxWgqjgwEn8hHHca4rrzOe/3jMNlNLSg==
X-Received: by 2002:a05:6122:a08:b0:436:5f06:4f98 with SMTP id 8-20020a0561220a0800b004365f064f98mr5347596vkn.4.1679925502125;
        Mon, 27 Mar 2023 06:58:22 -0700 (PDT)
Received: from [127.0.1.1] ([91.230.2.244])
        by smtp.gmail.com with ESMTPSA id 135-20020a1f198d000000b004367f3393b8sm2731072vkz.28.2023.03.27.06.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 06:58:21 -0700 (PDT)
From:   Benjamin Bara <bbara93@gmail.com>
Subject: [PATCH v3 0/4] mfd: tps6586x: register restart handler
Date:   Mon, 27 Mar 2023 15:57:42 +0200
Message-Id: <20230327-tegra-pmic-reboot-v3-0-3c0ee3567e14@skidata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANagIWQC/02NywrDIBAAf6V47gaj5tGe+h+lh9WuiVBjWKUUQ
 v69pqceh2GYTWTiQFlcT5tgeocc0lJBn0/CzbhMBOFZWSiptNRqgEITI6wxOGCyKRUw7dB5P7Y
 GjRW1s5gJLOPi5qOMmAvxIVYmHz6/2f1R2XOKUGYm/F9IpaQ2XdOaXvfjAC1Yi4wXfZsihlfjU
 hT7/gWeDLhQuQAAAA==
To:     Wolfram Sang <wsa@kernel.org>, Lee Jones <lee@kernel.org>,
        rafael.j.wysocki@intel.com
Cc:     dmitry.osipenko@collabora.com, jonathanh@nvidia.com,
        richard.leitner@linux.dev, treding@nvidia.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

The Tegra20 requires an enabled VDE power domain during startup.
As the VDE is currently not used, it is disabled during runtime.
Since [1], there is a workaround for the "normal restart path" which
enables the VDE before doing PMC's warm reboot.
This workaround is not executed in the "emergency restart path", leading
to a hang-up during start.

This series implements and registers a new pmic-based restart handler for
boards with tps6586x.
This cold reboot ensures that the VDE power domain is enabled on
tegra20-based boards.

During panic(), preemption is disabled.
This should be correctly detected by i2c_in_atomic_xfer_mode() to use
atomic i2c xfer in this late stage. This avoids warnings regarding
"Voluntary context switch within RCU".

[1] 8f0c714ad9be1ef774c98e8819a7a571451cb019
v2: https://lore.kernel.org/all/20230320220345.1463687-1-bbara93@gmail.com/
system_state: https://lore.kernel.org/all/20230320213230.1459532-1-bbara93@gmail.com/
v1: https://lore.kernel.org/all/20230316164703.1157813-1-bbara93@gmail.com/

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
 drivers/mfd/tps6586x.c | 43 +++++++++++++++++++++++++++++++++++--------
 kernel/reboot.c        |  1 +
 3 files changed, 37 insertions(+), 9 deletions(-)
---
base-commit: 197b6b60ae7bc51dd0814953c562833143b292aa
change-id: 20230327-tegra-pmic-reboot-4175ff814a4b

Best regards,
-- 
Benjamin Bara <benjamin.bara@skidata.com>

