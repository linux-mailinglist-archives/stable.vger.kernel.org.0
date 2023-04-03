Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4CC6D4820
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbjDCO0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233303AbjDCO0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:26:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A6B31297
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:25:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CDB961D99
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667CFC433EF;
        Mon,  3 Apr 2023 14:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531956;
        bh=n0lxD0L/T/xjNVlKjGvIwM+TJoX1yR+9PzsF+/rIxWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcFwuZtKvoyBgt1jjXh2yOviXRbfXGtGn3v8wxrLcGikR77ZYfYlctrv4jPAePx16
         yuXK8abfqrdeR819V9lm2jX3W0usrs1VB8SLDNVwWvvisAow6COWqANPVViAjZaL1x
         4hxNFqGRcB+N6WIpHavcI0Q7HXi4TE8KyoF87KA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrien Thierry <athierry@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/173] scsi: ufs: core: Add soft dependency on governor_simpleondemand
Date:   Mon,  3 Apr 2023 16:08:06 +0200
Message-Id: <20230403140416.741071519@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
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
index ea6ceab1a1b25..f3389e9131794 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9311,5 +9311,6 @@ EXPORT_SYMBOL_GPL(ufshcd_init);
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
-- 
2.39.2



