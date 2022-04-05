Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728074F2B7D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353825AbiDEKJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345715AbiDEJW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AE06C93E;
        Tue,  5 Apr 2022 02:11:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B0FE61576;
        Tue,  5 Apr 2022 09:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2FEC385A3;
        Tue,  5 Apr 2022 09:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149915;
        bh=M2HW2u6mb6qGddNZWFRKlpSxxiVPpbV9atQ2sW9Vccs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hcascdrEHAu642vsv0HYl0IwdF6nRT9bA2D4PQ8ckLGslpfYzbKF5/8bncQEG0FsB
         yRytU6N9gAQKMZwxot5aXx0a4FesL6jS/p0RZDidO2X6a4md3f9LGUC1YADPl2rnjk
         v4XLsGwMEQp4BdWcPwzYbJnXF1crF2zfDbNkbGqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0888/1017] scsi: qla2xxx: Suppress a kernel complaint in qla_create_qpair()
Date:   Tue,  5 Apr 2022 09:30:01 +0200
Message-Id: <20220405070420.588976189@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Saurav Kashyap <skashyap@marvell.com>

commit a60447e7d451df42c7bde43af53b34f10f34f469 upstream.

[   12.323788] BUG: using smp_processor_id() in preemptible [00000000] code: systemd-udevd/1020
[   12.332297] caller is qla2xxx_create_qpair+0x32a/0x5d0 [qla2xxx]
[   12.338417] CPU: 7 PID: 1020 Comm: systemd-udevd Tainted: G          I      --------- ---  5.14.0-29.el9.x86_64 #1
[   12.348827] Hardware name: Dell Inc. PowerEdge R610/0F0XJ6, BIOS 6.6.0 05/22/2018
[   12.356356] Call Trace:
[   12.358821]  dump_stack_lvl+0x34/0x44
[   12.362514]  check_preemption_disabled+0xd9/0xe0
[   12.367164]  qla2xxx_create_qpair+0x32a/0x5d0 [qla2xxx]
[   12.372481]  qla2x00_probe_one+0xa3a/0x1b80 [qla2xxx]
[   12.377617]  ? _raw_spin_lock_irqsave+0x19/0x40
[   12.384284]  local_pci_probe+0x42/0x80
[   12.390162]  ? pci_match_device+0xd7/0x110
[   12.396366]  pci_device_probe+0xfd/0x1b0
[   12.402372]  really_probe+0x1e7/0x3e0
[   12.408114]  __driver_probe_device+0xfe/0x180
[   12.414544]  driver_probe_device+0x1e/0x90
[   12.420685]  __driver_attach+0xc0/0x1c0
[   12.426536]  ? __device_attach_driver+0xe0/0xe0
[   12.433061]  ? __device_attach_driver+0xe0/0xe0
[   12.439538]  bus_for_each_dev+0x78/0xc0
[   12.445294]  bus_add_driver+0x12b/0x1e0
[   12.451021]  driver_register+0x8f/0xe0
[   12.456631]  ? 0xffffffffc07bc000
[   12.461773]  qla2x00_module_init+0x1be/0x229 [qla2xxx]
[   12.468776]  do_one_initcall+0x44/0x200
[   12.474401]  ? load_module+0xad3/0xba0
[   12.479908]  ? kmem_cache_alloc_trace+0x45/0x410
[   12.486268]  do_init_module+0x5c/0x280
[   12.491730]  __do_sys_init_module+0x12e/0x1b0
[   12.497785]  do_syscall_64+0x3b/0x90
[   12.503029]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   12.509764] RIP: 0033:0x7f554f73ab2e

Link: https://lore.kernel.org/r/20220110050218.3958-15-njavali@marvell.com
Cc: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -9417,7 +9417,7 @@ struct qla_qpair *qla2xxx_create_qpair(s
 		qpair->rsp->req = qpair->req;
 		qpair->rsp->qpair = qpair;
 		/* init qpair to this cpu. Will adjust at run time. */
-		qla_cpu_update(qpair, smp_processor_id());
+		qla_cpu_update(qpair, raw_smp_processor_id());
 
 		if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
 			if (ha->fw_attributes & BIT_4)


