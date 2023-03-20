Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047406C0840
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 02:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjCTBHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 21:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbjCTBHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 21:07:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B7A265A7;
        Sun, 19 Mar 2023 17:59:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BEE1611EE;
        Mon, 20 Mar 2023 00:57:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC117C433EF;
        Mon, 20 Mar 2023 00:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273869;
        bh=doUINzl8CjaZfid4C522zUPd5p8Wyavp513+b6Q7ulY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iMcILWrVA8TlqxeyWJCj9FcCGeV710WG9wNsungIVIwcKy/w2oNWp8yCkS4AY4rNa
         TYwLedPMLVRb+P9n34JPNChj5l2PmN9UGbBQCpjzUjJ/TaKnqrYgTg7SuLhwNQAUd0
         Kmi0utEZq70cJdzSBgfkpncq6pM+auPlA7JzkYlxbUWh7HZfQmbO3zE8E5i/CCJJCW
         NPHoRBTEi1b/uXDra+pWK0Z44isZeZZXdMVc/HcdBbeecGxm9q6ypgR7YEzd0wAREh
         M54H//ZE5GJY7m/tpq0owYgrgJb8BtG4EG9xfq4LsZv5JSR+kyzRzHpTTvwZvPkIn8
         PIiXyUZzi7Acw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrien Thierry <athierry@redhat.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jejb@linux.ibm.com,
        beanhuo@micron.com, bvanassche@acm.org, avri.altman@wdc.com,
        keosung.park@samsung.com, kwmad.kim@samsung.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 6/9] scsi: ufs: core: Add soft dependency on governor_simpleondemand
Date:   Sun, 19 Mar 2023 20:57:29 -0400
Message-Id: <20230320005732.1429533-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005732.1429533-1-sashal@kernel.org>
References: <20230320005732.1429533-1-sashal@kernel.org>
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
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 694c0fc31fbf7..fe7db66ab1f3e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8087,5 +8087,6 @@ EXPORT_SYMBOL_GPL(ufshcd_init);
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
-- 
2.39.2

