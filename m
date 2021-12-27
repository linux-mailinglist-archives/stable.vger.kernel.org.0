Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700474800CB
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236883AbhL0PvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:51:05 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44960 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240597AbhL0Pp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:45:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA1DDB810B9;
        Mon, 27 Dec 2021 15:45:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99EEC36AE7;
        Mon, 27 Dec 2021 15:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619924;
        bh=SCMNHAQcaDNz2EdIj3sDq4hHG/Ev+ZXlBo3gGV8BJys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WWb6FVyMBzallm+ErmmB/dQxETRFvJ4Fo3KjQLh1HA/ZXhTPN+x42XiuDLYMfCxaa
         Bopx735Bqa6zmXJuUGv/uFE2ba/tl2vWtOOi6DACFBWAMXa91/+MyQ7R+3Q+klMNeZ
         DMTx5qpZ2lEFvDfiERzhSrRq58rNq4jiiTPMV5uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik@protonmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 116/128] ASoC: tas2770: Fix setting of high sample rates
Date:   Mon, 27 Dec 2021 16:31:31 +0100
Message-Id: <20211227151335.386068674@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Povišer <povik@protonmail.com>

commit 80d5be1a057e05f01d66e986cfd34d71845e5190 upstream.

Although the codec advertises support for 176.4 and 192 ksps, without
this fix setting those sample rates fails with EINVAL at hw_params time.

Signed-off-by: Martin Povišer <povik@protonmail.com>
Link: https://lore.kernel.org/r/20211206224529.74656-1-povik@protonmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2770.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -291,11 +291,11 @@ static int tas2770_set_samplerate(struct
 		ramp_rate_val = TAS2770_TDM_CFG_REG0_SMP_44_1KHZ |
 				TAS2770_TDM_CFG_REG0_31_88_2_96KHZ;
 		break;
-	case 19200:
+	case 192000:
 		ramp_rate_val = TAS2770_TDM_CFG_REG0_SMP_48KHZ |
 				TAS2770_TDM_CFG_REG0_31_176_4_192KHZ;
 		break;
-	case 17640:
+	case 176400:
 		ramp_rate_val = TAS2770_TDM_CFG_REG0_SMP_44_1KHZ |
 				TAS2770_TDM_CFG_REG0_31_176_4_192KHZ;
 		break;


