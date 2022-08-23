Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C19B959D6D8
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242128AbiHWJma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352388AbiHWJlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:41:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875DC99246;
        Tue, 23 Aug 2022 01:42:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AA1EB81C4A;
        Tue, 23 Aug 2022 08:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FABC433D6;
        Tue, 23 Aug 2022 08:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244090;
        bh=2lB3I7+8Hem0I6Ax5aso+WvIIZirR+UtJ+Zd6sfcEwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPNq5+n/VhdYNY/eIToOWc/rM3zwWJdnr/oySACxPsSjm3kvkEGiOIQNSccx1KMfJ
         6WuAkoQCpaipEdU+qDosPKHtFx2UuAq6r1x3I/Je4g1WD/47dgAoINY1lUFvzmSWhq
         k37I0N2dIOFEqCQk2PH/5nxPup0ov5ERbcnl4Vcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiu Jianfeng <xiujianfeng@huawei.com>,
        John Johansen <john.johansen@canonical.com>
Subject: [PATCH 5.15 035/244] apparmor: Fix memleak in aa_simple_write_to_buffer()
Date:   Tue, 23 Aug 2022 10:23:14 +0200
Message-Id: <20220823080100.240361186@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Xiu Jianfeng <xiujianfeng@huawei.com>

commit 417ea9fe972d2654a268ad66e89c8fcae67017c3 upstream.

When copy_from_user failed, the memory is freed by kvfree. however the
management struct and data blob are allocated independently, so only
kvfree(data) cause a memleak issue here. Use aa_put_loaddata(data) to
fix this issue.

Fixes: a6a52579e52b5 ("apparmor: split load data into management struct and data blob")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/apparmor/apparmorfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -401,7 +401,7 @@ static struct aa_loaddata *aa_simple_wri
 
 	data->size = copy_size;
 	if (copy_from_user(data->data, userbuf, copy_size)) {
-		kvfree(data);
+		aa_put_loaddata(data);
 		return ERR_PTR(-EFAULT);
 	}
 


