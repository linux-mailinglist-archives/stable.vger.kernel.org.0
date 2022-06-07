Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E86A54225B
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345889AbiFHCrL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 22:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447800AbiFHCoG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 22:44:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAFA719CB5B;
        Tue,  7 Jun 2022 12:25:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30ED460C7F;
        Tue,  7 Jun 2022 19:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3683FC385A2;
        Tue,  7 Jun 2022 19:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629951;
        bh=rkERNKpOfn6T0eA4c7TR4X0IcpRfjhKzKBjVLUtGSes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PAvfCbaILws8Bt5nD8dHRbnB1DW56ZfyzlVVVaftzKLqYx0ZCAicGFNvppb++C/IH
         xKDXlBWmf4t5SI8oHMioxyd37VR5mbc3Ne04+28DmvVAkoVOr2rHdO7nyJ3ZQDo7+f
         zxEkMisvbUdSDLgruDOyoEsZ5+xiP2+KqnygPs6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Ni <xni@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.18 876/879] md: fix double free of io_acct_set bioset
Date:   Tue,  7 Jun 2022 19:06:34 +0200
Message-Id: <20220607165028.283893773@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
@@ -5598,8 +5598,6 @@ static void md_free(struct kobject *ko)
 
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-	if (mddev->level != 1 && mddev->level != 10)
-		bioset_exit(&mddev->io_acct_set);
 	kfree(mddev);
 }
 
@@ -6286,8 +6284,6 @@ void md_stop(struct mddev *mddev)
 	__md_stop(mddev);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
-	if (mddev->level != 1 && mddev->level != 10)
-		bioset_exit(&mddev->io_acct_set);
 }
 
 EXPORT_SYMBOL_GPL(md_stop);


