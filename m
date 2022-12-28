Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B96F658506
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbiL1RFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234527AbiL1REV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:04:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275402035F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:59:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6EE861558
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8845C433D2;
        Wed, 28 Dec 2022 16:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246739;
        bh=yB1mZki4AoXvVlo9kaQVZdUdtdSae3yon+m6s2Dchog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRYgLIjt6iRS2TZGVoXG673ei3uCD0b7Ms/1W3uF3uT8QqoOSfrSs0TvdyUjUWdHo
         88iDqlybX40KtBkIFl/1xfpBdDJORC2xM9qrNPPYiA9q2GJBR6M3v1JS2LnIjlZkbg
         AhI7nbvTs8oNINOc2U0pWK2Rji86g8WySyhXOzJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+fce48a3dd3368645bd6c@syzkaller.appspotmail.com,
        Lin Ma <linma@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.1 1145/1146] media: dvbdev: fix refcnt bug
Date:   Wed, 28 Dec 2022 15:44:44 +0100
Message-Id: <20221228144401.241146493@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Lin Ma <linma@zju.edu.cn>

commit 3a664569b71b0a52be5ffb9fb87cc4f83d29bd71 upstream.

Previous commit initialize the dvbdev->ref before the template copy,
which will overwrite the reference and cause refcnt bug.

refcount_t: addition on 0; use-after-free.
WARNING: CPU: 0 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+0x17c/0x1f0 lib/refcount.c:25
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc6-next-20221128-syzkaller #0
...
RIP: 0010:refcount_warn_saturate+0x17c/0x1f0 lib/refcount.c:25
RSP: 0000:ffffc900000678d0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88813ff58000 RSI: ffffffff81660e7c RDI: fffff5200000cf0c
RBP: ffff888022a45010 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000c48e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_add include/linux/refcount.h:199 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 kref_get include/linux/kref.h:45 [inline]
 dvb_device_get drivers/media/dvb-core/dvbdev.c:585 [inline]
 dvb_register_device+0xe83/0x16e0 drivers/media/dvb-core/dvbdev.c:517
...

Just place the kref_init at correct position.

Reported-by: syzbot+fce48a3dd3368645bd6c@syzkaller.appspotmail.com
Fixes: 0fc044b2b5e2 ("media: dvbdev: adopts refcnt to avoid UAF")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-core/dvbdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -480,8 +480,8 @@ int dvb_register_device(struct dvb_adapt
 		return -ENOMEM;
 	}
 
-	kref_init(&dvbdev->ref);
 	memcpy(dvbdev, template, sizeof(struct dvb_device));
+	kref_init(&dvbdev->ref);
 	dvbdev->type = type;
 	dvbdev->id = id;
 	dvbdev->adapter = adap;


