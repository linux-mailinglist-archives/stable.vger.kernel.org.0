Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AC9499B07
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379354AbiAXVtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457363AbiAXVlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:41:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E728C07E323;
        Mon, 24 Jan 2022 12:28:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF5A861513;
        Mon, 24 Jan 2022 20:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DD6C340E7;
        Mon, 24 Jan 2022 20:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056105;
        bh=xNtJFVYZOB+Y4RVHodAGBrD4yszD/ahGI9/cxxtSZw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwtqvzaUYDzQX3Qc1VwYu9B5LkHuMObGa6MQ/PeA1zTA/60SejxYyxE5vTSKJkgXi
         N+wV2D8QfbcVmJ5Qt4YX0gg9XhNeykhdKbsTYgc0OHrk5lkWJQY4ez5CdhljpyTVKs
         W2+SAJW7WhwSFLNXUzKoZIS5zboeE9It/QTFClWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 373/846] ASoC: Intel: sof_sdw: fix jack detection on HP Spectre x360 convertible
Date:   Mon, 24 Jan 2022 19:38:10 +0100
Message-Id: <20220124184113.806908790@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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
index f10496206ceed..76759b2099064 100644
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



