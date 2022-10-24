Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE6760B849
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiJXTnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbiJXTmF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:42:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC8A58DCE;
        Mon, 24 Oct 2022 11:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68DCEB818A9;
        Mon, 24 Oct 2022 12:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC2AC433D7;
        Mon, 24 Oct 2022 12:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615950;
        bh=/FwXlzJ9Jrc8DAzVrT3nucKn/N+/4PYuU8ruKXauqMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6Xm/dtmabr+EM44vq671dQ2aKWLcaJidH2Gn5Vd6mZWdqE53WU3neDlpdL2eCWhH
         AgILBChHQgjDtTa4jtOtWStMKC8udNlLMZmL6q4goN8DpMS1Qm1JOhyHeWzFpqROqB
         JsjatF6XI0UujnAMGG95kyaOHVmorGRIFdHW/RX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Robinson <pbrobinson@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 445/530] drm: Prevent drm_copy_field() to attempt copying a NULL pointer
Date:   Mon, 24 Oct 2022 13:33:09 +0200
Message-Id: <20221024113105.177762485@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit f6ee30407e883042482ad4ad30da5eaba47872ee ]

There are some struct drm_driver fields that are required by drivers since
drm_copy_field() attempts to copy them to user-space via DRM_IOCTL_VERSION.

But it can be possible that a driver has a bug and did not set some of the
fields, which leads to drm_copy_field() attempting to copy a NULL pointer:

[ +10.395966] Unable to handle kernel access to user memory outside uaccess routines at virtual address 0000000000000000
[  +0.010955] Mem abort info:
[  +0.002835]   ESR = 0x0000000096000004
[  +0.003872]   EC = 0x25: DABT (current EL), IL = 32 bits
[  +0.005395]   SET = 0, FnV = 0
[  +0.003113]   EA = 0, S1PTW = 0
[  +0.003182]   FSC = 0x04: level 0 translation fault
[  +0.004964] Data abort info:
[  +0.002919]   ISV = 0, ISS = 0x00000004
[  +0.003886]   CM = 0, WnR = 0
[  +0.003040] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000115dad000
[  +0.006536] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
[  +0.006925] Internal error: Oops: 96000004 [#1] SMP
...
[  +0.011113] pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  +0.007061] pc : __pi_strlen+0x14/0x150
[  +0.003895] lr : drm_copy_field+0x30/0x1a4
[  +0.004156] sp : ffff8000094b3a50
[  +0.003355] x29: ffff8000094b3a50 x28: ffff8000094b3b70 x27: 0000000000000040
[  +0.007242] x26: ffff443743c2ba00 x25: 0000000000000000 x24: 0000000000000040
[  +0.007243] x23: ffff443743c2ba00 x22: ffff8000094b3b70 x21: 0000000000000000
[  +0.007241] x20: 0000000000000000 x19: ffff8000094b3b90 x18: 0000000000000000
[  +0.007241] x17: 0000000000000000 x16: 0000000000000000 x15: 0000aaab14b9af40
[  +0.007241] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
[  +0.007239] x11: 0000000000000000 x10: 0000000000000000 x9 : ffffa524ad67d4d8
[  +0.007242] x8 : 0101010101010101 x7 : 7f7f7f7f7f7f7f7f x6 : 6c6e6263606e7141
[  +0.007239] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000000
[  +0.007241] x2 : 0000000000000000 x1 : ffff8000094b3b90 x0 : 0000000000000000
[  +0.007240] Call trace:
[  +0.002475]  __pi_strlen+0x14/0x150
[  +0.003537]  drm_version+0x84/0xac
[  +0.003448]  drm_ioctl_kernel+0xa8/0x16c
[  +0.003975]  drm_ioctl+0x270/0x580
[  +0.003448]  __arm64_sys_ioctl+0xb8/0xfc
[  +0.003978]  invoke_syscall+0x78/0x100
[  +0.003799]  el0_svc_common.constprop.0+0x4c/0xf4
[  +0.004767]  do_el0_svc+0x38/0x4c
[  +0.003357]  el0_svc+0x34/0x100
[  +0.003185]  el0t_64_sync_handler+0x11c/0x150
[  +0.004418]  el0t_64_sync+0x190/0x194
[  +0.003716] Code: 92402c04 b200c3e8 f13fc09f 5400088c (a9400c02)
[  +0.006180] ---[ end trace 0000000000000000 ]---

Reported-by: Peter Robinson <pbrobinson@gmail.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220705100215.572498-3-javierm@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 5669c6cf7135..fb5e6f86dea2 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -474,6 +474,12 @@ static int drm_copy_field(char __user *buf, size_t *buf_len, const char *value)
 {
 	size_t len;
 
+	/* don't attempt to copy a NULL pointer */
+	if (WARN_ONCE(!value, "BUG: the value to copy was not set!")) {
+		*buf_len = 0;
+		return 0;
+	}
+
 	/* don't overflow userbuf */
 	len = strlen(value);
 	if (len > *buf_len)
-- 
2.35.1



