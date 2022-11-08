Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16520621591
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbiKHONM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:13:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbiKHONF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:13:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01646186FF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:13:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91F29615BF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AEB1C433D6;
        Tue,  8 Nov 2022 14:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916782;
        bh=kRYR5pRRyNqouJfXY93OGO7T/ovl5yAJGGCNdxlPAOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cYtT8htSC1fW5XN5cqUoyo2eMpjfNBbBLdzORfj4QfRKLBZ9HeYs/WboMYKIiP3Qc
         Uowl6tnHw84I4QzkaJK+hJxIQnkf5YEsS9GsUoKfQkaeWb2rcdMFcqkjKq1bLVqew5
         r02qsvXT0qcHt3vSTDd6P2wvn59R8gn3HyHTTLUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alison Schofield <alison.schofield@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 6.0 132/197] ACPI: NUMA: Add CXL CFMWS nodes to the possible nodes set
Date:   Tue,  8 Nov 2022 14:39:30 +0100
Message-Id: <20221108133400.960173497@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

commit 24f0692bfd41fd207d99c993a5785c3426762046 upstream.

The ACPI CEDT.CFMWS indicates a range of possible address where new CXL
regions can appear. Each range is associated with a QTG id (QoS
Throttling Group id). For each range + QTG pair that is not covered by a proximity
domain in the SRAT, Linux creates a new NUMA node. However, the commit
that added the new ranges missed updating the node_possible mask which
causes memory_group_register() to fail. Add the new nodes to the
nodes_possible mask.

Cc: <stable@vger.kernel.org>
Fixes: fd49f99c1809 ("ACPI: NUMA: Add a node and memblk for each CFMWS not in SRAT")
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Tested-by: Vishal Verma <vishal.l.verma@intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/166631003537.1167078.9373680312035292395.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/numa/srat.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -327,6 +327,7 @@ static int __init acpi_parse_cfmws(union
 		pr_warn("ACPI NUMA: Failed to add memblk for CFMWS node %d [mem %#llx-%#llx]\n",
 			node, start, end);
 	}
+	node_set(node, numa_nodes_parsed);
 
 	/* Set the next available fake_pxm value */
 	(*fake_pxm)++;


