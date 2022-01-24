Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5E44998A5
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347465AbiAXV2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:28:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36596 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377051AbiAXVQ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:16:59 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4992BB8122A;
        Mon, 24 Jan 2022 21:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DB6C340E5;
        Mon, 24 Jan 2022 21:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059015;
        bh=35bdOZwEX15/CDl0eOhUKLqgXQk8j5PQ12jCuwyOO2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dA4PRiW/DSxMKVKaRh7HCQF6/MPhJtB0LT3C9sIPedbG1JM0ct5Q41d8mI4Y6jRmU
         lBvsba1nehzw3hAeb2lJLkZdJidFHBF2mwASTlvvu09ligVhrcDoKVOCb8HrRJfSrX
         dL/1Sm7ZfQdJMt3PsUn61peKdH9qY0BdIIpSWCS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0444/1039] ASoC: Intel: sof_sdw: fix jack detection on HP Spectre x360 convertible
Date:   Mon, 24 Jan 2022 19:37:13 +0100
Message-Id: <20220124184140.216493992@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 0527b19fa4f390a6054612e1fa1dd4f8efc96739 ]

Tests on device show the JD2 mode does not work at all, the 'Headphone
Jack' and 'Headset Mic Jack' are shown as 'on' always.

JD1 seems to be the better option, with at least a change between the
two cases.

Jack not plugged-in:
[root@fedora ~]# amixer -Dhw:0 cget numid=12
numid=12,iface=CARD,name='Headphone Jack'
  ; type=BOOLEAN,access=r-------,values=1
  : values=off
[root@fedora ~]# amixer -Dhw:0 cget numid=13
numid=13,iface=CARD,name='Headset Mic Jack'
  ; type=BOOLEAN,access=r-------,values=1
  : values=off

Jack plugged-in:
[root@fedora ~]# amixer -Dhw:0 cget numid=13
numid=13,iface=CARD,name='Headset Mic Jack'
  ; type=BOOLEAN,access=r-------,values=1
  : values=on
[root@fedora ~]# amixer -Dhw:0 cget numid=13
numid=13,iface=CARD,name='Headset Mic Jack'
  ; type=BOOLEAN,access=r-------,values=1
  : values=on

The 'Headset Mic Jack' is updated with a delay which seems normal with
additional calibration needed.

Fixes: d92e279dee56 ('ASoC: Intel: sof_sdw: add quirk for HP Spectre x360 convertible')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20211027021824.24776-3-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 77219c3f8766c..54eefaff62a7e 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -188,7 +188,7 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 		},
 		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
 					SOF_SDW_PCH_DMIC |
-					RT711_JD2),
+					RT711_JD1),
 	},
 	{
 		/* NUC15 'Bishop County' LAPBC510 and LAPBC710 skews */
-- 
2.34.1



