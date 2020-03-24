Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AEAF191889
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgCXSHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:07:46 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41988 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbgCXSHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:07:45 -0400
Received: by mail-lj1-f194.google.com with SMTP id q19so19576367ljp.9
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qPTlvoqZxYaSsWLUlKp85khmY6NurtsqQgDSkrG+7e0=;
        b=Bf1+yGdfLrsGJ6+JaogwSOUV0Vi7WwKZ+Cb5iYqxq+c0uY2CpetQ2VNbyVM+M8sWsK
         zL25zQ+xc7lTghUek8g6mbW/DmIGmav25OcsQfcV5SmnUiNK5x65gEa8twh29GqzUact
         jZxA6eyH0f2d6NVZKxi9GRRBahd0SC3JDEvZHDidgPV4/uZIp6GaY0kqVGYmDQRKe69F
         McC5nUKNjhXo/saS0Dl3uHzLSUGdkRbE4naEAnbQTcamZXkueeNRI5bzbpkgCsFFVWYu
         FBp9JmCCBqOXtA98yBgB/btHPGrO7C8vAlatAXtd131puXJtWynZF7WmA26mmtYpGp5F
         NhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qPTlvoqZxYaSsWLUlKp85khmY6NurtsqQgDSkrG+7e0=;
        b=QLMZ7uNachwDfYCiWFldc2ebIvWgBSJb4XNikRcfMN0HIluyjbLATP1VHJDW6lTe73
         potKZmZltlo5tB6Udncf6l/c362Dnk2/0E0lEVGBOk8jO3alwoLWDmICoYb5oPBdtcBv
         5UQrSQ81cV+3QQH/mi8GAUx6S8UvVgIY+5iED9LpZmkFWYl1jSmLEyY0FMKyCNKufc6t
         3zgKEEkZT3puF4ayzuhzgCfczeSX5fXzDRhkLeGMchFBT8h5nJ4dZYe5e6sUj0INXMFS
         slXI8GdZMkvL9oIN6oFg8DuClMN7/UEOWL2s5dgI/rWdE0r+lMeBED2SNk7XmIXgiUv5
         luIw==
X-Gm-Message-State: ANhLgQ3nMlh4vYeC2fGyRqz+QTO3ZmjRQEHFK/2XHLaN41vDopjV77vo
        sW8Q1ngogVMojHEszLRpmeT9LQ==
X-Google-Smtp-Source: ADFU+vsmiqtQhBKMKWssgrrK/lWoNR93iW5uPXpAPArpqGQeeABNK4dyIrGfgUB3Yob+0jpdRC3cVw==
X-Received: by 2002:a2e:8608:: with SMTP id a8mr17888175lji.59.1585073262792;
        Tue, 24 Mar 2020 11:07:42 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id 3sm12113809ljq.18.2020.03.24.11.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:07:42 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 5.4.28 0/5] mmc: Fix some busy detect problems
Date:   Tue, 24 Mar 2020 19:07:33 +0100
Message-Id: <20200324180738.28892-1-ulf.hansson@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This series provides a couple of manually backported mmc changes that fixes some
busy detect issues, for a couple of mmc host drivers (sdhci-tegra|omap).

Ulf Hansson (5):
  mmc: core: Allow host controllers to require R1B for CMD6
  mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard
  mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command
  mmc: sdhci-omap: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY
  mmc: sdhci-tegra: Fix busy detection by enabling MMC_CAP_NEED_RSP_BUSY

 drivers/mmc/core/core.c        | 5 ++++-
 drivers/mmc/core/mmc.c         | 7 +++++--
 drivers/mmc/core/mmc_ops.c     | 8 +++++---
 drivers/mmc/host/sdhci-omap.c  | 3 +++
 drivers/mmc/host/sdhci-tegra.c | 3 +++
 include/linux/mmc/host.h       | 1 +
 6 files changed, 21 insertions(+), 6 deletions(-)

-- 
2.20.1

