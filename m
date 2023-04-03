Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A08D6D49FB
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbjDCOnJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbjDCOnI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:43:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD001826B
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:42:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D33A5B81D07
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A014C433D2;
        Mon,  3 Apr 2023 14:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532959;
        bh=QNjg35JqVGRkiXWOhfrxOD6oYTzm8nvTMwy5KmuZDYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LBqRDd6VouCDA7lbQesBWiJunB+521UP0ssYLa4ddEN3Y6lXytiqvmv5GLYW5GWTI
         v5zpDswn/tWxufrs+81mOsbEQIjF1SOZMPDX4nThJCH+pYFlKtYwykNt9lOIjD4cJe
         jnd2QoQ/eiJFTPDIYkXWUgZisczX9MWhaIZL47K0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 6.1 181/181] x86/PVH: avoid 32-bit build warning when obtaining VGA console info
Date:   Mon,  3 Apr 2023 16:10:16 +0200
Message-Id: <20230403140421.025329184@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit aadbd07ff8a75ed342388846da78dfaddb8b106a upstream.

In the commit referenced below I failed to pay attention to this code
also being buildable as 32-bit. Adjust the type of "ret" - there's no
real need for it to be wider than 32 bits.

Fixes: 934ef33ee75c ("x86/PVH: obtain VGA console info in Dom0")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Link: https://lore.kernel.org/r/2d2193ff-670b-0a27-e12d-2c5c4c121c79@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/enlighten_pvh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/xen/enlighten_pvh.c
+++ b/arch/x86/xen/enlighten_pvh.c
@@ -48,7 +48,7 @@ void __init xen_pvh_init(struct boot_par
 		struct xen_platform_op op = {
 			.cmd = XENPF_get_dom0_console,
 		};
-		long ret = HYPERVISOR_platform_op(&op);
+		int ret = HYPERVISOR_platform_op(&op);
 
 		if (ret > 0)
 			xen_init_vga(&op.u.dom0_console,


