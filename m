Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D4266CD40
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234813AbjAPRfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbjAPReg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:34:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6883B30EA7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:10:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20A12B8107A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9BDC433D2;
        Mon, 16 Jan 2023 17:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889042;
        bh=M1Rv4ePsvtWaW4+sBTVXzWFT21qk4HkDaNMH+tQ+aGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8Po1JQ/tpIEeZLSubOrtYXkqIhnL8PHwbBAU3oxxjEJFeflMQwcUeSmy1xsxSs7P
         LtSfaujHVerIwnhNF0jkJEqd5A59TQY+QMUy85zs9v0NJr6SbLDyQuhQW/+AnQAxdM
         XX/RInCiBEJaPKyb1eDowoBPNvvz4+4CCX7xUYLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiang Li <jiang.li@ugreen.com>,
        Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 236/338] md/raid1: stop mdx_raid1 thread when raid1 array run failed
Date:   Mon, 16 Jan 2023 16:51:49 +0100
Message-Id: <20230116154831.329962187@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Jiang Li <jiang.li@ugreen.com>

[ Upstream commit b611ad14006e5be2170d9e8e611bf49dff288911 ]

fail run raid1 array when we assemble array with the inactive disk only,
but the mdx_raid1 thread were not stop, Even if the associated resources
have been released. it will caused a NULL dereference when we do poweroff.

This causes the following Oops:
    [  287.587787] BUG: kernel NULL pointer dereference, address: 0000000000000070
    [  287.594762] #PF: supervisor read access in kernel mode
    [  287.599912] #PF: error_code(0x0000) - not-present page
    [  287.605061] PGD 0 P4D 0
    [  287.607612] Oops: 0000 [#1] SMP NOPTI
    [  287.611287] CPU: 3 PID: 5265 Comm: md0_raid1 Tainted: G     U            5.10.146 #0
    [  287.619029] Hardware name: xxxxxxx/To be filled by O.E.M, BIOS 5.19 06/16/2022
    [  287.626775] RIP: 0010:md_check_recovery+0x57/0x500 [md_mod]
    [  287.632357] Code: fe 01 00 00 48 83 bb 10 03 00 00 00 74 08 48 89 ......
    [  287.651118] RSP: 0018:ffffc90000433d78 EFLAGS: 00010202
    [  287.656347] RAX: 0000000000000000 RBX: ffff888105986800 RCX: 0000000000000000
    [  287.663491] RDX: ffffc90000433bb0 RSI: 00000000ffffefff RDI: ffff888105986800
    [  287.670634] RBP: ffffc90000433da0 R08: 0000000000000000 R09: c0000000ffffefff
    [  287.677771] R10: 0000000000000001 R11: ffffc90000433ba8 R12: ffff888105986800
    [  287.684907] R13: 0000000000000000 R14: fffffffffffffe00 R15: ffff888100b6b500
    [  287.692052] FS:  0000000000000000(0000) GS:ffff888277f80000(0000) knlGS:0000000000000000
    [  287.700149] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [  287.705897] CR2: 0000000000000070 CR3: 000000000320a000 CR4: 0000000000350ee0
    [  287.713033] Call Trace:
    [  287.715498]  raid1d+0x6c/0xbbb [raid1]
    [  287.719256]  ? __schedule+0x1ff/0x760
    [  287.722930]  ? schedule+0x3b/0xb0
    [  287.726260]  ? schedule_timeout+0x1ed/0x290
    [  287.730456]  ? __switch_to+0x11f/0x400
    [  287.734219]  md_thread+0xe9/0x140 [md_mod]
    [  287.738328]  ? md_thread+0xe9/0x140 [md_mod]
    [  287.742601]  ? wait_woken+0x80/0x80
    [  287.746097]  ? md_register_thread+0xe0/0xe0 [md_mod]
    [  287.751064]  kthread+0x11a/0x140
    [  287.754300]  ? kthread_park+0x90/0x90
    [  287.757974]  ret_from_fork+0x1f/0x30

In fact, when raid1 array run fail, we need to do
md_unregister_thread() before raid1_free().

Signed-off-by: Jiang Li <jiang.li@ugreen.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index daa478e0b856..28f78199de3b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3105,6 +3105,7 @@ static int raid1_run(struct mddev *mddev)
 	 * RAID1 needs at least one disk in active
 	 */
 	if (conf->raid_disks - mddev->degraded < 1) {
+		md_unregister_thread(&conf->thread);
 		ret = -EINVAL;
 		goto abort;
 	}
-- 
2.35.1



