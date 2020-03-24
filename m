Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7070C191895
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 19:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgCXSIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 14:08:06 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41234 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbgCXSIG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 14:08:06 -0400
Received: by mail-lf1-f68.google.com with SMTP id z23so2339518lfh.8
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 11:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qPTlvoqZxYaSsWLUlKp85khmY6NurtsqQgDSkrG+7e0=;
        b=I+JGXSE88YxvsPtUKlKF1MiO+8fi4bFqL2WOW/yPYvRT9cwEQS/37Jp5hl/fgqFuDE
         UHodP3Xk1fMPjkkc+Yi5H571MGWc3aQc7T2L6MCiz5Nv1Z/M7XVm4Kfu6gxEc8gO07X1
         ny1uaJlnI+jh06WKE/D5LPTI782s2+FJjqOpjfRSXYuSSWEgDHqjOuG4HEFyZt4Eb5ba
         2VC5qBgCGmp9T57tVzVu9lSvkp9DqWzArXOpoEAxuLlShW52X7wgpjjUleBqVzS4FV4f
         KyXUrn86dd2Y7dbFzGed6V9PcIURvkf74tMmCoULwyd2XgVtt9mWtdjU8sSmRcry0Bhv
         muFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qPTlvoqZxYaSsWLUlKp85khmY6NurtsqQgDSkrG+7e0=;
        b=rE3jt2MPMCGNjVXrqfMSvfuCekCDG8cFjQc9y7lWOveCmZXaSbuQMOTd52d/X4D0e1
         o6vNfjJxrqP+tleGH1lwp5wBvq7bR4O6f+1Phw1MCd8cKqT1IheICOAs9skCgmMAEklh
         lCZlaXKVoEI+xQXIgpeat/OhbDbzp1DuB/X24iq/dvuW6f3CLU9w05uO00Huo+4N+UjS
         11HkVe2LhZf6g2VulyIz/AB52QBRqGb+/lqt4+vQJs+8wvz7akeCc/JLlo897PMNceYc
         2DwLxh+CI0BTgVkTFNtKdOIZ+m/MEt5wqUiJ6M/dpyHSWs6sdkOZlmd98T78IFdf+fkH
         rwpg==
X-Gm-Message-State: ANhLgQ1xu9UsFfCDBHsKv2shHEDWEYFYtQCQKJqik1skvdFmsCUvJn7t
        9K+5mU1NkOELgfBIP57o0YLT1w==
X-Google-Smtp-Source: ADFU+vvwI3tniNorQxIU8Y/4s10YAbQxIuBl20Dl6KNeWPiFC7CtWz4MoGatq0qFp+/aAPq7i3z+0w==
X-Received: by 2002:a19:be94:: with SMTP id o142mr10246761lff.13.1585073283419;
        Tue, 24 Mar 2020 11:08:03 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-210.NA.cust.bahnhof.se. [158.174.22.210])
        by smtp.gmail.com with ESMTPSA id s10sm11029858ljp.87.2020.03.24.11.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 11:08:02 -0700 (PDT)
From:   Ulf Hansson <ulf.hansson@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Faiz Abbas <faiz_abbas@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 4.19.113 0/5] mmc: Fix some busy detect problems
Date:   Tue, 24 Mar 2020 19:07:55 +0100
Message-Id: <20200324180800.28953-1-ulf.hansson@linaro.org>
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

