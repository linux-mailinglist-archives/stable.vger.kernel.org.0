Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1834F336A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237254AbiDEJEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242460AbiDEIsq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:48:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E321C47AC9;
        Tue,  5 Apr 2022 01:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75FE7614E5;
        Tue,  5 Apr 2022 08:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DF1C385A0;
        Tue,  5 Apr 2022 08:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147830;
        bh=r4l+owIcrNQ3efGn/1bGA3KGQMB6wEfh4CiEt6UHA3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cg3yWkgPg7np8Odtz6SLHCG0sktf+qMKgAHtGMwQZa77PTt4d0mGkDnaNoZUR+BRW
         Pb+aQA9bDUAcCuqR08D6SHi6PW5z6Olr/TlvAQ/TFvLO7u2/mJkET5cUEorboSDrXb
         1TQL8MMWfw/+ko8OnRudg4tDTMUt5FaoCocjY+F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.16 0137/1017] ACPI: properties: Consistently return -ENOENT if there are no more references
Date:   Tue,  5 Apr 2022 09:17:30 +0200
Message-Id: <20220405070358.269527930@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit babc92da5928f81af951663fc436997352e02d3a upstream.

__acpi_node_get_property_reference() is documented to return -ENOENT if
the caller requests a property reference at an index that does not exist,
not -EINVAL which it actually does.

Fix this by returning -ENOENT consistenly, independently of whether the
property value is a plain reference or a package.

Fixes: c343bc2ce2c6 ("ACPI: properties: Align return codes of __acpi_node_get_property_reference()")
Cc: 4.14+ <stable@vger.kernel.org> # 4.14+
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/property.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -685,7 +685,7 @@ int __acpi_node_get_property_reference(c
 	 */
 	if (obj->type == ACPI_TYPE_LOCAL_REFERENCE) {
 		if (index)
-			return -EINVAL;
+			return -ENOENT;
 
 		ret = acpi_bus_get_device(obj->reference.handle, &device);
 		if (ret)


