Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3683A73B9
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 04:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhFOC0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 22:26:01 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:12620 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhFOCZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 22:25:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623723827; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=2Mxmy8FQE/u8N8PCwEBPxghlnJW8fjvbaM/3RXM7hX8=; b=gOaEyKNSA4PsR5/z2lt3gShsegH33Iff927fsBn2z/M0RFw9VfFbnPHT/SKG4yv6LKUxuOf4
 EjPXUoVmHDUvAeeeQ25FmShsfhlM+Td7FrMmOYInRRUXE+pjnR4O7bmAp9/uHFdX/d9RWU3b
 zsn+oGJjxXoYZAhkg2aRgkf/mL8=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 60c80ea0b6ccaab753d5c659 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 02:21:20
 GMT
Sender: sidgup=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 00D9FC4338A; Tue, 15 Jun 2021 02:21:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from sidgup-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: sidgup)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 04D6DC433F1;
        Tue, 15 Jun 2021 02:21:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 04D6DC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=sidgup@codeaurora.org
From:   Siddharth Gupta <sidgup@codeaurora.org>
To:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org
Cc:     Siddharth Gupta <sidgup@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: [PATCH v3 0/4] remoteproc: core: Fixes for rproc cdev and add
Date:   Mon, 14 Jun 2021 19:21:07 -0700
Message-Id: <1623723671-5517-1-git-send-email-sidgup@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch series contains stability fixes and error handling for remoteproc.

The changes included in this series do the following:
Patch 1: Fixes the creation of the rproc character device.
Patch 2: Validates rproc as the first step of rproc_add().
Patch 3: Fixes the rproc cdev remove and the order of dev_del() and cdev_del().
Patch 4: Adds error handling in rproc_add().

v2 -> v3:
- Removed extra file that got added by mistake.

v1 -> v2:
- Added extra patch which addresses Bjorn's comments on patch 3
  from v1.
- Fixed commit text for patch 2 (s/calling making/making).

Siddharth Gupta (4):
  remoteproc: core: Move cdev add before device add
  remoteproc: core: Move validate before device add
  remoteproc: core: Fix cdev remove and rproc del
  remoteproc: core: Cleanup device in case of failure

 drivers/remoteproc/remoteproc_cdev.c |  2 +-
 drivers/remoteproc/remoteproc_core.c | 27 ++++++++++++++++++---------
 2 files changed, 19 insertions(+), 10 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

