Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30AC06280A7
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237880AbiKNNHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237888AbiKNNHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:07:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8433C2B249
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:07:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 294E5B80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DFAC433C1;
        Mon, 14 Nov 2022 13:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431261;
        bh=1yN5Ybg3au0p8RNxPhJ5QNVj6lZJ53BOwUDi6KaT4WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPvbPllWB+vTPH4QqiqTlDNaubwr1yMt+RoM5xgg+BHuU1sA6EkhpRyEszXTqChfe
         pryh96CaJxq0SxI0m6OBUr37ynMktkmjjg5Q728CXVqU6KvRaCcrja8E/DKqDImL6f
         bHNHAP0IXfBqliXEhhzLYvameCCy4se8OotmB5GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pankaj Gupta <pankaj.gupta@amd.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 160/190] mm/memremap.c: map FS_DAX device memory as decrypted
Date:   Mon, 14 Nov 2022 13:46:24 +0100
Message-Id: <20221114124505.817522330@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Pankaj Gupta <pankaj.gupta@amd.com>

commit 867400af90f1f953ff9e10b1b87ecaf9369a7eb8 upstream.

virtio_pmem use devm_memremap_pages() to map the device memory.  By
default this memory is mapped as encrypted with SEV.  Guest reboot changes
the current encryption key and guest no longer properly decrypts the FSDAX
device meta data.

Mark the corresponding device memory region for FSDAX devices (mapped with
memremap_pages) as decrypted to retain the persistent memory property.

Link: https://lkml.kernel.org/r/20221102160728.3184016-1-pankaj.gupta@amd.com
Fixes: b7b3c01b19159 ("mm/memremap_pages: support multiple ranges per invocation")
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memremap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -330,6 +330,7 @@ void *memremap_pages(struct dev_pagemap
 			WARN(1, "File system DAX not supported\n");
 			return ERR_PTR(-EINVAL);
 		}
+		params.pgprot = pgprot_decrypted(params.pgprot);
 		break;
 	case MEMORY_DEVICE_GENERIC:
 		break;


