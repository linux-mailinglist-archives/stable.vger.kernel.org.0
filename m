Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72616674F1
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbjALOQF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235542AbjALOPY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:15:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA475564C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:07:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5049B81DCC
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00330C433EF;
        Thu, 12 Jan 2023 14:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532451;
        bh=LVl4985XGkw23i2N8Od/Lg72vxVAbqRGPb1NbBOKMW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PG/8CCeqnQS2UMwZ0mPDjycrQrC86lBfnP8aoJAPJQGsZna3GJmYislBhoRe68Vd+
         vIUu6m2IMTZY+gi5YwFL/w5SsS29E/FwZGo2u8eUnVXolr3QC0HLo56UymrblFfS+r
         BhH5NTMv1+7kPnQEGBE1YiYYMdruESnDQjrTg0bA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baisong Zhong <zhongbaisong@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/783] ALSA: pcm: fix undefined behavior in bit shift for SNDRV_PCM_RATE_KNOT
Date:   Thu, 12 Jan 2023 14:48:01 +0100
Message-Id: <20230112135531.975484954@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baisong Zhong <zhongbaisong@huawei.com>

[ Upstream commit b5172e62458f8e6ff359e5f096044a488db90ac5 ]

Shifting signed 32-bit value by 31 bits is undefined, so changing
significant bit to unsigned. The UBSAN warning calltrace like below:

UBSAN: shift-out-of-bounds in sound/core/pcm_native.c:2676:21
left shift of 1 by 31 places cannot be represented in type 'int'
...
Call Trace:
 <TASK>
 dump_stack_lvl+0x8d/0xcf
 ubsan_epilogue+0xa/0x44
 __ubsan_handle_shift_out_of_bounds+0x1e7/0x208
 snd_pcm_open_substream+0x9f0/0xa90
 snd_pcm_oss_open.part.26+0x313/0x670
 snd_pcm_oss_open+0x30/0x40
 soundcore_open+0x18b/0x2e0
 chrdev_open+0xe2/0x270
 do_dentry_open+0x2f7/0x620
 path_openat+0xd66/0xe70
 do_filp_open+0xe3/0x170
 do_sys_openat2+0x357/0x4a0
 do_sys_open+0x87/0xd0
 do_syscall_64+0x34/0x80

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
Link: https://lore.kernel.org/r/20221121110044.3115686-1-zhongbaisong@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/pcm.h | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 5ffc2efedd9f..6554a9f71c62 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -106,24 +106,24 @@ struct snd_pcm_ops {
 #define SNDRV_PCM_POS_XRUN		((snd_pcm_uframes_t)-1)
 
 /* If you change this don't forget to change rates[] table in pcm_native.c */
-#define SNDRV_PCM_RATE_5512		(1<<0)		/* 5512Hz */
-#define SNDRV_PCM_RATE_8000		(1<<1)		/* 8000Hz */
-#define SNDRV_PCM_RATE_11025		(1<<2)		/* 11025Hz */
-#define SNDRV_PCM_RATE_16000		(1<<3)		/* 16000Hz */
-#define SNDRV_PCM_RATE_22050		(1<<4)		/* 22050Hz */
-#define SNDRV_PCM_RATE_32000		(1<<5)		/* 32000Hz */
-#define SNDRV_PCM_RATE_44100		(1<<6)		/* 44100Hz */
-#define SNDRV_PCM_RATE_48000		(1<<7)		/* 48000Hz */
-#define SNDRV_PCM_RATE_64000		(1<<8)		/* 64000Hz */
-#define SNDRV_PCM_RATE_88200		(1<<9)		/* 88200Hz */
-#define SNDRV_PCM_RATE_96000		(1<<10)		/* 96000Hz */
-#define SNDRV_PCM_RATE_176400		(1<<11)		/* 176400Hz */
-#define SNDRV_PCM_RATE_192000		(1<<12)		/* 192000Hz */
-#define SNDRV_PCM_RATE_352800		(1<<13)		/* 352800Hz */
-#define SNDRV_PCM_RATE_384000		(1<<14)		/* 384000Hz */
-
-#define SNDRV_PCM_RATE_CONTINUOUS	(1<<30)		/* continuous range */
-#define SNDRV_PCM_RATE_KNOT		(1<<31)		/* supports more non-continuos rates */
+#define SNDRV_PCM_RATE_5512		(1U<<0)		/* 5512Hz */
+#define SNDRV_PCM_RATE_8000		(1U<<1)		/* 8000Hz */
+#define SNDRV_PCM_RATE_11025		(1U<<2)		/* 11025Hz */
+#define SNDRV_PCM_RATE_16000		(1U<<3)		/* 16000Hz */
+#define SNDRV_PCM_RATE_22050		(1U<<4)		/* 22050Hz */
+#define SNDRV_PCM_RATE_32000		(1U<<5)		/* 32000Hz */
+#define SNDRV_PCM_RATE_44100		(1U<<6)		/* 44100Hz */
+#define SNDRV_PCM_RATE_48000		(1U<<7)		/* 48000Hz */
+#define SNDRV_PCM_RATE_64000		(1U<<8)		/* 64000Hz */
+#define SNDRV_PCM_RATE_88200		(1U<<9)		/* 88200Hz */
+#define SNDRV_PCM_RATE_96000		(1U<<10)	/* 96000Hz */
+#define SNDRV_PCM_RATE_176400		(1U<<11)	/* 176400Hz */
+#define SNDRV_PCM_RATE_192000		(1U<<12)	/* 192000Hz */
+#define SNDRV_PCM_RATE_352800		(1U<<13)	/* 352800Hz */
+#define SNDRV_PCM_RATE_384000		(1U<<14)	/* 384000Hz */
+
+#define SNDRV_PCM_RATE_CONTINUOUS	(1U<<30)	/* continuous range */
+#define SNDRV_PCM_RATE_KNOT		(1U<<31)	/* supports more non-continuos rates */
 
 #define SNDRV_PCM_RATE_8000_44100	(SNDRV_PCM_RATE_8000|SNDRV_PCM_RATE_11025|\
 					 SNDRV_PCM_RATE_16000|SNDRV_PCM_RATE_22050|\
-- 
2.35.1



