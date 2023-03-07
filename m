Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC1D6AF48F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbjCGTR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjCGTRH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:17:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAA519686
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:00:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7DD43B8117B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F36C433EF;
        Tue,  7 Mar 2023 19:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215649;
        bh=FsfqB/Rz0DTeXnEJn+qm4vqIdb+Ag8LvKdenWxvavFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTPMFUuD1HRjmMVRcPqTSCRxr0hSUQM+ZLjFtULYWMi+H5UTlex72M6Mm4ZJBz/zb
         Tx9bAEgYp+CHHKJuhq/fbuwD+ucyz3Yo5MyLwpm4Zwg6imveG91UBEcH3kAqq1tSDo
         aUIyu3X2WFZ7c7cSVcFla39VanhbaQAAZaR0fLNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 297/567] PCI: switchtec: Return -EFAULT for copy_to_user() errors
Date:   Tue,  7 Mar 2023 18:00:33 +0100
Message-Id: <20230307165918.737814200@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit ddc10938e08cd7aac63d8385f7305f7889df5179 ]

switchtec_dev_read() didn't handle copy_to_user() errors correctly: it
assigned "rc = -EFAULT", but actually returned either "size", -ENXIO, or
-EBADMSG instead.

Update the failure cases to unlock mrpc_mutex and return -EFAULT directly.

Link: https://lore.kernel.org/r/20221216162126.207863-3-helgaas@kernel.org
Fixes: 080b47def5e5 ("MicroSemi Switchtec management interface driver")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/switch/switchtec.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index 0b301f8be9ed5..d021ef3fb165b 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -552,21 +552,20 @@ static ssize_t switchtec_dev_read(struct file *filp, char __user *data,
 	rc = copy_to_user(data, &stuser->return_code,
 			  sizeof(stuser->return_code));
 	if (rc) {
-		rc = -EFAULT;
-		goto out;
+		mutex_unlock(&stdev->mrpc_mutex);
+		return -EFAULT;
 	}
 
 	data += sizeof(stuser->return_code);
 	rc = copy_to_user(data, &stuser->data,
 			  size - sizeof(stuser->return_code));
 	if (rc) {
-		rc = -EFAULT;
-		goto out;
+		mutex_unlock(&stdev->mrpc_mutex);
+		return -EFAULT;
 	}
 
 	stuser_set_state(stuser, MRPC_IDLE);
 
-out:
 	mutex_unlock(&stdev->mrpc_mutex);
 
 	if (stuser->status == SWITCHTEC_MRPC_STATUS_DONE)
-- 
2.39.2



