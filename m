Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920EB14C16
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbfEFOgP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:36:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:56526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbfEFOgO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:36:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2401204EC;
        Mon,  6 May 2019 14:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153373;
        bh=LxzFWw3LldBNN96O7zHupf961vJFiKBQee29drPGHdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGKZVMUNLc7pg7mBSLKbvqrnLOWv4jhQBdv3dUUp3plg/ooyRrinpZkM/Xabto5gr
         ko6E2ueIhD27Y7t0uifATLCoBs2dt8A3dLTFW9gPbc6NTRDOZJyy/WItpiZePo2vxS
         1i5qqxlL4mh8QZj/0KhJnxNUovSr3RnCi4g3XKJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Long Li <longli@microsoft.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 064/122] scsi: storvsc: Fix calculation of sub-channel count
Date:   Mon,  6 May 2019 16:32:02 +0200
Message-Id: <20190506143100.713256282@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 382e06d11e075a40b4094b6ef809f8d4bcc7ab2a ]

When the number of sub-channels offered by Hyper-V is >= the number of CPUs
in the VM, calculate the correct number of sub-channels.  The current code
produces one too many.

This scenario arises only when the number of CPUs is artificially
restricted (for example, with maxcpus=<n> on the kernel boot line), because
Hyper-V normally offers a sub-channel count < number of CPUs.  While the
current code doesn't break, the extra sub-channel is unbalanced across the
CPUs (for example, a total of 5 channels on a VM with 4 CPUs).

Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 84380bae20f1..e186743033f4 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -668,13 +668,22 @@ static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 {
 	struct device *dev = &device->device;
 	struct storvsc_device *stor_device;
-	int num_cpus = num_online_cpus();
 	int num_sc;
 	struct storvsc_cmd_request *request;
 	struct vstor_packet *vstor_packet;
 	int ret, t;
 
-	num_sc = ((max_chns > num_cpus) ? num_cpus : max_chns);
+	/*
+	 * If the number of CPUs is artificially restricted, such as
+	 * with maxcpus=1 on the kernel boot line, Hyper-V could offer
+	 * sub-channels >= the number of CPUs. These sub-channels
+	 * should not be created. The primary channel is already created
+	 * and assigned to one CPU, so check against # CPUs - 1.
+	 */
+	num_sc = min((int)(num_online_cpus() - 1), max_chns);
+	if (!num_sc)
+		return;
+
 	stor_device = get_out_stor_device(device);
 	if (!stor_device)
 		return;
-- 
2.20.1



