Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E23F50F8B8
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345949AbiDZJIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347902AbiDZJGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:06:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6795FB3DDB;
        Tue, 26 Apr 2022 01:47:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 286F2B81CB3;
        Tue, 26 Apr 2022 08:46:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8503DC385A0;
        Tue, 26 Apr 2022 08:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962817;
        bh=Q/NB08VUd3vxv4x7BsltP3dVqaSoPQUEhqVzMWg51P8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lz7rwE6EniAI/oXuac1srRstPh7TTJ33L9hdmSpoay9A4LQVBzqMP2BRG4ecY7beX
         a9glX7jMOq0VBCZtt3PO5fjQ1+xRBRq7jnznHQBb9+GJM/8YPSil8lz8jaUd4OFKif
         YDy1CVBSYTnYGXds2e5s05pr3LYlZUpRAQ63XeTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, koo5 <kolman.jindrich@gmail.com>,
        Manuel Ullmann <labre@posteo.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.17 097/146] net: atlantic: invert deep par in pm functions, preventing null derefs
Date:   Tue, 26 Apr 2022 10:21:32 +0200
Message-Id: <20220426081752.783816738@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
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
@@ -444,22 +444,22 @@ err_exit:
 
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


