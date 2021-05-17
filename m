Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DA7382F70
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238872AbhEQOQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:16:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239019AbhEQOOo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:14:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1B906124C;
        Mon, 17 May 2021 14:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260533;
        bh=09Pth0TM82Lv0BE4cEgiWAOEpj5Bx/lSMimuNrorsX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tX7RbHJ8C58nT2AQF7+SwtLtpoEpPHT0QFd40yOupL3JlKHhj96x4qiM15rFHqot1
         qo9Rs9FXXnon0dZpBDSyueJdQJVGS0lMty2WRup9CCCg0g2U9bzjb2SLkUJKe0+IaS
         66ux+6oUb1HTzZKu3yjhkPBvFwzuEvefXv4q2fVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ward <david.ward@gatech.edu>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 124/363] ASoC: rt286: Make RT286_SET_GPIO_* readable and writable
Date:   Mon, 17 May 2021 15:59:50 +0200
Message-Id: <20210517140306.813445561@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ward <david.ward@gatech.edu>

[ Upstream commit cd8499d5c03ba260e3191e90236d0e5f6b147563 ]

The GPIO configuration cannot be applied if the registers are inaccessible.
This prevented the headset mic from working on the Dell XPS 13 9343.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=114171
Signed-off-by: David Ward <david.ward@gatech.edu>
Link: https://lore.kernel.org/r/20210418134658.4333-5-david.ward@gatech.edu
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt286.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/rt286.c b/sound/soc/codecs/rt286.c
index 2f18f5114f7e..ff23a7d4d2ac 100644
--- a/sound/soc/codecs/rt286.c
+++ b/sound/soc/codecs/rt286.c
@@ -171,6 +171,9 @@ static bool rt286_readable_register(struct device *dev, unsigned int reg)
 	case RT286_PROC_COEF:
 	case RT286_SET_AMP_GAIN_ADC_IN1:
 	case RT286_SET_AMP_GAIN_ADC_IN2:
+	case RT286_SET_GPIO_MASK:
+	case RT286_SET_GPIO_DIRECTION:
+	case RT286_SET_GPIO_DATA:
 	case RT286_SET_POWER(RT286_DAC_OUT1):
 	case RT286_SET_POWER(RT286_DAC_OUT2):
 	case RT286_SET_POWER(RT286_ADC_IN1):
-- 
2.30.2



