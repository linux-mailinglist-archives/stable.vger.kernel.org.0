Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 623436E5F63
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 13:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjDRLKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 07:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjDRLKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 07:10:36 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F479772;
        Tue, 18 Apr 2023 04:10:25 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id dm2so72244342ejc.8;
        Tue, 18 Apr 2023 04:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681816224; x=1684408224;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RyCcUDzMN8yvXUqojP7X4CUbHBSUL6H6PF502SlrCvU=;
        b=i3clYhfGXTuH/0YGvKfLs4rCn4yYRK7wsJI+dLboy0cDl/ZMIZXzq4y/4X5GwMVFS3
         C47oqNDtrdRY+N7gngATWbayI4YXITzecdxXQ1Ev4TERr2ofTpwhsPreQR54RkmgqHvE
         NhF+4jBkApjQLUOhlcncsWgRCbyMLeqyH5ZMbdPcVsyJFM42LxYgfZ5tXlXjdGHAUvY5
         fxQ8gBChBzQ9iBg6aXdgg2fJ0wqqLBOR0nemZT3WwLlBFh2S0riCDiBc7lNRi7qr/ufA
         Zt4UhGSVCKJoJCbhCOLQSk3u6yTmVxZGklWjJtiOQxMlxiBw39nC4NjrS+wIt4NDktDs
         OX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681816224; x=1684408224;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RyCcUDzMN8yvXUqojP7X4CUbHBSUL6H6PF502SlrCvU=;
        b=CZ0knAdRG8coRNL7ykUq4pjxuQzEBos+LOlmXEVTRgLUVKq1yTnNLpP2G9vMLdp0uZ
         VJuCTpfbmgY3fom+B+YsOgkGZsaaeQaK5lDS2o0z4zyVkuLs0MKGtaLlNTaiImNq5Io1
         iYRAd8sP+9DOadzIvqY7kd9LpDarLtHVxBoqHOeyXlE5X8cy3hLgm8f/B7DqJm1RFd/1
         k8O7DZt54VzDt9VRlka8ma0lM34+H3Tmi/2r964guYuM/0cOe6BbVvQ7vYkg/6+M8pku
         2Z9oHKZu1jaCOs3qMOXSh3qmIoTbgb85VdEGOVQyMF2rLRjprcovlWekB2Ed8oJ2KSmt
         ODwA==
X-Gm-Message-State: AAQBX9dn3nvwPN0M5xNM7rxpoEFfJFPrOA0c+ntH1KDWBwq4VSPNNuOy
        PIM4pUA6bWTNaklQaoV8JAOMQf0EX9rKJaUH
X-Google-Smtp-Source: AKy350bHUnR/QzB6QoZVE/6aIJLeTCNbqOgEcX9Zv8ojMOQSgpBfPrH6bYZJuSuzB//n/sqmC/CKaw==
X-Received: by 2002:a17:906:ae0f:b0:94f:1822:bb33 with SMTP id le15-20020a170906ae0f00b0094f1822bb33mr10064307ejb.22.1681816223698;
        Tue, 18 Apr 2023 04:10:23 -0700 (PDT)
Received: from [127.0.1.1] ([91.230.2.244])
        by smtp.gmail.com with ESMTPSA id n26-20020a170906379a00b0094eef800850sm5954554ejc.204.2023.04.18.04.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 04:10:23 -0700 (PDT)
From:   Benjamin Bara <bbara93@gmail.com>
Subject: [PATCH v5 0/6] mfd: tps6586x: register restart handler
Date:   Tue, 18 Apr 2023 13:09:59 +0200
Message-Id: <20230327-tegra-pmic-reboot-v5-0-ab090e03284d@skidata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAId6PmQC/4WOO27DMBBEr2Kwzhr8SbJd+R6Bi6W8lIiEorEkh
 BiG7h5SVdIk5cNg3sxLZOJAWVwOL8G0hhzSUqF7O4hxxmUiCPfKQkttpNEDFJoY4RHDCEwupQJ
 WDZ33J2XROlF7DjOBY1zGuTUj5kLcggeTD1/72PutsucUocxM+HNCai2N7Y7K9qY/DaDAOWQ8m
 +sUMXwexxSbbA65JH7ux1fTlH99XA1IMKMkMl0/kLLX/BHuWHDXtTOr/ddhq8Npi16rs3d2+O3
 Ytu0bororXk4BAAA=
To:     Wolfram Sang <wsa@kernel.org>, Lee Jones <lee@kernel.org>,
        rafael.j.wysocki@intel.com
Cc:     dmitry.osipenko@collabora.com, peterz@infradead.org,
        jonathanh@nvidia.com, richard.leitner@linux.dev,
        treding@nvidia.com, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-tegra@vger.kernel.org,
        Benjamin Bara <benjamin.bara@skidata.com>,
        stable@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

v4: https://lore.kernel.org/r/20230327-tegra-pmic-reboot-v4-0-b24af219fb47@skidata.com
v3: https://lore.kernel.org/r/20230327-tegra-pmic-reboot-v3-0-3c0ee3567e14@skidata.com
v2: https://lore.kernel.org/all/20230320220345.1463687-1-bbara93@gmail.com/
system_state: https://lore.kernel.org/all/20230320213230.1459532-1-bbara93@gmail.com/
v1: https://lore.kernel.org/all/20230316164703.1157813-1-bbara93@gmail.com/

v5:
- introduce new 3 & 4, therefore 3 -> 5, 4 -> 6
- 3: provide dev to sys_off handler, if it is known
- 4: return NOTIFY_DONE from sys_off_notify, to avoid skipping
- 5: drop Reviewed-by from Dmitry, add poweroff timeout
- 5,6: return notifier value instead of direct errno from handler
- 5,6: use new dev field instead of passing dev as cb_data
- 5,6: increase timeout values based on error observations
- 6: skip unsupported reboot modes in restart handler

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
Benjamin Bara (6):
      kernel/reboot: emergency_restart: set correct system_state
      i2c: core: run atomic i2c xfer when !preemptible
      kernel/reboot: add device to sys_off_handler
      kernel/reboot: sys_off_notify: always return NOTIFY_DONE
      mfd: tps6586x: use devm-based power off handler
      mfd: tps6586x: register restart handler

 drivers/i2c/i2c-core.h |  2 +-
 drivers/mfd/tps6586x.c | 55 ++++++++++++++++++++++++++++++++++++++++++--------
 include/linux/reboot.h |  3 +++
 kernel/reboot.c        | 11 +++++++++-
 4 files changed, 61 insertions(+), 10 deletions(-)
---
base-commit: 197b6b60ae7bc51dd0814953c562833143b292aa
change-id: 20230327-tegra-pmic-reboot-4175ff814a4b

Best regards,
-- 
Benjamin Bara <benjamin.bara@skidata.com>

