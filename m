Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7830657AC1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbiL1POr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiL1POb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:14:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4243913E39
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:14:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5D15B81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:14:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5446EC433D2;
        Wed, 28 Dec 2022 15:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240467;
        bh=tm0898h3WOXG6oC8J3n1LMoBFSGJE7ZJ/sWPjZclCxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XIGqxiD4UxqJh4/6L0JlfZmzuf30n35scd3lXgbOmHLIJaVKrGBIiHoQ78HHhT6DT
         qz4YkpxYlvUad1khGkiXdR5GBkI4uzh47LTnV0RWBq4JwBy3TTKCmY3CllwXsSQNpd
         aamqdQyw1ue9gOOcn7nzGMKkAYWeM8qv2iao9tQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0164/1073] xen/privcmd: Fix a possible warning in privcmd_ioctl_mmap_resource()
Date:   Wed, 28 Dec 2022 15:29:12 +0100
Message-Id: <20221228144332.471103748@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 8b997b2bb2c53b76a6db6c195930e9ab8e4b0c79 ]

As 'kdata.num' is user-controlled data, if user tries to allocate
memory larger than(>=) MAX_ORDER, then kcalloc() will fail, it
creates a stack trace and messes up dmesg with a warning.

Call trace:
-> privcmd_ioctl
--> privcmd_ioctl_mmap_resource

Add __GFP_NOWARN in order to avoid too large allocation warning.
This is detected by static analysis using smatch.

Fixes: 3ad0876554ca ("xen/privcmd: add IOCTL_PRIVCMD_MMAP_RESOURCE")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20221126050745.778967-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/privcmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/privcmd.c b/drivers/xen/privcmd.c
index e88e8f6f0a33..719c5d1dda27 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -760,7 +760,7 @@ static long privcmd_ioctl_mmap_resource(struct file *file,
 		goto out;
 	}
 
-	pfns = kcalloc(kdata.num, sizeof(*pfns), GFP_KERNEL);
+	pfns = kcalloc(kdata.num, sizeof(*pfns), GFP_KERNEL | __GFP_NOWARN);
 	if (!pfns) {
 		rc = -ENOMEM;
 		goto out;
-- 
2.35.1



