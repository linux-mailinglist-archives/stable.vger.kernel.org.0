Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF2C59DB6B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354082AbiHWKcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354616AbiHWK22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:28:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC39D84EF5;
        Tue, 23 Aug 2022 02:06:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0AFAACE1B55;
        Tue, 23 Aug 2022 09:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22568C433B5;
        Tue, 23 Aug 2022 09:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245566;
        bh=1HheMQ0rOndr83yFbEnl+ikT2KqMkrmBSB+eHXVVNvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjWsgpKbN3dv3t5SsAnMdd3KDN9u3R51r1Ou/oDZdKpuZCi8IotC0fPVdHfY6aFEE
         9V1SB7c0P/ID8XhO+CZVMU9aIWeSNv16xyfWa9iD+MiJ3dlDC+VXUkM8JmnjfA9glk
         eAX7wuW1/1YWOITrmSZmIaKaFRkvzCbRqPSSXt9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Marco Pagani <marpagan@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 119/287] fpga: altera-pr-ip: fix unsigned comparison with less than zero
Date:   Tue, 23 Aug 2022 10:24:48 +0200
Message-Id: <20220823080104.389848938@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index 65e0b6a2c031..059ba27f3c29 100644
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



