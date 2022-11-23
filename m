Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4008635913
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236887AbiKWKGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236871AbiKWKGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:06:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70443125226
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:56:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF128B81EE6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03130C433D6;
        Wed, 23 Nov 2022 09:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197385;
        bh=EyGpCvExirL+SolXAuOtWHuYu+BCjYr33Yv0K9tZB5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n58ofwlOdn7J9LAOVG9fEpewaH9flfsthILQPxjmlaGMaCmBBLlSqs8m+V+2qRx9F
         j6ARclbHRXxULxz7IDYSg77QYb5zs3B4v5modWXmadFt37Ez5TLS5wilEW7dSZ4U2F
         jIl1QmTcIMpM6ZEG6PJtq6H33/exClDOulWEofb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.0 280/314] perf/x86/intel/pt: Fix sampling using single range output
Date:   Wed, 23 Nov 2022 09:52:05 +0100
Message-Id: <20221123084638.228224271@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

commit ce0d998be9274dd3a3d971cbeaa6fe28fd2c3062 upstream.

Deal with errata TGL052, ADL037 and RPL017 "Trace May Contain Incorrect
Data When Configured With Single Range Output Larger Than 4KB" by
disabling single range output whenever larger than 4KB.

Fixes: 670638477aed ("perf/x86/intel/pt: Opportunistically use single range output mode")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20221112151508.13768-1-adrian.hunter@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1263,6 +1263,15 @@ static int pt_buffer_try_single(struct p
 	if (1 << order != nr_pages)
 		goto out;
 
+	/*
+	 * Some processors cannot always support single range for more than
+	 * 4KB - refer errata TGL052, ADL037 and RPL017. Future processors might
+	 * also be affected, so for now rather than trying to keep track of
+	 * which ones, just disable it for all.
+	 */
+	if (nr_pages > 1)
+		goto out;
+
 	buf->single = true;
 	buf->nr_pages = nr_pages;
 	ret = 0;


