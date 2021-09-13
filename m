Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAA1408D73
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241100AbhIMN0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:26:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241053AbhIMNWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:22:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA1D8610A2;
        Mon, 13 Sep 2021 13:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539267;
        bh=lZD0BniTpdl9jlOZ+3+3blHwVlCTYyDX9P6LDRMFOEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snClxe8AvTSYCVdn03xorEApA9zdQi63tAsthBxq3DqUvpfkGJn7Or5iyMuIYbkHM
         E8BPBetjD+iSts76XAmDLr45JqYMomcRn9/U4Fxa1oqPztHz1sFptbOfIF9UHh3SFl
         v3aTOBT0jJDtpfYSgKDsiwe1ByAdTbmxcBTaeY0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Lukasz Majczak <lma@semihalf.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 105/144] ASoC: Intel: Skylake: Leave data as is when invoking TLV IPCs
Date:   Mon, 13 Sep 2021 15:14:46 +0200
Message-Id: <20210913131051.453818594@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 126b3422adc80f29d2129db7f61e0113a8a526c6 ]

Advancing pointer initially fixed issue for some users but caused
regression for others. Leave data as it to make it easier for end users
to adjust their topology files if needed.

Fixes: a8cd7066f042 ("ASoC: Intel: Skylake: Strip T and L from TLV IPCs")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Tested-by: Lukasz Majczak <lma@semihalf.com>
Link: https://lore.kernel.org/r/20210818075742.1515155-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl-topology.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/sound/soc/intel/skylake/skl-topology.c b/sound/soc/intel/skylake/skl-topology.c
index 1940b17f27ef..104c73eb9769 100644
--- a/sound/soc/intel/skylake/skl-topology.c
+++ b/sound/soc/intel/skylake/skl-topology.c
@@ -1463,12 +1463,6 @@ static int skl_tplg_tlv_control_set(struct snd_kcontrol *kcontrol,
 	struct skl_dev *skl = get_skl_ctx(w->dapm->dev);
 
 	if (ac->params) {
-		/*
-		 * Widget data is expected to be stripped of T and L
-		 */
-		size -= 2 * sizeof(unsigned int);
-		data += 2;
-
 		if (size > ac->max)
 			return -EINVAL;
 		ac->size = size;
-- 
2.30.2



