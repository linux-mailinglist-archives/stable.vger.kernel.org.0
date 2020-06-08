Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD33A1F2D55
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgFIAcd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:32:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729992AbgFHXPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 424DA214F1;
        Mon,  8 Jun 2020 23:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658109;
        bh=gFlnimGPxJ+s6PY8h4JgH9me7qMFxTl/ShAZ/q4Lzfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wdfWIR8hh9ISmHTc6Pwyz++ESxW9phyeE0q/SNfJf9SGm3wO02Ib769vkHrMgUzLc
         f+h2sK0oC8St66xW3AiehgW4IXC8+1mWsyHWsJhenOuIY7Iw1KlBsOxphfVk/Z9SmB
         DqgxaSBjsACVTyV2iHmNgaiT4oSA5e33U9ssy5bA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Bryant G . Ly" <bryangly@gmail.com>,
        Bart van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 148/606] scsi: target: Put lun_ref at end of tmr processing
Date:   Mon,  8 Jun 2020 19:04:33 -0400
Message-Id: <20200608231211.3363633-148-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

commit f2e6b75f6ee82308ef7b00f29e71e5f1c6b3d52a upstream.

Testing with Loopback I found that, after a Loopback LUN has executed a
TMR, I can no longer unlink the LUN.  The rm command hangs in
transport_clear_lun_ref() at wait_for_completion(&lun->lun_shutdown_comp)
The reason is, that transport_lun_remove_cmd() is not called at the end of
target_tmr_work().

It seems, that in other fabrics this call happens implicitly when the
fabric drivers call transport_generic_free_cmd() during their
->queue_tm_rsp().

Unfortunately Loopback seems to not comply to the common way
of calling transport_generic_free_cmd() from ->queue_*().
Instead it calls transport_generic_free_cmd() from its
  ->check_stop_free() only.

But the ->check_stop_free() is called by
transport_cmd_check_stop_to_fabric() after it has reset the se_cmd->se_lun
pointer.  Therefore the following transport_generic_free_cmd() skips the
transport_lun_remove_cmd().

So this patch re-adds the transport_lun_remove_cmd() at the end of
target_tmr_work(), which was removed during commit 2c9fa49e100f ("scsi:
target/core: Make ABORT and LUN RESET handling synchronous").

For fabrics using transport_generic_free_cmd() in the usual way the double
call to transport_lun_remove_cmd() doesn't harm, as
transport_lun_remove_cmd() checks for this situation and does not release
lun_ref twice.

Link: https://lore.kernel.org/r/20200513153443.3554-1-bstroesser@ts.fujitsu.com
Fixes: 2c9fa49e100f ("scsi: target/core: Make ABORT and LUN RESET handling synchronous")
Cc: stable@vger.kernel.org
Tested-by: Bryant G. Ly <bryangly@gmail.com>
Reviewed-by: Bart van Assche <bvanassche@acm.org>
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0ae9e60fc4d5..61486e5abee4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3349,6 +3349,7 @@ static void target_tmr_work(struct work_struct *work)
 
 	cmd->se_tfo->queue_tm_rsp(cmd);
 
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
-- 
2.25.1

