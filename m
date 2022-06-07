Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77B4F5407FC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbiFGRxv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348540AbiFGRtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:49:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30746134E0C;
        Tue,  7 Jun 2022 10:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 35D2DCE23E7;
        Tue,  7 Jun 2022 17:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B73C34115;
        Tue,  7 Jun 2022 17:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623431;
        bh=fKOmGeRYgG3j50YlOQ0Vw/r7fBFkPvZ8bFRh8oMkVvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AjaT4n+n9DDZOz07RHO3yutbc42dfUVgMkJP7SqaSFMoIet0AqnNZYI4WWypxgtnZ
         wqyL1ovZqowqa7o31qdX1qIuyfLoewKB7EVCgqp3uAmYSVxRRfUP+4DmxAk+ih618u
         4rxAfjQmb5wBsaJatsX0R/zX4ZGSW3kcyhoVL/8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 378/452] drm/amdgpu/cs: make commands with 0 chunks illegal behaviour.
Date:   Tue,  7 Jun 2022 19:03:55 +0200
Message-Id: <20220607164919.827940164@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

commit 31ab27b14daaa75541a415c6794d6f3567fea44a upstream.

Submitting a cs with 0 chunks, causes an oops later, found trying
to execute the wrong userspace driver.

MESA_LOADER_DRIVER_OVERRIDE=v3d glxinfo

[172536.665184] BUG: kernel NULL pointer dereference, address: 00000000000001d8
[172536.665188] #PF: supervisor read access in kernel mode
[172536.665189] #PF: error_code(0x0000) - not-present page
[172536.665191] PGD 6712a0067 P4D 6712a0067 PUD 5af9ff067 PMD 0
[172536.665195] Oops: 0000 [#1] SMP NOPTI
[172536.665197] CPU: 7 PID: 2769838 Comm: glxinfo Tainted: P           O      5.10.81 #1-NixOS
[172536.665199] Hardware name: To be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS 2201 03/23/2015
[172536.665272] RIP: 0010:amdgpu_cs_ioctl+0x96/0x1ce0 [amdgpu]
[172536.665274] Code: 75 18 00 00 4c 8b b2 88 00 00 00 8b 46 08 48 89 54 24 68 49 89 f7 4c 89 5c 24 60 31 d2 4c 89 74 24 30 85 c0 0f 85 c0 01 00 00 <48> 83 ba d8 01 00 00 00 48 8b b4 24 90 00 00 00 74 16 48 8b 46 10
[172536.665276] RSP: 0018:ffffb47c0e81bbe0 EFLAGS: 00010246
[172536.665277] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
[172536.665278] RDX: 0000000000000000 RSI: ffffb47c0e81be28 RDI: ffffb47c0e81bd68
[172536.665279] RBP: ffff936524080010 R08: 0000000000000000 R09: ffffb47c0e81be38
[172536.665281] R10: ffff936524080010 R11: ffff936524080000 R12: ffffb47c0e81bc40
[172536.665282] R13: ffffb47c0e81be28 R14: ffff9367bc410000 R15: ffffb47c0e81be28
[172536.665283] FS:  00007fe35e05d740(0000) GS:ffff936c1edc0000(0000) knlGS:0000000000000000
[172536.665284] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[172536.665286] CR2: 00000000000001d8 CR3: 0000000532e46000 CR4: 00000000000406e0
[172536.665287] Call Trace:
[172536.665322]  ? amdgpu_cs_find_mapping+0x110/0x110 [amdgpu]
[172536.665332]  drm_ioctl_kernel+0xaa/0xf0 [drm]
[172536.665338]  drm_ioctl+0x201/0x3b0 [drm]
[172536.665369]  ? amdgpu_cs_find_mapping+0x110/0x110 [amdgpu]
[172536.665372]  ? selinux_file_ioctl+0x135/0x230
[172536.665399]  amdgpu_drm_ioctl+0x49/0x80 [amdgpu]
[172536.665403]  __x64_sys_ioctl+0x83/0xb0
[172536.665406]  do_syscall_64+0x33/0x40
[172536.665409]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2018
Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -116,7 +116,7 @@ static int amdgpu_cs_parser_init(struct
 	int ret;
 
 	if (cs->in.num_chunks == 0)
-		return 0;
+		return -EINVAL;
 
 	chunk_array = kmalloc_array(cs->in.num_chunks, sizeof(uint64_t), GFP_KERNEL);
 	if (!chunk_array)


