Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CC72C0881
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732780AbgKWMwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:52:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:35846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387634AbgKWMvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:51:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E3122100A;
        Mon, 23 Nov 2020 12:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135897;
        bh=gefadVBfiGeyhr6C+XK6HN1P6O1jPeS/pEyIBC7j8i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWupPCjMttgtrFAkXiOx9alE9OGkgEnB61oMiX08TvrH6hsKO4d5Kuglz/QJ5q4t/
         sSt8SRkY+rXOk/6tkKQ6UnZcSvAqGkSJ27Y/N1dxGaIDwYxic5vewinF/q88phx0xI
         mlCKvvZzZ66QNzXDhVua83tWyZLOfTa+dgqi5b1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Co <chrco@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.9 235/252] Drivers: hv: vmbus: Allow cleanup of VMBUS_CONNECT_CPU if disconnected
Date:   Mon, 23 Nov 2020 13:23:05 +0100
Message-Id: <20201123121846.919000503@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Co <chrco@microsoft.com>

commit 92e4dc8b05663d6539b1b8375f3b1cf7b204cfe9 upstream.

When invoking kexec() on a Linux guest running on a Hyper-V host, the
kernel panics.

    RIP: 0010:cpuhp_issue_call+0x137/0x140
    Call Trace:
    __cpuhp_remove_state_cpuslocked+0x99/0x100
    __cpuhp_remove_state+0x1c/0x30
    hv_kexec_handler+0x23/0x30 [hv_vmbus]
    hv_machine_shutdown+0x1e/0x30
    machine_shutdown+0x10/0x20
    kernel_kexec+0x6d/0x96
    __do_sys_reboot+0x1ef/0x230
    __x64_sys_reboot+0x1d/0x20
    do_syscall_64+0x6b/0x3d8
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

This was due to hv_synic_cleanup() callback returning -EBUSY to
cpuhp_issue_call() when tearing down the VMBUS_CONNECT_CPU, even
if the vmbus_connection.conn_state = DISCONNECTED. hv_synic_cleanup()
should succeed in the case where vmbus_connection.conn_state
is DISCONNECTED.

Fix is to add an extra condition to test for
vmbus_connection.conn_state == CONNECTED on the VMBUS_CONNECT_CPU and
only return early if true. This way the kexec() path can still shut
everything down while preserving the initial behavior of preventing
CPU offlining on the VMBUS_CONNECT_CPU while the VM is running.

Fixes: 8a857c55420f29 ("Drivers: hv: vmbus: Always handle the VMBus messages on CPU0")
Signed-off-by: Chris Co <chrco@microsoft.com>
Reviewed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201110190118.15596-1-chrco@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/hv.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -244,9 +244,13 @@ int hv_synic_cleanup(unsigned int cpu)
 
 	/*
 	 * Hyper-V does not provide a way to change the connect CPU once
-	 * it is set; we must prevent the connect CPU from going offline.
+	 * it is set; we must prevent the connect CPU from going offline
+	 * while the VM is running normally. But in the panic or kexec()
+	 * path where the vmbus is already disconnected, the CPU must be
+	 * allowed to shut down.
 	 */
-	if (cpu == VMBUS_CONNECT_CPU)
+	if (cpu == VMBUS_CONNECT_CPU &&
+	    vmbus_connection.conn_state == CONNECTED)
 		return -EBUSY;
 
 	/*


