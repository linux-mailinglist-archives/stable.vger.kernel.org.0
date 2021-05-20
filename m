Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C4538ABA9
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241212AbhETL0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:26:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241388AbhETLY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:24:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BBDD61D95;
        Thu, 20 May 2021 10:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505553;
        bh=aZycJ9fD9yz5SFROnkaxyLybEL8QdjyL7OB0T7Z0j38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mA7vfruGHkf6vy1tIXE+11jbiksU0pP2z56KOFHcZjl4b7OwNeYoshUnnq0lmwcj2
         iOjbDATWaq1Yz6hp2W5QiXvts3FMNcWtzIjIA8XmkchGw14rfvE04ZQRziq7mt/5X6
         aGpLXyH5lnIpqDnR70QF7ZHKMcaocFT5XfNfiYOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ward <david.ward@gatech.edu>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 153/190] ASoC: rt286: Make RT286_SET_GPIO_* readable and writable
Date:   Thu, 20 May 2021 11:23:37 +0200
Message-Id: <20210520092107.232304097@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
index 63ed5b38b11f..146099ec8570 100644
--- a/sound/soc/codecs/rt286.c
+++ b/sound/soc/codecs/rt286.c
@@ -174,6 +174,9 @@ static bool rt286_readable_register(struct device *dev, unsigned int reg)
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



