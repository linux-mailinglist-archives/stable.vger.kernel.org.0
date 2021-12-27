Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2692848000E
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238570AbhL0Pmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238621AbhL0PlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:41:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14C1C079797;
        Mon, 27 Dec 2021 07:39:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FB9C61126;
        Mon, 27 Dec 2021 15:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 792B6C36AEA;
        Mon, 27 Dec 2021 15:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619569;
        bh=SCMNHAQcaDNz2EdIj3sDq4hHG/Ev+ZXlBo3gGV8BJys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mY2mZNh6quuBMHuqqVTgLXWBvWm/TQyeWW4Nk3zyuvFwpooCJEpMOsLhWAUmTLfOE
         RhLJkL01yqDN1htkRRdaYqiAqajs+bOggMgcL7luBYLwrnpDA1kWYe0iLuW8dG7cv7
         YXaovoJjf3q3Dhlh4zHeZYigI0L2f7CuLpyWSQiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Povi=C5=A1er?= <povik@protonmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 68/76] ASoC: tas2770: Fix setting of high sample rates
Date:   Mon, 27 Dec 2021 16:31:23 +0100
Message-Id: <20211227151327.038123659@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151324.694661623@linuxfoundation.org>
References: <20211227151324.694661623@linuxfoundation.org>
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


