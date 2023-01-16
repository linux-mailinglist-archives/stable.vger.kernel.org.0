Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C7366C6A7
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbjAPQWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbjAPQWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:22:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B97930B1E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:12:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55D18B8107E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC4BC433D2;
        Mon, 16 Jan 2023 16:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885533;
        bh=/8c965TZvXbNY2OYtt0rzWYIeWSMWpVtu/BgsvOZznQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zdz90sxgPbtonkpur1/V+WQLJuXcvrYntvYkjpaNZjsW9LN6oojrU5UdHoUrGfutf
         8eDhgSVuq7Z+26XrRLY5Vb6Z4aNPESvzlUPzMQbwAglcjqHX8WJ26Au7PlYA6eLtpo
         AK8zx+XzKt5tkJhPRkkw7+sXw3XS+E8AE96gdp3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/658] xen/privcmd: Fix a possible warning in privcmd_ioctl_mmap_resource()
Date:   Mon, 16 Jan 2023 16:42:55 +0100
Message-Id: <20230116154913.558349917@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index d4ff944cd16e..c4b0de4a542b 100644
--- a/drivers/xen/privcmd.c
+++ b/drivers/xen/privcmd.c
@@ -766,7 +766,7 @@ static long privcmd_ioctl_mmap_resource(struct file *file,
 		goto out;
 	}
 
-	pfns = kcalloc(kdata.num, sizeof(*pfns), GFP_KERNEL);
+	pfns = kcalloc(kdata.num, sizeof(*pfns), GFP_KERNEL | __GFP_NOWARN);
 	if (!pfns) {
 		rc = -ENOMEM;
 		goto out;
-- 
2.35.1



