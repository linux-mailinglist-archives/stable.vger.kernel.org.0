Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4BB6AEEC1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbjCGSPz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbjCGSOy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:14:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDECDA42E9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:10:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEE676152F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73DCC4339B;
        Tue,  7 Mar 2023 18:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212635;
        bh=guo0JD4nztg1lIPn7QFGXXnuDWf2Ws87y9oFWgkHy2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1EVqpDpuzQk8mBxuO3zeKri4/PcmwwSfM6MWBAG1IOcLZWEvwaEuiUm1YgkiaVU6d
         a03ec0ySSFdYrm2kVHFNVjAwDfGbVXAwEPbSb0c7B9jM8S0vPx7JKUvyxcqiV+BI+A
         ZeOxR/tMIeftJLNK6i7xdz5ZQoAOFDn02tco7Yck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Halil Pasic <pasic@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 217/885] s390: vfio-ap: tighten the NIB validity check
Date:   Tue,  7 Mar 2023 17:52:31 +0100
Message-Id: <20230307170011.511873149@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit a64a6d23874c574d30a9816124b2dc37467f3811 ]

The NIB is architecturally invalid if the address designates a
storage location that is not installed or if it is zero.

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reported-by: Janosch Frank <frankja@linux.ibm.com>
Fixes: ec89b55e3bce ("s390: ap: implement PAPQ AQIC interception in kernel")
Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index a109c59f18f78..934515959ebf4 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -349,6 +349,8 @@ static int vfio_ap_validate_nib(struct kvm_vcpu *vcpu, dma_addr_t *nib)
 {
 	*nib = vcpu->run->s.regs.gprs[2];
 
+	if (!*nib)
+		return -EINVAL;
 	if (kvm_is_error_hva(gfn_to_hva(vcpu->kvm, *nib >> PAGE_SHIFT)))
 		return -EINVAL;
 
-- 
2.39.2



