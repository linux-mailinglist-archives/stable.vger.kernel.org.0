Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71DDC66C6F5
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjAPQ1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbjAPQ0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:26:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3E136B1C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:14:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95254B8105F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE317C433D2;
        Mon, 16 Jan 2023 16:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885680;
        bh=KHzEcZE2k1pRm8RztkLsclhbLBR1oLAIU4UFuSVxwr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tzfjs41GVmncrC8u/IIdadY4p/SFZ8bYjD3kktz0M0BfSeHws8DvJQ20B7cwDY/oK
         yRYONVJu9+nqm5yy2xzpTYtJXuPX/hRPqjzrHD0A7v/M0pZR2X09O4qYrC1thZ8KAu
         kAuK1nyk4ApFrWA2KPGrjPKPXw4ogzlR6AcnDDfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Baisong Zhong <zhongbaisong@huawei.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/658] ALSA: seq: fix undefined behavior in bit shift for SNDRV_SEQ_FILTER_USE_EVENT
Date:   Mon, 16 Jan 2023 16:43:51 +0100
Message-Id: <20230116154916.005949656@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit cf59e1e4c79bf741905484cdb13c130b53576a16 ]

Shifting signed 32-bit value by 31 bits is undefined, so changing
significant bit to unsigned. The UBSAN warning calltrace like below:

UBSAN: shift-out-of-bounds in sound/core/seq/seq_clientmgr.c:509:22
left shift of 1 by 31 places cannot be represented in type 'int'
...
Call Trace:
 <TASK>
 dump_stack_lvl+0x8d/0xcf
 ubsan_epilogue+0xa/0x44
 __ubsan_handle_shift_out_of_bounds+0x1e7/0x208
 snd_seq_deliver_single_event.constprop.21+0x191/0x2f0
 snd_seq_deliver_event+0x1a2/0x350
 snd_seq_kernel_client_dispatch+0x8b/0xb0
 snd_seq_client_notify_subscription+0x72/0xa0
 snd_seq_ioctl_subscribe_port+0x128/0x160
 snd_seq_kernel_client_ctl+0xce/0xf0
 snd_seq_oss_create_client+0x109/0x15b
 alsa_seq_oss_init+0x11c/0x1aa
 do_one_initcall+0x80/0x440
 kernel_init_freeable+0x370/0x3c3
 kernel_init+0x1b/0x190
 ret_from_fork+0x1f/0x30
 </TASK>

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Baisong Zhong <zhongbaisong@huawei.com>
Link: https://lore.kernel.org/r/20221121111630.3119259-1-zhongbaisong@huawei.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/sound/asequencer.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/uapi/sound/asequencer.h b/include/uapi/sound/asequencer.h
index a75e14edc957..dbd60f48b4b0 100644
--- a/include/uapi/sound/asequencer.h
+++ b/include/uapi/sound/asequencer.h
@@ -344,10 +344,10 @@ typedef int __bitwise snd_seq_client_type_t;
 #define	KERNEL_CLIENT	((__force snd_seq_client_type_t) 2)
                         
 	/* event filter flags */
-#define SNDRV_SEQ_FILTER_BROADCAST	(1<<0)	/* accept broadcast messages */
-#define SNDRV_SEQ_FILTER_MULTICAST	(1<<1)	/* accept multicast messages */
-#define SNDRV_SEQ_FILTER_BOUNCE		(1<<2)	/* accept bounce event in error */
-#define SNDRV_SEQ_FILTER_USE_EVENT	(1<<31)	/* use event filter */
+#define SNDRV_SEQ_FILTER_BROADCAST	(1U<<0)	/* accept broadcast messages */
+#define SNDRV_SEQ_FILTER_MULTICAST	(1U<<1)	/* accept multicast messages */
+#define SNDRV_SEQ_FILTER_BOUNCE		(1U<<2)	/* accept bounce event in error */
+#define SNDRV_SEQ_FILTER_USE_EVENT	(1U<<31)	/* use event filter */
 
 struct snd_seq_client_info {
 	int client;			/* client number to inquire */
-- 
2.35.1



