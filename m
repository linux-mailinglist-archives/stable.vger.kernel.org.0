Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E457C529182
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345511AbiEPULJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351073AbiEPUB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE40B3EF09;
        Mon, 16 May 2022 12:58:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 712C8B81615;
        Mon, 16 May 2022 19:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3CEC385AA;
        Mon, 16 May 2022 19:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731089;
        bh=YMYJCd01UUyE8kNd9wRP9+bD6BDn8c+cckoyvOVsVpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R18+IUithdomFQMSOVIcVyBxXME4nQG3+jgCvyxwoZdk/77juIemM8rrB2JUS40Wk
         YDnjWR4ifgDduGOLNgDVVcNHvYImyTV5kpBE4FCXqgsdYLWAfJWACPeqevON6CPgSS
         +yU17R8KIrSuHgRoAZw0hYt4LTq8uTlQqdgqDdno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jordan Leppert <jordanleppert@protonmail.com>,
        Holger Hoffstaette <holger@applied-asynchrony.com>,
        Manuel Ullmann <labre@posteo.de>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.17 099/114] net: atlantic: always deep reset on pm op, fixing up my null deref regression
Date:   Mon, 16 May 2022 21:37:13 +0200
Message-Id: <20220516193628.317989145@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
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
@@ -449,7 +449,7 @@ static int aq_pm_freeze(struct device *d
 
 static int aq_pm_suspend_poweroff(struct device *dev)
 {
-	return aq_suspend_common(dev, false);
+	return aq_suspend_common(dev, true);
 }
 
 static int aq_pm_thaw(struct device *dev)
@@ -459,7 +459,7 @@ static int aq_pm_thaw(struct device *dev
 
 static int aq_pm_resume_restore(struct device *dev)
 {
-	return atl_resume_common(dev, false);
+	return atl_resume_common(dev, true);
 }
 
 static const struct dev_pm_ops aq_pm_ops = {


