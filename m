Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385CE1C44DF
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731162AbgEDSEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:04:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731683AbgEDSEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:04:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BC8A2087E;
        Mon,  4 May 2020 18:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615481;
        bh=Ics9sg11UVNE6IzrEy6Dxtn4/1sV+IZozK9ffGF+YH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EI8psk3CJoc9CkdRgJLoOr1KWf066z308ZT1EgFX/GNbgfbipmYA4ySQKPe27AZUt
         RP4XbiDDYH3CA3RgQMIkO0Ga4yDq+pp3ujFNnrQ9DbhCmN/rju5mx6laK/zKTjD51P
         lyVw5kWXR9Fm/zN/6uGX4zrK+ibDrYhu0Hckgd9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 29/57] PM: hibernate: Freeze kernel threads in software_resume()
Date:   Mon,  4 May 2020 19:57:33 +0200
Message-Id: <20200504165458.869037589@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

commit 2351f8d295ed63393190e39c2f7c1fee1a80578f upstream.

Currently the kernel threads are not frozen in software_resume(), so
between dpm_suspend_start(PMSG_QUIESCE) and resume_target_kernel(),
system_freezable_power_efficient_wq can still try to submit SCSI
commands and this can cause a panic since the low level SCSI driver
(e.g. hv_storvsc) has quiesced the SCSI adapter and can not accept
any SCSI commands: https://lkml.org/lkml/2020/4/10/47

At first I posted a fix (https://lkml.org/lkml/2020/4/21/1318) trying
to resolve the issue from hv_storvsc, but with the help of
Bart Van Assche, I realized it's better to fix software_resume(),
since this looks like a generic issue, not only pertaining to SCSI.

Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/hibernate.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -898,6 +898,13 @@ static int software_resume(void)
 	error = freeze_processes();
 	if (error)
 		goto Close_Finish;
+
+	error = freeze_kernel_threads();
+	if (error) {
+		thaw_processes();
+		goto Close_Finish;
+	}
+
 	error = load_image_and_restore();
 	thaw_processes();
  Finish:


