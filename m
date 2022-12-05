Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD6B643458
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbiLETpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbiLETo7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:44:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857222CDCB
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:41:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D49A4CE1386
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BD6C433D6;
        Mon,  5 Dec 2022 19:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269308;
        bh=umztl423nGW7YeA0ufpkHWgdi9dAAqxJLv7wjc6efDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nEuhTIJq+4A4XMcgnRuhFTCzZKijFpQUfil9h8Jk0Pm3809dEm5ireTiku/AeYZ1M
         GU5PvWkAVoPEE+c8HP2Gn3IoTJNyyFwJUz0tVUcVunaVFvISTV5Tk+bO3sxLnE2BO5
         cCQMloZTuSaFW8DSv+cjkCwfQTTwSMWbZMqUIOYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lyude Paul <lyude@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 079/153] drm/amd/dc/dce120: Fix audio register mapping, stop triggering KASAN
Date:   Mon,  5 Dec 2022 20:10:03 +0100
Message-Id: <20221205190810.992668387@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

From: Lyude Paul <lyude@redhat.com>

commit 44035ec2fde1114254ee465f9ba3bb246b0b6283 upstream.

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
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dce120/dce120_resource.c
@@ -340,7 +340,8 @@ static const struct dce_audio_registers
 	audio_regs(2),
 	audio_regs(3),
 	audio_regs(4),
-	audio_regs(5)
+	audio_regs(5),
+	audio_regs(6),
 };
 
 #define DCE120_AUD_COMMON_MASK_SH_LIST(mask_sh)\


