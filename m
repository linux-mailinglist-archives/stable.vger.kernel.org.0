Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F300500EB2
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243731AbiDNNUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238332AbiDNNTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:19:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF9F92D30;
        Thu, 14 Apr 2022 06:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1492F61378;
        Thu, 14 Apr 2022 13:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D910C385A5;
        Thu, 14 Apr 2022 13:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942191;
        bh=COGJg5rp39d1i+qlK8mdhBqg3wwbEIWZrZ6Av4vGLxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k28Ug11TLx0pmz0M+9c6oTF72e9x/htDkCAMZtG7c1v6H+atf9I5qNwrVZPt8c/tm
         IVb0K9Ig+6Qe54JjaIBGGnsntccFDHG0wWbeKHn/ciZj+G8j5Fg5wCSdUa/EEM4JYa
         t2vCL0Tz7l3AQCycIQVjLkjZQVmxpUja37UGqz2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 4.19 047/338] powerpc/kvm: Fix kvm_use_magic_page
Date:   Thu, 14 Apr 2022 15:09:10 +0200
Message-Id: <20220414110840.235877016@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 0c8eb2884a42d992c7726539328b7d3568f22143 upstream.

When switching from __get_user to fault_in_pages_readable, commit
9f9eae5ce717 broke kvm_use_magic_page: like __get_user,
fault_in_pages_readable returns 0 on success.

Fixes: 9f9eae5ce717 ("powerpc/kvm: Prefer fault_in_pages_readable function")
Cc: stable@vger.kernel.org # v4.18+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/kvm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/kvm.c
+++ b/arch/powerpc/kernel/kvm.c
@@ -680,7 +680,7 @@ static void kvm_use_magic_page(void)
 	on_each_cpu(kvm_map_magic_page, &features, 1);
 
 	/* Quick self-test to see if the mapping works */
-	if (!fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
+	if (fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
 		kvm_patching_worked = false;
 		return;
 	}


