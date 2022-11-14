Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3271628C0C
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 23:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbiKNWWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 17:22:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235639AbiKNWWV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 17:22:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440791B1FF
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 14:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668464464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DEzbZbxMDVtgKO4mt4UPz1wY8+F4/UNYjVn0w1tPxSA=;
        b=iqXQ8i560D42hRrICxm5hunzVnmD1FmJKpmx0WqEA9xDM9LmDgUTEoNT+xZxhE8LdYhBvJ
        yU8eW/CwnNYqkHYkp4m74OS4uqxcnDctfhZf9QKDX55GvcgyNnHOUUnEhEhGmkfOVnl56y
        dnva12YsmjqreSwqtLDEIuGSnU213uM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-6FMgJgeyP1ayoZEDfjKcwA-1; Mon, 14 Nov 2022 17:20:59 -0500
X-MC-Unique: 6FMgJgeyP1ayoZEDfjKcwA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80D9138012D2;
        Mon, 14 Nov 2022 22:20:58 +0000 (UTC)
Received: from emerald.lyude.net (unknown [10.22.18.150])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CDD22166B46;
        Mon, 14 Nov 2022 22:20:57 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Alan Liu <HaoPing.Liu@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        dri-devel@lists.freedesktop.org (open list:DRM DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drm/amd/dc/dce120: Fix audio register mapping, stop triggering KASAN
Date:   Mon, 14 Nov 2022 17:20:45 -0500
Message-Id: <20221114222046.386560-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There's been a very long running bug that seems to have been neglected for
a while, where amdgpu consistently triggers a KASAN error at start:

  BUG: KASAN: global-out-of-bounds in read_indirect_azalia_reg+0x1d4/0x2a0 [amdgpu]
  Read of size 4 at addr ffffffffc2274b28 by task modprobe/1889

After digging through amd's rather creative method for accessing registers,
I eventually discovered the problem likely has to do with the fact that on
my dce120 GPU there are supposedly 7 sets of audio registers. But we only
define a register mapping for 6 sets.

So, fix this and fix the KASAN warning finally.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
---
Sending this one separately from the rest of my fixes since:

* It's definitely completely unrelated to the Gitlab 2171 issue
* I'm not sure if this is the correct fix since it's in DC

 drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
index 1b70b78e2fa15..af631085e88c5 100644
--- a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
@@ -359,7 +359,8 @@ static const struct dce_audio_registers audio_regs[] = {
 	audio_regs(2),
 	audio_regs(3),
 	audio_regs(4),
-	audio_regs(5)
+	audio_regs(5),
+	audio_regs(6),
 };
 
 #define DCE120_AUD_COMMON_MASK_SH_LIST(mask_sh)\
-- 
2.37.3

