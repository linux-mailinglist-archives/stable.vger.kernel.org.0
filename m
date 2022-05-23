Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D90F531CE6
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241082AbiEWR3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242626AbiEWR1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AD68AE53;
        Mon, 23 May 2022 10:23:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C41F660C21;
        Mon, 23 May 2022 17:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8C9C385A9;
        Mon, 23 May 2022 17:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326631;
        bh=uW7pbc6d6A5YERBrHNp98Gy1nbsBfo6zo6NCvtszUc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szZOzxNw1cLwf6c5vZqOIEYSWFAoNcbI5EHph6xje1xelpphnNqKcsd22I+pt+GzQ
         gx78xQ6Ce6+U67lmA4aP5NUixn8JbF8LsNagzdDz7rxuMxj/RfjZhDWYetk+g89Owl
         KXLrgy/25iN7X/Lagz6e/dCx+Q4rcHxXs1kVhhH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wolfram Sang <wsa@kernel.org>,
        Mario Limonciello <Mario.Limonciello@amd.com>
Subject: [PATCH 5.17 003/158] kernel/resource: Introduce request_mem_region_muxed()
Date:   Mon, 23 May 2022 19:02:40 +0200
Message-Id: <20220523165831.122499648@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Terry Bowman <terry.bowman@amd.com>

commit 27c196c7b73cb70bbed3a9df46563bab60e63415 upstream.

Support for requesting muxed memory region is implemented but not
currently callable as a macro. Add the request muxed memory
region macro.

MMIO memory accesses can be synchronized using request_mem_region() which
is already available. This call will return failure if the resource is
busy. The 'muxed' version of this macro will handle a busy resource by
using a wait queue to retry until the resource is available.

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Cc: Mario Limonciello <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ioport.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -262,6 +262,8 @@ resource_union(struct resource *r1, stru
 #define request_muxed_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name), IORESOURCE_MUXED)
 #define __request_mem_region(start,n,name, excl) __request_region(&iomem_resource, (start), (n), (name), excl)
 #define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name), 0)
+#define request_mem_region_muxed(start, n, name) \
+	__request_region(&iomem_resource, (start), (n), (name), IORESOURCE_MUXED)
 #define request_mem_region_exclusive(start,n,name) \
 	__request_region(&iomem_resource, (start), (n), (name), IORESOURCE_EXCLUSIVE)
 #define rename_region(region, newname) do { (region)->name = (newname); } while (0)


