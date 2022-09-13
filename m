Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745065B7560
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbiIMPjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236678AbiIMPij (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:38:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB81EF16;
        Tue, 13 Sep 2022 07:44:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBAB2614A8;
        Tue, 13 Sep 2022 14:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3ED0C433C1;
        Tue, 13 Sep 2022 14:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079693;
        bh=H1P1NwpBXrSvgn+FJ8rzFmWgOGTpyB2pK1CIh8lw4H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVWeBGRXVv6X9uXB+badq1JQiKgKFnYxnIEQKWUOjvbSRloWlg/lNwuGzdavHTRuG
         maLVq55bePVW0jXr9cDcGzmXJaH2XNUx9zhdRO4AhC72t2ap2xjQVpRVwHrlt6HXBJ
         PVzJ7bEY4HWYi1N8Az5odjiQztp6APXr7IYSs8Gs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Zhenneng Li <lizhenneng@kylinos.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/61] drm/radeon: add a force flush to delay work when radeon
Date:   Tue, 13 Sep 2022 16:07:41 +0200
Message-Id: <20220913140348.430044655@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140346.422813036@linuxfoundation.org>
References: <20220913140346.422813036@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zhenneng Li <lizhenneng@kylinos.cn>

[ Upstream commit f461950fdc374a3ada5a63c669d997de4600dffe ]

Although radeon card fence and wait for gpu to finish processing current batch rings,
there is still a corner case that radeon lockup work queue may not be fully flushed,
and meanwhile the radeon_suspend_kms() function has called pci_set_power_state() to
put device in D3hot state.
Per PCI spec rev 4.0 on 5.3.1.4.1 D3hot State.
> Configuration and Message requests are the only TLPs accepted by a Function in
> the D3hot state. All other received Requests must be handled as Unsupported Requests,
> and all received Completions may optionally be handled as Unexpected Completions.
This issue will happen in following logs:
Unable to handle kernel paging request at virtual address 00008800e0008010
CPU 0 kworker/0:3(131): Oops 0
pc = [<ffffffff811bea5c>]  ra = [<ffffffff81240844>]  ps = 0000 Tainted: G        W
pc is at si_gpu_check_soft_reset+0x3c/0x240
ra is at si_dma_is_lockup+0x34/0xd0
v0 = 0000000000000000  t0 = fff08800e0008010  t1 = 0000000000010000
t2 = 0000000000008010  t3 = fff00007e3c00000  t4 = fff00007e3c00258
t5 = 000000000000ffff  t6 = 0000000000000001  t7 = fff00007ef078000
s0 = fff00007e3c016e8  s1 = fff00007e3c00000  s2 = fff00007e3c00018
s3 = fff00007e3c00000  s4 = fff00007fff59d80  s5 = 0000000000000000
s6 = fff00007ef07bd98
a0 = fff00007e3c00000  a1 = fff00007e3c016e8  a2 = 0000000000000008
a3 = 0000000000000001  a4 = 8f5c28f5c28f5c29  a5 = ffffffff810f4338
t8 = 0000000000000275  t9 = ffffffff809b66f8  t10 = ff6769c5d964b800
t11= 000000000000b886  pv = ffffffff811bea20  at = 0000000000000000
gp = ffffffff81d89690  sp = 00000000aa814126
Disabling lock debugging due to kernel taint
Trace:
[<ffffffff81240844>] si_dma_is_lockup+0x34/0xd0
[<ffffffff81119610>] radeon_fence_check_lockup+0xd0/0x290
[<ffffffff80977010>] process_one_work+0x280/0x550
[<ffffffff80977350>] worker_thread+0x70/0x7c0
[<ffffffff80977410>] worker_thread+0x130/0x7c0
[<ffffffff80982040>] kthread+0x200/0x210
[<ffffffff809772e0>] worker_thread+0x0/0x7c0
[<ffffffff80981f8c>] kthread+0x14c/0x210
[<ffffffff80911658>] ret_from_kernel_thread+0x18/0x20
[<ffffffff80981e40>] kthread+0x0/0x210
 Code: ad3e0008  43f0074a  ad7e0018  ad9e0020  8c3001e8  40230101
 <88210000> 4821ed21
So force lockup work queue flush to fix this problem.

Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Zhenneng Li <lizhenneng@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 58488eac84627..906547b229a9a 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1655,6 +1655,9 @@ int radeon_suspend_kms(struct drm_device *dev, bool suspend,
 		if (r) {
 			/* delay GPU reset to resume */
 			radeon_fence_driver_force_completion(rdev, i);
+		} else {
+			/* finish executing delayed work */
+			flush_delayed_work(&rdev->fence_drv[i].lockup_work);
 		}
 	}
 
-- 
2.35.1



