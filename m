Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCCC1A91B0
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 05:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393059AbgDOD4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 23:56:13 -0400
Received: from inva021.nxp.com ([92.121.34.21]:46510 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733225AbgDOD4M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Apr 2020 23:56:12 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A78A6200716;
        Wed, 15 Apr 2020 05:56:10 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E40FB20071C;
        Wed, 15 Apr 2020 05:56:07 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 36D8E40293;
        Wed, 15 Apr 2020 11:56:04 +0800 (SGT)
From:   Yangbo Lu <yangbo.lu@nxp.com>
To:     stable@vger.kernel.org
Cc:     Yangbo Lu <yangbo.lu@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Daniel Walker <danielwa@cisco.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [v5.5] Fix up eSDHC issue on P2020
Date:   Wed, 15 Apr 2020 11:52:11 +0800
Message-Id: <20200415035212.19139-1-yangbo.lu@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The upstream commit broke P2020 eSDHC.
fe0acab mmc: sdhci-of-esdhc: fix P2020 errata handling

While the issue was fixed by later commit.
2aa3d82 mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller versions

The commit fe0acab had been applied to stable kernel 5.5, 5.4,
4.19, 4.14, 4.9, and 4.4 without that fix-up.

To fix up P2020 eSDHC on the stable kernels, backport the fix-up 2aa3d82
kernel 5.4 and 5.5.

Please help to revert fe0acab on 4.19, 4.14, 4.9 and 4.4, since there are
many conflicts to cherry-pick the fix-up, and fe0acab is actually not strongly
required for handling errata which is hardly triggered.

The email thread for the issue discussion.
https://www.spinics.net/lists/stable/msg375823.html

Yangbo Lu (4):
  mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller
    versions
  mmc: sdhci-of-esdhc: fix clock setting for different controller
    versions
  mmc: sdhci-of-esdhc: fix transfer mode register reading
  mmc: sdhci-of-esdhc: fix serious issue clock is always disabled

 drivers/mmc/host/sdhci-of-esdhc.c | 174 +++++++++++++++++++++++++-------------
 1 file changed, 114 insertions(+), 60 deletions(-)

-- 
2.7.4

