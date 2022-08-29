Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD965A494C
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbiH2LXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231642AbiH2LVy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:21:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A701165;
        Mon, 29 Aug 2022 04:14:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9964461214;
        Mon, 29 Aug 2022 11:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2889DC433C1;
        Mon, 29 Aug 2022 11:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771474;
        bh=VN7QLUM9u6R6IOVbvpnY/9cLJJiXJQxgKLVbZmB60TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVaZDNlvo/t1l0Than623tRj/s0R1k8c5/53Qgg6sPT7HNfEtU6ev7TYvpsloSG/A
         4p5Td4iZ1GjbRriz93f30orH47JnFuwv7OZmFipC9CKKQozPVAFqMjkW9xklNkF8cK
         FGMRT11KSCOHsa9vBni5u00boDmVIeWDGTJwQ7ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Badari Pulavarty <badari.pulavarty@intel.com>,
        SeongJae Park <sj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 107/136] mm/damon/dbgfs: avoid duplicate context directory creation
Date:   Mon, 29 Aug 2022 12:59:34 +0200
Message-Id: <20220829105809.108745359@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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

From: Badari Pulavarty <badari.pulavarty@intel.com>

commit d26f60703606ab425eee9882b32a1781a8bed74d upstream.

When user tries to create a DAMON context via the DAMON debugfs interface
with a name of an already existing context, the context directory creation
fails but a new context is created and added in the internal data
structure, due to absence of the directory creation success check.  As a
result, memory could leak and DAMON cannot be turned on.  An example test
case is as below:

    # cd /sys/kernel/debug/damon/
    # echo "off" >  monitor_on
    # echo paddr > target_ids
    # echo "abc" > mk_context
    # echo "abc" > mk_context
    # echo $$ > abc/target_ids
    # echo "on" > monitor_on  <<< fails

Return value of 'debugfs_create_dir()' is expected to be ignored in
general, but this is an exceptional case as DAMON feature is depending
on the debugfs functionality and it has the potential duplicate name
issue.  This commit therefore fixes the issue by checking the directory
creation failure and immediately return the error in the case.

Link: https://lkml.kernel.org/r/20220821180853.2400-1-sj@kernel.org
Fixes: 75c1c2b53c78 ("mm/damon/dbgfs: support multiple contexts")
Signed-off-by: Badari Pulavarty <badari.pulavarty@intel.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[ 5.15.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/dbgfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/dbgfs.c
+++ b/mm/damon/dbgfs.c
@@ -376,6 +376,9 @@ static int dbgfs_mk_context(char *name)
 		return -ENOENT;
 
 	new_dir = debugfs_create_dir(name, root);
+	/* Below check is required for a potential duplicated name case */
+	if (IS_ERR(new_dir))
+		return PTR_ERR(new_dir);
 	dbgfs_dirs[dbgfs_nr_ctxs] = new_dir;
 
 	new_ctx = dbgfs_new_ctx();


