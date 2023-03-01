Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCCA6A72DC
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjCASKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCASKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:10:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3CA6A71
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:10:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 250976144F
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3594FC433D2;
        Wed,  1 Mar 2023 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694206;
        bh=v5IyuwQCotLY7daXG6PinQsArQD6pCT0TqrbWEQcUUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bePtBfG5jCFdSnXYfMcB6zx647AjSh2kn7rj1T0/h5001vjiHPPyfRod8SoLttPoC
         dZMSGqo7HZX99soqJO+TqMR3bcm4PCbVGpM9Jrw+ZoJ0FeTQGTx/c1VMDccNLqICzU
         VfP2ldVgPptxNzB8s8N1khXgIYjMQz+ollxsRm0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, David Sloan <david.sloan@eideticom.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Song Liu <song@kernel.org>, Hou Tao <houtao1@huawei.com>
Subject: [PATCH 5.10 12/19] md: Flush workqueue md_rdev_misc_wq in md_alloc()
Date:   Wed,  1 Mar 2023 19:08:41 +0100
Message-Id: <20230301180652.836725407@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
References: <20230301180652.316428563@linuxfoundation.org>
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

From: David Sloan <david.sloan@eideticom.com>

commit 5e8daf906f890560df430d30617c692a794acb73 upstream.

A race condition still exists when removing and re-creating md devices
in test cases. However, it is only seen on some setups.

The race condition was tracked down to a reference still being held
to the kobject by the rdev in the md_rdev_misc_wq which will be released
in rdev_delayed_delete().

md_alloc() waits for previous deletions by waiting on the md_misc_wq,
but the md_rdev_misc_wq may still be holding a reference to a recently
removed device.

To fix this, also flush the md_rdev_misc_wq in md_alloc().

Signed-off-by: David Sloan <david.sloan@eideticom.com>
[logang@deltatee.com: rewrote commit message]
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5683,6 +5683,7 @@ static int md_alloc(dev_t dev, char *nam
 	 * completely removed (mddev_delayed_delete).
 	 */
 	flush_workqueue(md_misc_wq);
+	flush_workqueue(md_rdev_misc_wq);
 
 	mutex_lock(&disks_mutex);
 	error = -EEXIST;


