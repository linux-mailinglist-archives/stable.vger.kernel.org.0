Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AA96B42CD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbjCJOHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:07:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbjCJOGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:06:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E622411A2E5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:06:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCE1360F11
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D219BC433D2;
        Fri, 10 Mar 2023 14:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457186;
        bh=XL/03RXm0WnyUahqdPAzHe12OCeHb+UjU+1NbW7TfMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ri4xCtgfOQ1wldPlDYqGaND+uvQr+9eyQbugQSAVY/Sq3wVn8/jnXOvUpqkmyeRn8
         p58LOPT93dnSTXBbEdTaR/Q9aItpa0iUP0OcbKV6ao6rY1zPIFXPDfdD/hGqUiolun
         TEuMwbgtmfn6zbf7hFbbUcz+of9Ynj765bEKBKrA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Benjamin Berg <benjamin.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/200] um: virtio_uml: free command if adding to virtqueue failed
Date:   Fri, 10 Mar 2023 14:37:36 +0100
Message-Id: <20230310133718.605641928@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 8a6ca543646f2940832665dbf4e04105262505e2 ]

If adding the command fails (i.e. the virtqueue is broken) then free it
again if the function allocated a new buffer for it.

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/virt-pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/virt-pci.c b/arch/um/drivers/virt-pci.c
index 3ac220dafec4a..3b637ad75ec81 100644
--- a/arch/um/drivers/virt-pci.c
+++ b/arch/um/drivers/virt-pci.c
@@ -132,8 +132,11 @@ static int um_pci_send_cmd(struct um_pci_device *dev,
 				out ? 1 : 0,
 				posted ? cmd : HANDLE_NO_FREE(cmd),
 				GFP_ATOMIC);
-	if (ret)
+	if (ret) {
+		if (posted)
+			kfree(cmd);
 		goto out;
+	}
 
 	if (posted) {
 		virtqueue_kick(dev->cmd_vq);
-- 
2.39.2



