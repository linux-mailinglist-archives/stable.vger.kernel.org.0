Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33F3505673
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241799AbiDRNfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244915AbiDRNbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:31:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCAA10DA;
        Mon, 18 Apr 2022 05:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5485C612BB;
        Mon, 18 Apr 2022 12:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31830C385A1;
        Mon, 18 Apr 2022 12:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286642;
        bh=gXO1PiuaPxfHEKD3y/fnagc/Wbe/+V8iujq2vnaYE1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfM5DJPko9IxJlSAjRJ2trl0Pg4r9SUmv8dRHGvYjiq1MCkeZ/plpFs35ts02OhO9
         wasjIcIgnAAXMXWL31c/vJhjUf1igeYyl0jYEOt1NcQoGZsmI4IUZpI+4dezP816rJ
         1fUpk2QC79dSCR3vJdHLBJLfLvbx83qgpQje+q/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 198/284] ASoC: topology: Allow TLV control to be either read or write
Date:   Mon, 18 Apr 2022 14:12:59 +0200
Message-Id: <20220418121217.358568080@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -599,7 +599,8 @@ static int soc_tplg_kcontrol_bind_io(str
 
 	if (hdr->ops.info == SND_SOC_TPLG_CTL_BYTES
 		&& k->iface & SNDRV_CTL_ELEM_IFACE_MIXER
-		&& k->access & SNDRV_CTL_ELEM_ACCESS_TLV_READWRITE
+		&& (k->access & SNDRV_CTL_ELEM_ACCESS_TLV_READ
+		    || k->access & SNDRV_CTL_ELEM_ACCESS_TLV_WRITE)
 		&& k->access & SNDRV_CTL_ELEM_ACCESS_TLV_CALLBACK) {
 		struct soc_bytes_ext *sbe;
 		struct snd_soc_tplg_bytes_control *be;


