Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D89191872
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgCXSHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:07:00 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37544 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbgCXSHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:07:00 -0400
Received: by mail-lf1-f68.google.com with SMTP id j11so14018715lfg.4
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qPTlvoqZxYaSsWLUlKp85khmY6NurtsqQgDSkrG+7e0=;
        b=np91gh8hjJAaBidIsLaM1dWuzBXCsej6CAy8RMRLfzJcWiWFAoexMfu4rojYJCC2A7
         IS4ORjGcZpz/KvXw2Vcl0fbEppZYt18EOz/z+SXIWyO3notIVue8doGE/yBPu3GOsUjl
         ptEEgcjULenPsEPWRu43f/bjXFMLnA5lJ4szYmNGlcDK1WmhcUOhrwODkcXgn7r5c/m2
         cm/GN61UU0b+YfyyYVG9jcbmlFfsqbpCoCiH/AetSaTAERPunAeb+NBzxsgZVLV98Xav
         Z/IAQlNWyZ5JUftSc3JYC7h77nQLny/QX8MEluiKUvDeuIeksYq5Rzjd/Ao7WP/1y/ft
         AlCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qPTlvoqZxYaSsWLUlKp85khmY6NurtsqQgDSkrG+7e0=;
        b=oPNIQD0sU93a8kJypENllHm8XTWz3lKpq1P6jBd+2MGonigXc06VOK/mqPF7U7fsSL
         JMRIANNEQXP/GXREaEHQu7/YH/IqAJOIvhwaqw+w8y9sbhWLQZe7ouflJkFy2rtTmicm
         UdKgWlwmVZc/V55M8+b0s+4xQTZ/4ggVpho11FNuO2g3E+puY73NCm2d8laG0pMtp9Bg
         aAaVg2dUJ61uPTtzHfeVE7GMJC5+nTLL93seYqOavXpZgtaPQul/6nzsnCD9wBdWBh1h
         uSEQDJjAJXCr33oLNWnaI667Fhrw2eZiPIkUzreZekVclsphPueX6Pl6dMTegEP+iqej
         kifw==
X-Gm-Message-State: ANhLgQ2b6OqiDZSaqG8DIjiTQNvbR7Am+KaRXK0n1ORdxlBvtZ4ZFLI/
        sdwvWV8TdRH6otvtINTWNIDvhQ==
X-Google-Smtp-Source: ADFU+vsd4cAjHmoXtpbET1XFoYaanEWoDiKCtHuxCImvsy1qeLV3iq97fiOrDWX8IA1UZK9qKV+Rmw==
X-Received: by 2002:a19:c781:: with SMTP id x123mr13177191lff.140.1585073218245;
        Tue, 24 Mar 2020 11:06:58 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id 203sm10519660ljf.65.2020.03.24.11.06.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:06:57 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 5.5.12 0/5] mmc: Fix some busy detect problems
Date:   Tue, 24 Mar 2020 19:06:45 +0100
Message-Id: <20200324180650.28819-1-ulf.hansson@linaro.org>
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

