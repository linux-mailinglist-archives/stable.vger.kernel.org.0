Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F513318E65
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhBKP0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:26:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:50496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230027AbhBKPJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:09:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9F1D64ECA;
        Thu, 11 Feb 2021 15:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055826;
        bh=chsoQVgOMFMKf0kMZfwuHu6gkK472skam4SXRssOxjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mlZAjbqZ1fISw3FPNpwzPjvjVcjYZR2sZ6na8MZAmfmesFM7T1CKIlj9cz+9wacXh
         J4rzGk5RcV/p/e5Qz0o+Ngnp2bAwjzzTvzFlVJso62EXhc11JcjvTJItW1wYru45ta
         sxQ7WOb/AH+efMSTWjQ1IjuDYZrUxFplOG1C+2hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Schulman <james.schulman@cirrus.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/54] ASoC: wm_adsp: Fix control name parsing for multi-fw
Date:   Thu, 11 Feb 2021 16:02:05 +0100
Message-Id: <20210211150153.806525427@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Schulman <james.schulman@cirrus.com>

[ Upstream commit a8939f2e138e418c2b059056ff5b501eaf2eae54 ]

When switching between firmware types, the wrong control
can be selected when requesting control in kernel API.
Use the currently selected DSP firwmare type to select
the proper mixer control.

Signed-off-by: James Schulman <james.schulman@cirrus.com>
Acked-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20210115201105.14075-1-james.schulman@cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index dec8716aa8ef5..985b2dcecf138 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -2031,11 +2031,14 @@ static struct wm_coeff_ctl *wm_adsp_get_ctl(struct wm_adsp *dsp,
 					     unsigned int alg)
 {
 	struct wm_coeff_ctl *pos, *rslt = NULL;
+	const char *fw_txt = wm_adsp_fw_text[dsp->fw];
 
 	list_for_each_entry(pos, &dsp->ctl_list, list) {
 		if (!pos->subname)
 			continue;
 		if (strncmp(pos->subname, name, pos->subname_len) == 0 &&
+		    strncmp(pos->fw_name, fw_txt,
+			    SNDRV_CTL_ELEM_ID_NAME_MAXLEN) == 0 &&
 				pos->alg_region.alg == alg &&
 				pos->alg_region.type == type) {
 			rslt = pos;
-- 
2.27.0



