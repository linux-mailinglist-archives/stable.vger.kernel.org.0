Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F91B6AF48E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbjCGTR1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:17:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233872AbjCGTRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:17:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0360B1B14
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:00:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A457AB819CD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DC1C433D2;
        Tue,  7 Mar 2023 19:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215646;
        bh=E5C9eRSjb4jhhBjIIuj1jyOuC8+VXj2f0WFILncqjwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohG6LNB1weBN3unpI4LCHBjR7UL8cBi0DtJgpK2EuYfTU2K06ANmJYVBIrvrdDYcV
         J78BxOPIUONccHtEO6jeTpzEJNv0GqgUOxCQqtw66vxPbycT2ZtB5Vb1J23zQwiIG8
         qFEjsKiIymTGY8kbSpiWIecrBU0QMAsMlFcxHdIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Alexey V. Vissarionov" <gremlin@altlinux.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 296/567] PCI/IOV: Enlarge virtfn sysfs name buffer
Date:   Tue,  7 Mar 2023 18:00:32 +0100
Message-Id: <20230307165918.699324327@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Alexey V. Vissarionov <gremlin@altlinux.org>

[ Upstream commit ea0b5aa5f184cf8293c93163f0fb00505190d431 ]

The sysfs link name "virtfn%u" constructed by pci_iov_sysfs_link() requires
17 bytes to contain the longest possible string.  Increase VIRTFN_ID_LEN to
accommodate that.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

[bhelgaas: commit log, comment at #define]
Fixes: dd7cc44d0bce ("PCI: add SR-IOV API for Physical Function driver")
Link: https://lore.kernel.org/r/20221218033347.23743-1-gremlin@altlinux.org
Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/iov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index dafdc652fcd06..ef71c1a204004 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -14,7 +14,7 @@
 #include <linux/delay.h>
 #include "pci.h"
 
-#define VIRTFN_ID_LEN	16
+#define VIRTFN_ID_LEN	17	/* "virtfn%u\0" for 2^32 - 1 */
 
 int pci_iov_virtfn_bus(struct pci_dev *dev, int vf_id)
 {
-- 
2.39.2



