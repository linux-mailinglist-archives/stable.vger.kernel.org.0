Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616764FD176
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351180AbiDLG6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352246AbiDLGzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:55:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ABE539825;
        Mon, 11 Apr 2022 23:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7F0A8CE1C0B;
        Tue, 12 Apr 2022 06:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF51C385A1;
        Tue, 12 Apr 2022 06:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745906;
        bh=L4AE/btcFbCZktUVXKI6UoJsesrXhv9p0ciRMSDqhhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKeDETOoVvWaLnIYbHVEJeEyt1J5dS/rf/ba8KbFnUlK/m8U2eIS5SkcC4wXnjzzO
         r3alXbeo50Q0gs2pCte2WXKZlHj5F6P4jilssW0AEBY15YtGRdvO6AQqoTN8JUdmdd
         Jwxn+EjuKXSMFPQuIY/jqK6rQ15rGyyKvrzNOt2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/277] powerpc/secvar: fix refcount leak in format_show()
Date:   Tue, 12 Apr 2022 08:28:12 +0200
Message-Id: <20220412062944.621212296@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit d601fd24e6964967f115f036a840f4f28488f63f ]

Refcount leak will happen when format_show returns failure in multiple
cases. Unified management of of_node_put can fix this problem.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220302021959.10959-1-hbh25y@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/secvar-sysfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/secvar-sysfs.c b/arch/powerpc/kernel/secvar-sysfs.c
index a0a78aba2083..1ee4640a2641 100644
--- a/arch/powerpc/kernel/secvar-sysfs.c
+++ b/arch/powerpc/kernel/secvar-sysfs.c
@@ -26,15 +26,18 @@ static ssize_t format_show(struct kobject *kobj, struct kobj_attribute *attr,
 	const char *format;
 
 	node = of_find_compatible_node(NULL, NULL, "ibm,secvar-backend");
-	if (!of_device_is_available(node))
-		return -ENODEV;
+	if (!of_device_is_available(node)) {
+		rc = -ENODEV;
+		goto out;
+	}
 
 	rc = of_property_read_string(node, "format", &format);
 	if (rc)
-		return rc;
+		goto out;
 
 	rc = sprintf(buf, "%s\n", format);
 
+out:
 	of_node_put(node);
 
 	return rc;
-- 
2.35.1



