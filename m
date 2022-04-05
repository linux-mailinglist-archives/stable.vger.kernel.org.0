Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7383A4F2C86
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237831AbiDEInX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241108AbiDEIct (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA0915722;
        Tue,  5 Apr 2022 01:27:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A25FFB81BC6;
        Tue,  5 Apr 2022 08:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECABDC385A1;
        Tue,  5 Apr 2022 08:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147253;
        bh=YWqVuCc1v5/03qZzY5VpaQBpsKnDFwN/qHAwd//EEZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8agCFy2oIiS7fdAmUCUygbGiYdu6jpjeqZKE7FX46Ch5XqfgxbujwYi5MT5qv+C0
         a0vpTj6AHz70jhy9XcHL0zZp+xZ3KtiTh6vLU/SPpIN2lJjig8FC5mPIze2KVy+IJU
         wLrvbgKYVlDN2YiQ2k8zjFjauQE6IUw8shS81aI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH 5.17 1058/1126] ACPI: CPPC: Avoid out of bounds access when parsing _CPC data
Date:   Tue,  5 Apr 2022 09:30:05 +0200
Message-Id: <20220405070438.519234305@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -676,6 +676,11 @@ int acpi_cppc_processor_probe(struct acp
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


