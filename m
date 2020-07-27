Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7980B22F15F
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731289AbgG0OSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:18:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731285AbgG0OSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:18:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 432A62070A;
        Mon, 27 Jul 2020 14:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859523;
        bh=/DH+aznXkv1qnF4v0DOaOA0IRaamledIRcwzbyJV4iA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPcwx6L7nnZ7C/QcFmxb0NfF48VoSnBEN4K+AQ7qnetNccYH3P5KvSjZoIJo/vQQU
         LwaaJQHJTwC587GiCCPxEpFJKIg2ANkBpCXZN1cZUlY+UkJYGBNSeYNXRBujVg3R8B
         wYE72PjAP6AftZNE9FMud388doUsftuUs+BRjDMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 135/138] ASoC: topology: fix tlvs in error handling for widget_dmixer
Date:   Mon, 27 Jul 2020 16:05:30 +0200
Message-Id: <20200727134932.162428254@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

commit 8edac489e7c3fce44208373bb3e7b5835a672c66 upstream.

we need to free all allocated tlvs, not just the one allocated in
the loop before releasing kcontrols - other the tlvs references will
leak.

Fixes: 9f90af3a995298 ('ASoC: topology: Consolidate and fix asoc_tplg_dapm_widget_*_create flow')
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200707203749.113883-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/soc-topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1394,7 +1394,6 @@ static struct snd_kcontrol_new *soc_tplg
 		if (err < 0) {
 			dev_err(tplg->dev, "ASoC: failed to init %s\n",
 				mc->hdr.name);
-			soc_tplg_free_tlv(tplg, &kc[i]);
 			goto err_sm;
 		}
 	}
@@ -1402,6 +1401,7 @@ static struct snd_kcontrol_new *soc_tplg
 
 err_sm:
 	for (; i >= 0; i--) {
+		soc_tplg_free_tlv(tplg, &kc[i]);
 		sm = (struct soc_mixer_control *)kc[i].private_value;
 		kfree(sm);
 		kfree(kc[i].name);


