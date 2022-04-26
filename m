Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71CE850F5B7
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239311AbiDZIwQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346152AbiDZIoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:44:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9BD161EBE;
        Tue, 26 Apr 2022 01:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AFAB6185C;
        Tue, 26 Apr 2022 08:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E3CC385A4;
        Tue, 26 Apr 2022 08:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962056;
        bh=RGoE0lV4Gt1FzGtH18FsPre8pQCqlrkKwqFydH7HAbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqdDdhjpbyMb8yx7TbBq5mtmqLSbWesjbfM9Ch1NHK3ffn5uSFxf+JsU/2YQD6Rfg
         Cuyp3FXHpbyNTN2fJtFoaW3HJ0VjQ8piojljg+aAWCfX3YVQiP68AeFKUiZjo9t8CH
         HJAdowvaM4CIHOdj9tGOEMcH8jHl3LlqfzgYUp6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, koo5 <kolman.jindrich@gmail.com>,
        Manuel Ullmann <labre@posteo.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 57/86] net: atlantic: invert deep par in pm functions, preventing null derefs
Date:   Tue, 26 Apr 2022 10:21:25 +0200
Message-Id: <20220426081742.851286029@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manuel Ullmann <labre@posteo.de>

commit cbe6c3a8f8f4315b96e46e1a1c70393c06d95a4c upstream.

This will reset deeply on freeze and thaw instead of suspend and
resume and prevent null pointer dereferences of the uninitialized ring
0 buffer while thawing.

The impact is an indefinitely hanging kernel. You can't switch
consoles after this and the only possible user interaction is SysRq.

BUG: kernel NULL pointer dereference
RIP: 0010:aq_ring_rx_fill+0xcf/0x210 [atlantic]
aq_vec_init+0x85/0xe0 [atlantic]
aq_nic_init+0xf7/0x1d0 [atlantic]
atl_resume_common+0x4f/0x100 [atlantic]
pci_pm_thaw+0x42/0xa0

resolves in aq_ring.o to

```
0000000000000ae0 <aq_ring_rx_fill>:
{
/* ... */
 baf:	48 8b 43 08          	mov    0x8(%rbx),%rax
 		buff->flags = 0U; /* buff is NULL */
```

The bug has been present since the introduction of the new pm code in
8aaa112a57c1 ("net: atlantic: refactoring pm logic") and was hidden
until 8ce84271697a ("net: atlantic: changes for multi-TC support"),
which refactored the aq_vec_{free,alloc} functions into
aq_vec_{,ring}_{free,alloc}, but is technically not wrong. The
original functions just always reinitialized the buffers on S3/S4. If
the interface is down before freezing, the bug does not occur. It does
not matter, whether the initrd contains and loads the module before
thawing.

So the fix is to invert the boolean parameter deep in all pm function
calls, which was clearly intended to be set like that.

First report was on Github [1], which you have to guess from the
resume logs in the posted dmesg snippet. Recently I posted one on
Bugzilla [2], since I did not have an AQC device so far.

#regzbot introduced: 8ce84271697a
#regzbot from: koo5 <kolman.jindrich@gmail.com>
#regzbot monitor: https://github.com/Aquantia/AQtion/issues/32

Fixes: 8aaa112a57c1 ("net: atlantic: refactoring pm logic")
Link: https://github.com/Aquantia/AQtion/issues/32 [1]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215798 [2]
Cc: stable@vger.kernel.org
Reported-by: koo5 <kolman.jindrich@gmail.com>
Signed-off-by: Manuel Ullmann <labre@posteo.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -450,22 +450,22 @@ err_exit:
 
 static int aq_pm_freeze(struct device *dev)
 {
-	return aq_suspend_common(dev, false);
+	return aq_suspend_common(dev, true);
 }
 
 static int aq_pm_suspend_poweroff(struct device *dev)
 {
-	return aq_suspend_common(dev, true);
+	return aq_suspend_common(dev, false);
 }
 
 static int aq_pm_thaw(struct device *dev)
 {
-	return atl_resume_common(dev, false);
+	return atl_resume_common(dev, true);
 }
 
 static int aq_pm_resume_restore(struct device *dev)
 {
-	return atl_resume_common(dev, true);
+	return atl_resume_common(dev, false);
 }
 
 static const struct dev_pm_ops aq_pm_ops = {


