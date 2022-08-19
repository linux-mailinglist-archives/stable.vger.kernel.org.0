Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE27059A0E0
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352080AbiHSQTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352451AbiHSQQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:16:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58435116ECA;
        Fri, 19 Aug 2022 09:00:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B67DB82814;
        Fri, 19 Aug 2022 15:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71BAC433D6;
        Fri, 19 Aug 2022 15:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924797;
        bh=YdPA2pUsmy1j4WukL3ftC+x/O9+nLCAZcpceB+7WrAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5SqKM/45JS5PWFbygA9vPWeauYpkhrnABZWiEfIyPtKtM/IKwujcXwUfIIdSo/fh
         ZiED/g86ai54L1VUVEOXWWJFLSyiD9ju8/LjyUzLClXzJnIfg9eSfIBPnD/tCzcyGX
         ClFsmORu72A/syw4bUkeNWOvG2CPY+xp5dkzjvNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Marco Pagani <marpagan@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 278/545] fpga: altera-pr-ip: fix unsigned comparison with less than zero
Date:   Fri, 19 Aug 2022 17:40:48 +0200
Message-Id: <20220819153841.759220471@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 2cf25fd5e897..75b4b3ec933a 100644
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



