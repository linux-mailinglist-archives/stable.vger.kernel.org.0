Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500B86CC4F4
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbjC1PKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjC1PKs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:10:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DFDD338
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:09:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A5FC61868
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853C5C433EF;
        Tue, 28 Mar 2023 15:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016180;
        bh=ZIqqAi1Aqp/PnHI5op9EedBT9Fves+Luk6TpnzEmVTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNHpLQPCUK5qSeX13QX+t48j94H8+9a/H2KV8JF2Xq+e+1vIn8no5/4F0EOhu6HO6
         +/b9GAhfmQeFOO0y+CHL99+EoJsvc79xjxg+/risNQNSJd2bOHlmIJCyOfljuBedjG
         sWAXd/SbnBl94bodGqO/K174xP8+fkcQOKi2edu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrien Thierry <athierry@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/146] scsi: ufs: core: Add soft dependency on governor_simpleondemand
Date:   Tue, 28 Mar 2023 16:43:02 +0200
Message-Id: <20230328142606.574328369@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrien Thierry <athierry@redhat.com>

[ Upstream commit 2ebe16155dc8bd4e602cad5b5f65458d2eaa1a75 ]

The ufshcd driver uses simpleondemand governor for devfreq. Add it to the
list of ufshcd softdeps to allow userspace initramfs tools like dracut to
automatically pull the governor module into the initramfs together with UFS
drivers.

Link: https://lore.kernel.org/r/20230220140740.14379-1-athierry@redhat.com
Signed-off-by: Adrien Thierry <athierry@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index eaa91aec036b1..fd430d24f6de9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9749,5 +9749,6 @@ module_exit(ufshcd_core_exit);
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
-- 
2.39.2



