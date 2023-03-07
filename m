Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFF46AED8D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbjCGSFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbjCGSFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:05:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252942A6CA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:58:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D6146152B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555B3C433D2;
        Tue,  7 Mar 2023 17:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211877;
        bh=nZGfAIzeggdGJ6iRYCgvuBR/AzMajDhQ6CjlytbIn4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRavBoDDIbCaup0S6sxuiTuteO3tMbSB0483aa7D/jUehJUHwx54LI/8tuaCLDB6h
         gj/+ntPzoTMruqSY9d6hu5lifJtn8ap77crxgHfr1GLbPNaQBVV3dePQl47Z2uuiAp
         LC6VETsjQ1w3kAyUdhyh6E+CT3VboAPEYdd1jqaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Javier Martinez Canillas <javierm@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>
Subject: [PATCH 6.2 0999/1001] drm/gud: Fix UBSAN warning
Date:   Tue,  7 Mar 2023 18:02:51 +0100
Message-Id: <20230307170105.669148708@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Noralf Trønnes <noralf@tronnes.org>

commit 951df98024f7272f85df5044eca7374f5b5b24ef upstream.

UBSAN complains about invalid value for bool:

[  101.165172] [drm] Initialized gud 1.0.0 20200422 for 2-3.2:1.0 on minor 1
[  101.213360] gud 2-3.2:1.0: [drm] fb1: guddrmfb frame buffer device
[  101.213426] usbcore: registered new interface driver gud
[  101.989431] ================================================================================
[  101.989441] UBSAN: invalid-load in linux/include/linux/iosys-map.h:253:9
[  101.989447] load of value 121 is not a valid value for type '_Bool'
[  101.989451] CPU: 1 PID: 455 Comm: kworker/1:6 Not tainted 5.18.0-rc5-gud-5.18-rc5 #3
[  101.989456] Hardware name: Hewlett-Packard HP EliteBook 820 G1/1991, BIOS L71 Ver. 01.44 04/12/2018
[  101.989459] Workqueue: events_long gud_flush_work [gud]
[  101.989471] Call Trace:
[  101.989474]  <TASK>
[  101.989479]  dump_stack_lvl+0x49/0x5f
[  101.989488]  dump_stack+0x10/0x12
[  101.989493]  ubsan_epilogue+0x9/0x3b
[  101.989498]  __ubsan_handle_load_invalid_value.cold+0x44/0x49
[  101.989504]  dma_buf_vmap.cold+0x38/0x3d
[  101.989511]  ? find_busiest_group+0x48/0x300
[  101.989520]  drm_gem_shmem_vmap+0x76/0x1b0 [drm_shmem_helper]
[  101.989528]  drm_gem_shmem_object_vmap+0x9/0xb [drm_shmem_helper]
[  101.989535]  drm_gem_vmap+0x26/0x60 [drm]
[  101.989594]  drm_gem_fb_vmap+0x47/0x150 [drm_kms_helper]
[  101.989630]  gud_prep_flush+0xc1/0x710 [gud]
[  101.989639]  ? _raw_spin_lock+0x17/0x40
[  101.989648]  gud_flush_work+0x1e0/0x430 [gud]
[  101.989653]  ? __switch_to+0x11d/0x470
[  101.989664]  process_one_work+0x21f/0x3f0
[  101.989673]  worker_thread+0x200/0x3e0
[  101.989679]  ? rescuer_thread+0x390/0x390
[  101.989684]  kthread+0xfd/0x130
[  101.989690]  ? kthread_complete_and_exit+0x20/0x20
[  101.989696]  ret_from_fork+0x22/0x30
[  101.989706]  </TASK>
[  101.989708] ================================================================================

The source of this warning is in iosys_map_clear() called from
dma_buf_vmap(). It conditionally sets values based on map->is_iomem. The
iosys_map variables are allocated uninitialized on the stack leading to
->is_iomem having all kinds of values and not only 0/1.

Fix this by zeroing the iosys_map variables.

Fixes: 40e1a70b4aed ("drm: Add GUD USB Display driver")
Cc: <stable@vger.kernel.org> # v5.18+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221122-gud-shadow-plane-v2-1-435037990a83@tronnes.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gud/gud_pipe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -157,8 +157,8 @@ static int gud_prep_flush(struct gud_dev
 {
 	struct dma_buf_attachment *import_attach = fb->obj[0]->import_attach;
 	u8 compression = gdrm->compression;
-	struct iosys_map map[DRM_FORMAT_MAX_PLANES];
-	struct iosys_map map_data[DRM_FORMAT_MAX_PLANES];
+	struct iosys_map map[DRM_FORMAT_MAX_PLANES] = { };
+	struct iosys_map map_data[DRM_FORMAT_MAX_PLANES] = { };
 	struct iosys_map dst;
 	void *vaddr, *buf;
 	size_t pitch, len;


