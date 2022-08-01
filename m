Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6CD586968
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiHAMC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbiHAMBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:01:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC8751416;
        Mon,  1 Aug 2022 04:53:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0F2361344;
        Mon,  1 Aug 2022 11:53:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFA4C433C1;
        Mon,  1 Aug 2022 11:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354814;
        bh=nD4Jw/AEkwftyi/ilIfxVsQWBaTUwluPwcx9dvaFgZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GyYMxkx6OvGVf4s8O9wmufyfgQMr5YHdcWrr6HU9XkAwJwzKbaE5EuZPO6sUxO1qG
         kzrm0O+qxuDhYlbn+dlc5jwbCVNtW8Hx6bQgpysj8ZtWbCk81PuAWMTV2tAT8SxBsY
         40m2K5k8V3Lg64FQanswJqfvzbGmgp5JCKzreX1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laurence Oberman <loberman@redhat.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        David Jeffery <djeffery@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 29/69] scsi: mpt3sas: Stop fw fault watchdog work item during system shutdown
Date:   Mon,  1 Aug 2022 13:46:53 +0200
Message-Id: <20220801114135.705169228@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Jeffery <djeffery@redhat.com>

commit 0fde22c5420ed258ee538a760291c2f3935f6a01 upstream.

During system shutdown or reboot, mpt3sas will reset the firmware back to
ready state. However, the driver leaves running a watchdog work item
intended to keep the firmware in operational state. This causes a second,
unneeded reset on shutdown and moves the firmware back to operational
instead of in ready state as intended. And if the mpt3sas_fwfault_debug
module parameter is set, this extra reset also panics the system.

mpt3sas's scsih_shutdown needs to stop the watchdog before resetting the
firmware back to ready state.

Link: https://lore.kernel.org/r/20220722142448.6289-1-djeffery@redhat.com
Fixes: fae21608c31c ("scsi: mpt3sas: Transition IOC to Ready state during shutdown")
Tested-by: Laurence Oberman <loberman@redhat.com>
Acked-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11386,6 +11386,7 @@ scsih_shutdown(struct pci_dev *pdev)
 	_scsih_ir_shutdown(ioc);
 	_scsih_nvme_shutdown(ioc);
 	mpt3sas_base_mask_interrupts(ioc);
+	mpt3sas_base_stop_watchdog(ioc);
 	ioc->shost_recovery = 1;
 	mpt3sas_base_make_ioc_ready(ioc, SOFT_RESET);
 	ioc->shost_recovery = 0;


