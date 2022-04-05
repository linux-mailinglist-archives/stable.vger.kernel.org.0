Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66254F40C8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383101AbiDEMYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356078AbiDEKWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:22:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B76FB0A7B;
        Tue,  5 Apr 2022 03:05:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB19EB81B7A;
        Tue,  5 Apr 2022 10:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27599C385A1;
        Tue,  5 Apr 2022 10:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153154;
        bh=/vSptA5YddKrMRYEVwozcLIsPiINX27TrXq69pfeqmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ED59cCxGMywuTenfBfVaK0a0JxHxw+SW51ixwpakoMiGP7q19D9wrgdZp+edGvJJR
         A4GcBCZvERuKACs6Mj4/cnjZuK3fucq/ncT7TfZztji8aBZa9jY8I+TrOcUd3zhunJ
         pnGqmKsH5/y0Yy+KrUGDgXRI595yr59ApO/KQFOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.10 082/599] powerpc/kvm: Fix kvm_use_magic_page
Date:   Tue,  5 Apr 2022 09:26:16 +0200
Message-Id: <20220405070301.266586275@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
@@ -669,7 +669,7 @@ static void __init kvm_use_magic_page(vo
 	on_each_cpu(kvm_map_magic_page, &features, 1);
 
 	/* Quick self-test to see if the mapping works */
-	if (!fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
+	if (fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
 		kvm_patching_worked = false;
 		return;
 	}


