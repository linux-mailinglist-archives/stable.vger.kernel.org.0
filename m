Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBAFA5291A9
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346764AbiEPTzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347037AbiEPTvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:51:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEF028A;
        Mon, 16 May 2022 12:46:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D414609D0;
        Mon, 16 May 2022 19:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A154C385AA;
        Mon, 16 May 2022 19:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730406;
        bh=pBZPEgcwSWzTvVDiYZyVpK3hnXuf2CTVNp7A4sC+rao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LayEnuD8R2isTzh0OoNoARX4xHZPRg+BuTu5qcNdQ4P8C8vfdaCBYomtOWfsWy02y
         MjgxmcxTScJVT+ucUZXwMlQS9naLlYdKHuNtx+siU3hB8efJ89dQhFbn4izM9rwtkO
         0qA/JYCo604w5vmB06tfd62koznTGvZMSuzGatCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jordan Leppert <jordanleppert@protonmail.com>,
        Holger Hoffstaette <holger@applied-asynchrony.com>,
        Manuel Ullmann <labre@posteo.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 55/66] net: atlantic: always deep reset on pm op, fixing up my null deref regression
Date:   Mon, 16 May 2022 21:36:55 +0200
Message-Id: <20220516193621.001311470@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193619.400083785@linuxfoundation.org>
References: <20220516193619.400083785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manuel Ullmann <labre@posteo.de>

commit 1809c30b6e5a83a1de1435fe01aaa4de4d626a7c upstream.

The impact of this regression is the same for resume that I saw on
thaw: the kernel hangs and nothing except SysRq rebooting can be done.

Fixes regression in commit cbe6c3a8f8f4 ("net: atlantic: invert deep
par in pm functions, preventing null derefs"), where I disabled deep
pm resets in suspend and resume, trying to make sense of the
atl_resume_common() deep parameter in the first place.

It turns out, that atlantic always has to deep reset on pm
operations. Even though I expected that and tested resume, I screwed
up by kexec-rebooting into an unpatched kernel, thus missing the
breakage.

This fixup obsoletes the deep parameter of atl_resume_common, but I
leave the cleanup for the maintainers to post to mainline.

Suspend and hibernation were successfully tested by the reporters.

Fixes: cbe6c3a8f8f4 ("net: atlantic: invert deep par in pm functions, preventing null derefs")
Link: https://lore.kernel.org/regressions/9-Ehc_xXSwdXcvZqKD5aSqsqeNj5Izco4MYEwnx5cySXVEc9-x_WC4C3kAoCqNTi-H38frroUK17iobNVnkLtW36V6VWGSQEOHXhmVMm5iQ=@protonmail.com/
Reported-by: Jordan Leppert <jordanleppert@protonmail.com>
Reported-by: Holger Hoffstaette <holger@applied-asynchrony.com>
Tested-by: Jordan Leppert <jordanleppert@protonmail.com>
Tested-by: Holger Hoffstaette <holger@applied-asynchrony.com>
CC: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Manuel Ullmann <labre@posteo.de>
Link: https://lore.kernel.org/r/87bkw8dfmp.fsf@posteo.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -455,7 +455,7 @@ static int aq_pm_freeze(struct device *d
 
 static int aq_pm_suspend_poweroff(struct device *dev)
 {
-	return aq_suspend_common(dev, false);
+	return aq_suspend_common(dev, true);
 }
 
 static int aq_pm_thaw(struct device *dev)
@@ -465,7 +465,7 @@ static int aq_pm_thaw(struct device *dev
 
 static int aq_pm_resume_restore(struct device *dev)
 {
-	return atl_resume_common(dev, false);
+	return atl_resume_common(dev, true);
 }
 
 static const struct dev_pm_ops aq_pm_ops = {


