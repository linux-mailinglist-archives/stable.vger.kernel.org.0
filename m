Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5998F328BB9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240321AbhCASin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:45028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240100AbhCASdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:33:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A11FE64F90;
        Mon,  1 Mar 2021 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618862;
        bh=v7YajkXsSnf4/6yAXnpU/OS2a1HUNhEqLmCYNCnVszY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2UoA52pXOteqAPXNqoUvUzMbvaU1o+Y/pjG0JfFnQyacALVePa8ZvihmQSL2CnF2
         Vvz6kvOLR9Q24jhC+RPMkvkb+usgW+ogvwrE2RdgedEErSXEGxKCm7o8Zy39IkAG4f
         r6gE4OgM6GQkATBvhMfoAhzMj/+uSC6KmyKFq66c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <bard.liao@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 245/663] ASoC: SOF: sof-pci-dev: add missing Up-Extreme quirk
Date:   Mon,  1 Mar 2021 17:08:13 +0100
Message-Id: <20210301161153.940281730@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit bd8036eb15263a720b8f846861c180b27d050a09 ]

The UpExtreme board supports the community key and was missed in
previous contributions. Add it to make sure the open firmware is
picked by default without needing a symlink on the target.

Fixes: 46207ca24545 ('ASoC: SOF: pci: change the default firmware path when the community key is used')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <bard.liao@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20210208231853.58761-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-pci-dev.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/sof/sof-pci-dev.c b/sound/soc/sof/sof-pci-dev.c
index 8f62e3487dc18..75657a25dbc05 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -65,6 +65,13 @@ static const struct dmi_system_id community_key_platforms[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "UP-APL01"),
 		}
 	},
+	{
+		.ident = "Up Extreme",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "AAEON"),
+			DMI_MATCH(DMI_BOARD_NAME, "UP-WHL01"),
+		}
+	},
 	{
 		.ident = "Google Chromebooks",
 		.matches = {
-- 
2.27.0



