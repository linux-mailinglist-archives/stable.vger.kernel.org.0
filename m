Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A9E6C071D
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 01:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCTAyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 20:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCTAyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 20:54:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BA11EBF8;
        Sun, 19 Mar 2023 17:53:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF115611DE;
        Mon, 20 Mar 2023 00:53:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B078C433EF;
        Mon, 20 Mar 2023 00:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273615;
        bh=L9RN7mIYZt9CjiK1vEyQDGPTtyReLU5V0i2bLRjJsqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7/DWBWYV+K+OsCv629J8XeO779JpfccndBww7CypHiyfOMyZ6wx44P06Epfkj1S+
         FUlZ+13FdHE/er5hx0KyKpxgoweeVOpxrbPyPlObV3c0xuChTMrekjM5CpR0lP/Tr+
         v9IhG36XeOaiRB1Xxg4bFNsNWq1Jsh0VKuS6kMAJwkuOCY0VVYo4bmFGy2f6X8k5Ng
         8+/3gtM6xspUQyV1nqdVwcuEJ0X+UmnoV8XWI+enDZGmfn2ODrrBMCQcEi/QIpANN5
         I1DZPFabIPpgDRS02cgS6Z9fAjwTTdZAmsYOotAM601YetbAqRGkdOG6DryB6ONL52
         UCJQCQH1UcsHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrien Thierry <athierry@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        bvanassche@acm.org, beanhuo@micron.com, avri.altman@wdc.com,
        stanley.chu@mediatek.com, quic_asutoshd@quicinc.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 13/30] scsi: ufs: core: Add soft dependency on governor_simpleondemand
Date:   Sun, 19 Mar 2023 20:52:38 -0400
Message-Id: <20230320005258.1428043-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005258.1428043-1-sashal@kernel.org>
References: <20230320005258.1428043-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2ddc1aba0ad75..edb93d2c5a781 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10095,4 +10095,5 @@ module_exit(ufshcd_core_exit);
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL");
-- 
2.39.2

