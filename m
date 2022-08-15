Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0C4594FC9
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiHPEcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiHPEcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:32:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83964B0C7;
        Mon, 15 Aug 2022 13:22:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6196EB8119B;
        Mon, 15 Aug 2022 20:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A214C43149;
        Mon, 15 Aug 2022 20:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594940;
        bh=k7nHqZv4WUM/Gzvi9+9Lkzl3Yklu7UNR2pB54Dnes3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Seeuo0RRZOrMfMh1y/FzyslACsU0FW9frW9NXP/tjYqsTqp4LHthLrcG9NEEM8Iky
         WdPvqVfPqNWjlkC5M84hY4+putkMx6lmkYM0gHGYmC38XliqevM4F+oYEZB/9VRbt9
         O+VhNzAF230l9+26o6ViEM0rBwQmDZv9gdIUV9rM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Marco Pagani <marpagan@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0606/1157] fpga: altera-pr-ip: fix unsigned comparison with less than zero
Date:   Mon, 15 Aug 2022 19:59:22 +0200
Message-Id: <20220815180503.912705347@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marco Pagani <marpagan@redhat.com>

[ Upstream commit 2df84a757d87fd62869fc401119d429735377ec5 ]

Fix the "comparison with less than zero" warning reported by
cppcheck for the unsigned (size_t) parameter count of the
alt_pr_fpga_write() function.

Fixes: d201cc17a8a3 ("fpga pr ip: Core driver support for Altera Partial Reconfiguration IP")
Reviewed-by: Tom Rix <trix@redhat.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Marco Pagani <marpagan@redhat.com>
Link: https://lore.kernel.org/r/20220609140520.42662-1-marpagan@redhat.com
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fpga/altera-pr-ip-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fpga/altera-pr-ip-core.c b/drivers/fpga/altera-pr-ip-core.c
index be0667968d33..df8671af4a92 100644
--- a/drivers/fpga/altera-pr-ip-core.c
+++ b/drivers/fpga/altera-pr-ip-core.c
@@ -108,7 +108,7 @@ static int alt_pr_fpga_write(struct fpga_manager *mgr, const char *buf,
 	u32 *buffer_32 = (u32 *)buf;
 	size_t i = 0;
 
-	if (count <= 0)
+	if (!count)
 		return -EINVAL;
 
 	/* Write out the complete 32-bit chunks */
-- 
2.35.1



