Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEDD4CF9F2
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbiCGKNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242687AbiCGKLs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C4D8BF45;
        Mon,  7 Mar 2022 01:55:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73E3360C6F;
        Mon,  7 Mar 2022 09:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7328EC340E9;
        Mon,  7 Mar 2022 09:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646940;
        bh=KrTFHDpNYz0Hi1piL5IXO5zTjCF0l7e7t4xnvie0lic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5wI6ZrrDtud11bKk6Zxmmxb9lNHNi9WP5mfakXXEnIj5enIApGL6AH3NqlTwmjZQ
         oYSee1PseEPE6hWQ6EQrYYjofLd5SRjX2cbH6rm65aJcR5l/XBO5YjQx2GTV6dDmGD
         8BOe9LpwdFhFgkn3xVKg0+IGc2cS8aYnVExtxErU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 140/186] ibmvnic: initialize rc before completing wait
Date:   Mon,  7 Mar 2022 10:19:38 +0100
Message-Id: <20220307091657.992591568@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit 765559b10ce514eb1576595834f23cdc92125fee ]

We should initialize ->init_done_rc before calling complete(). Otherwise
the waiting thread may see ->init_done_rc as 0 before we have updated it
and may assume that the CRQ was successful.

Fixes: 6b278c0cb378 ("ibmvnic delay complete()")
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 996da870dafe..945a84c2134f 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -5319,9 +5319,9 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
 			}
 
 			if (!completion_done(&adapter->init_done)) {
-				complete(&adapter->init_done);
 				if (!adapter->init_done_rc)
 					adapter->init_done_rc = -EAGAIN;
+				complete(&adapter->init_done);
 			}
 
 			break;
-- 
2.34.1



