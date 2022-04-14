Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44607501102
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbiDNOEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346610AbiDNN5p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:57:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC013B0D1F;
        Thu, 14 Apr 2022 06:47:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8204E612E6;
        Thu, 14 Apr 2022 13:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC20C385A5;
        Thu, 14 Apr 2022 13:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944053;
        bh=3GzRujzn6+qIKnSzsNy7VvJRtrBFo1lxvSwl8w7PyVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2G2ZYmKo5vAxaJaNB1YYxcqjTVkORHYwKJ7pLGTv53ELH58iZBJ1LVt5yAFZ1sNzj
         5eq7WW3aXA0zaJPpEQfpyrbWPSjAa+eVpFj3cvNvJnpiDs9QEg1JcQaYK1MOC6wmZQ
         3DYDog3Tqi20IpBUmGV3mEsclnHFmnpemAbyykv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.4 350/475] ACPI: CPPC: Avoid out of bounds access when parsing _CPC data
Date:   Thu, 14 Apr 2022 15:12:15 +0200
Message-Id: <20220414110904.876203781@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 40d8abf364bcab23bc715a9221a3c8623956257b upstream.

If the NumEntries field in the _CPC return package is less than 2, do
not attempt to access the "Revision" element of that package, because
it may not be present then.

Fixes: 337aadff8e45 ("ACPI: Introduce CPU performance controls using CPPC")
BugLink: https://lore.kernel.org/lkml/20220322143534.GC32582@xsang-OptiPlex-9020/
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/cppc_acpi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -738,6 +738,11 @@ int acpi_cppc_processor_probe(struct acp
 	cpc_obj = &out_obj->package.elements[0];
 	if (cpc_obj->type == ACPI_TYPE_INTEGER)	{
 		num_ent = cpc_obj->integer.value;
+		if (num_ent <= 1) {
+			pr_debug("Unexpected _CPC NumEntries value (%d) for CPU:%d\n",
+				 num_ent, pr->id);
+			goto out_free;
+		}
 	} else {
 		pr_debug("Unexpected entry type(%d) for NumEntries\n",
 				cpc_obj->type);


