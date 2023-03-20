Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228866C181F
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjCTPUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbjCTPUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:20:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885D42E822
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:14:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 015D7B80EE1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504DDC4339B;
        Mon, 20 Mar 2023 15:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325281;
        bh=QucI+lPLHMALOt2SRM2/N/YsxLotuoqqqeylfsHIpx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jT/sF11uMJvMVkaOxqaOtVJ8jzpIfC+HkeY66GV5y4uy+DwRmVtcLFR4NCFZYBVdd
         p2orttBOXUm2cAuJK67QAW65zA68ClDKgj39mAx43IgycO4mQlZUz9LEr0Q0QL7tlU
         UhoHzA244D+WdqDDm4TR0kZtWqipX3odoIs72rfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Gongjun Song <gongjun.song@intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 086/115] ALSA: hda: intel-dsp-config: add MTL PCI id
Date:   Mon, 20 Mar 2023 15:54:58 +0100
Message-Id: <20230320145453.024789535@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bard Liao <yung-chuan.liao@linux.intel.com>

commit bbdf904b13a62bb8b1272d92a7dde082dff86fbb upstream.

Use SOF as default audio driver.

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Gongjun Song <gongjun.song@intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230306074101.3906707-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/intel-dsp-config.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -376,6 +376,15 @@ static const struct config_entry config_
 	},
 #endif
 
+/* Meteor Lake */
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_METEORLAKE)
+	/* Meteorlake-P */
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = 0x7e28,
+	},
+#endif
+
 };
 
 static const struct config_entry *snd_intel_dsp_find_config


