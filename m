Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC081541745
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348091AbiFGVCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378683AbiFGVBl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:01:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5C120E6C6;
        Tue,  7 Jun 2022 11:45:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF95061295;
        Tue,  7 Jun 2022 18:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30CEC385A2;
        Tue,  7 Jun 2022 18:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627524;
        bh=vZxaJJzTxeAFGJ7c2Tl4m1RyYnSMUABbcFd+YWzD8nA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPUqLO2a40gU5nzWGapYkjHjOxiJqLBwLI4th/0FVgekcDLMXex416mkXmyOqeo/M
         9eB531noW30V/EMQk5BEtYwNXXVOsGelOBy3wG5pJa2QNSpw/nsPLKKbukLYlFcB9W
         vWnKDCO7H/mew2Jsb+I32y2g2NIPpzJRiQkWJtkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Ni <xni@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.17 770/772] md: fix double free of io_acct_set bioset
Date:   Tue,  7 Jun 2022 19:06:02 +0200
Message-Id: <20220607165011.710849695@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

commit 42b805af102471f53e3c7867b8c2b502ea4eef7e upstream.

Now io_acct_set is alloc and free in personality. Remove the codes that
free io_acct_set in md_free and md_stop.

Fixes: 0c031fd37f69 (md: Move alloc/free acct bioset in to personality)
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5600,8 +5600,6 @@ static void md_free(struct kobject *ko)
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-	if (mddev->level != 1 && mddev->level != 10)
-		bioset_exit(&mddev->io_acct_set);
 	kfree(mddev);
 }
 
@@ -6288,8 +6286,6 @@ void md_stop(struct mddev *mddev)
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-	if (mddev->level != 1 && mddev->level != 10)
-		bioset_exit(&mddev->io_acct_set);
 }
 
 EXPORT_SYMBOL_GPL(md_stop);


