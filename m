Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB16D4A968C
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238611AbiBDJ1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357612AbiBDJZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:25:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F3CDC061775;
        Fri,  4 Feb 2022 01:25:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C16CB836EF;
        Fri,  4 Feb 2022 09:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5338EC004E1;
        Fri,  4 Feb 2022 09:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966719;
        bh=e34DISovHSTcPO6u9ZxmHUgM4W5YT1b+Uh6wVUOy/V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUR0/ksgSSMrq5gp1YihrRvHXFrCz8beTUfdDPmELGuZuIj5ASRvgSG9BK/2MhpM8
         bX+Vxzny83ytjZPUbMFCLMVBjW+LXZhvTbE8nVE1gMiNdL6bbDA3yAWjOACACPW+oC
         05mf6lbpq2QSXm+qXWQ88il47KivLd3eSJelW4E8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 18/43] net/mlx5: Use del_timer_sync in fw reset flow of halting poll
Date:   Fri,  4 Feb 2022 10:22:25 +0100
Message-Id: <20220204091917.771006504@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

commit 3c5193a87b0fea090aa3f769d020337662d87b5e upstream.

Substitute del_timer() with del_timer_sync() in fw reset polling
deactivation flow, in order to prevent a race condition which occurs
when del_timer() is called and timer is deactivated while another
process is handling the timer interrupt. A situation that led to
the following call trace:
	RIP: 0010:run_timer_softirq+0x137/0x420
	<IRQ>
	recalibrate_cpu_khz+0x10/0x10
	ktime_get+0x3e/0xa0
	? sched_clock_cpu+0xb/0xc0
	__do_softirq+0xf5/0x2ea
	irq_exit_rcu+0xc1/0xf0
	sysvec_apic_timer_interrupt+0x9e/0xc0
	asm_sysvec_apic_timer_interrupt+0x12/0x20
	</IRQ>

Fixes: 38b9f903f22b ("net/mlx5: Handle sync reset request event")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -132,7 +132,7 @@ static void mlx5_stop_sync_reset_poll(st
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
 
-	del_timer(&fw_reset->timer);
+	del_timer_sync(&fw_reset->timer);
 }
 
 static void mlx5_sync_reset_clear_reset_requested(struct mlx5_core_dev *dev, bool poll_health)


