Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DFC501384
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348354AbiDNOEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346575AbiDNN5m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:57:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56415EBF6;
        Thu, 14 Apr 2022 06:46:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AB3561D9B;
        Thu, 14 Apr 2022 13:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB7BC385A5;
        Thu, 14 Apr 2022 13:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944006;
        bh=y8qTDUU89JfGa8eZGV063SlRAFzrEvcF+jAExHfm8OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1SCN3wIhVysYp4f1/RWH+ffacaui8A8D+kJFjQCizoxK/a8N9t72D3GAA3Ez5Ib7T
         Q7SgZmThPqvoWhklGIBpuKlxzYItlRsLIbVpvL9OXxlOOWaX1zcazbggcxHeuHXCmd
         TG5jZ4zedHk7OoG3acBh8Fqnyw1sNcCNYVBNu+sQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 361/475] ASoC: topology: Allow TLV control to be either read or write
Date:   Thu, 14 Apr 2022 15:12:26 +0200
Message-Id: <20220414110905.184485001@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

commit feb00b736af64875560f371fe7f58b0b7f239046 upstream.

There is no reason to force readwrite access on TLV controls. It can be
either read, write or both. This is further evidenced in code where it
performs following checks:
                if ((k->access & SNDRV_CTL_ELEM_ACCESS_TLV_READ) && !sbe->get)
                        return -EINVAL;
                if ((k->access & SNDRV_CTL_ELEM_ACCESS_TLV_WRITE) && !sbe->put)
                        return -EINVAL;

Fixes: 1a3232d2f61d ("ASoC: topology: Add support for TLV bytes controls")
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20220112170030.569712-3-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-topology.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -587,7 +587,8 @@ static int soc_tplg_kcontrol_bind_io(str
 
 	if (le32_to_cpu(hdr->ops.info) == SND_SOC_TPLG_CTL_BYTES
 		&& k->iface & SNDRV_CTL_ELEM_IFACE_MIXER
-		&& k->access & SNDRV_CTL_ELEM_ACCESS_TLV_READWRITE
+		&& (k->access & SNDRV_CTL_ELEM_ACCESS_TLV_READ
+		    || k->access & SNDRV_CTL_ELEM_ACCESS_TLV_WRITE)
 		&& k->access & SNDRV_CTL_ELEM_ACCESS_TLV_CALLBACK) {
 		struct soc_bytes_ext *sbe;
 		struct snd_soc_tplg_bytes_control *be;


