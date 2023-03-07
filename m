Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0833B6AEAFF
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbjCGRjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbjCGRiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:38:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8DE8FBD0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:34:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8859B6150D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803B2C433D2;
        Tue,  7 Mar 2023 17:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210495;
        bh=/GxsDY7jvjgHH/dQbFQCDMUFygABZuqR96LXXOnbeGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HcphxqDqo3ZZU0MGSHD3bcfg+ctaTovh9vtQxMjsk3TsV66ROkbWfomS+nGJ/AaCp
         P7z97aDGBUra5s8OTHx6H8OC5KQaEuYwY4F8cSWAJ7tfX0mOvHusBPS/lplYzFljb4
         SW0e4h92EDeu8fzvzqrxYvisA4Q0mRXQsmqcMt9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nicolin Chen <nicolinc@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0529/1001] selftests: iommu: Fix test_cmd_destroy_access() call in user_copy
Date:   Tue,  7 Mar 2023 17:55:01 +0100
Message-Id: <20230307170044.416541358@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit 9fabbdf338b701f2d763d9edbc3e82ce1e7fa1b4 ]

The test_cmd_destroy_access() should end with a semicolon, so add one.
There is a test_ioctl_destroy(ioas_id) following already, so drop one.

Fixes: 57f0988706fe ("iommufd: Add a selftest")
Link: https://lore.kernel.org/r/20230120074204.1368-1-nicolinc@nvidia.com
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/iommu/iommufd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 8aa8a346cf221..fa08209268c42 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1259,7 +1259,7 @@ TEST_F(iommufd_mock_domain, user_copy)
 
 	test_cmd_destroy_access_pages(
 		access_cmd.id, access_cmd.access_pages.out_access_pages_id);
-	test_cmd_destroy_access(access_cmd.id) test_ioctl_destroy(ioas_id);
+	test_cmd_destroy_access(access_cmd.id);
 
 	test_ioctl_destroy(ioas_id);
 }
-- 
2.39.2



