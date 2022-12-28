Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890C3657ADD
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbiL1PPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbiL1PPn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:15:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72CBE226
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:15:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A10EB8172C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BFEC433D2;
        Wed, 28 Dec 2022 15:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240539;
        bh=1o4b6ux47ElfBz8ppsDDtaebJJOsA5dNlSdP9KGmD74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUn5itE0UOdS2+JZp9Xw3+WjK0s7OrngPkS3fbctpR9ZP9SMnUqU2KUkOnqpBLE3C
         5cjsUcX3Ta7rhLEc/jOICU3689ReLwFkP8D+OpVyQ6rNKfxsMVwT+sx4Am9rmooN7p
         DrR1J8F4jcNqc7jfRZhfgELcBHLeiz7N6dRDUuMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Huisong Li <lihuisong@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0137/1146] mailbox: pcc: Reset pcc_chan_count to zero in case of PCC probe failure
Date:   Wed, 28 Dec 2022 15:27:56 +0100
Message-Id: <20221228144333.870987602@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 6d7d3c287410c0ad499e478e2338dc3d7e3392b1 ]

Currently, 'pcc_chan_count' is remains set to a non-zero value if PCC
subspaces are parsed successfully but something else fail later during
the initial PCC probing phase. This will result in pcc_mbox_request_channel
trying to access the resources that are not initialised or allocated and
may end up in a system crash.

Reset pcc_chan_count to 0 when the PCC probe fails in order to prevent
the possible issue as described above.

Fixes: ce028702ddbc ("mailbox: pcc: Move bulk of PCCT parsing into pcc_mbox_probe")
Signed-off-by: Huisong Li <lihuisong@huawei.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/pcc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mailbox/pcc.c b/drivers/mailbox/pcc.c
index 3c2bc0ca454c..105d46c9801b 100644
--- a/drivers/mailbox/pcc.c
+++ b/drivers/mailbox/pcc.c
@@ -743,6 +743,7 @@ static int __init pcc_init(void)
 
 	if (IS_ERR(pcc_pdev)) {
 		pr_debug("Err creating PCC platform bundle\n");
+		pcc_chan_count = 0;
 		return PTR_ERR(pcc_pdev);
 	}
 
-- 
2.35.1



