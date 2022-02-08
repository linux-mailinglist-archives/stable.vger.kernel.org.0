Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105BE4ADEA2
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 17:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383545AbiBHQvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 11:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352392AbiBHQvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 11:51:00 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE25DC061578;
        Tue,  8 Feb 2022 08:50:59 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8F7DC210F9;
        Tue,  8 Feb 2022 16:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644339058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gzFuTD+9STDC0IKWKq1VpmaF63x4/CpD8VdnqroWAnI=;
        b=W7UVBCvL89jTllIADx5bULOQFaYryz8JCdeEAx/oqXomOtJJjejiBROemapnE6mI8EWKUf
        /DTQ988OLJPabhMzUr6uksDHyP5QOvh116U5LZPYmbvMhTfX1xi3QF5ye1qAZ811gy8U5w
        gIL77fq2l199+OWAGG0dPHs/nE4SdJM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644339058;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=gzFuTD+9STDC0IKWKq1VpmaF63x4/CpD8VdnqroWAnI=;
        b=EydRchZ/j6IsUnpMltUJOJiSRvLba4+jGzzgPIL8+i0CCkJ7Cm4Lzhgbrbz+gHimu7OPVK
        LJS1O6QCSEKHuqBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7280413A1A;
        Tue,  8 Feb 2022 16:50:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id G+LVGXKfAmKLUgAAMHmgww
        (envelope-from <dmueller@suse.de>); Tue, 08 Feb 2022 16:50:58 +0000
From:   =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>
To:     linux-raid@vger.kernel.org
Cc:     =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>,
        stable@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH v2] lib/raid6/test: fix multiple definition linking error
Date:   Tue,  8 Feb 2022 17:50:50 +0100
Message-Id: <20220208165050.13893-1-dmueller@suse.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

GCC 10+ defaults to -fno-common, which enforces proper declaration of
external references using "extern". without this change a link would
fail with:

  lib/raid6/test/algos.c:28: multiple definition of `raid6_call';
  lib/raid6/test/test.c:22: first defined here

the pq.h header that is included already includes an extern declaration
so we can just remove the redundant one here.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dirk Müller <dmueller@suse.de>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 lib/raid6/test/test.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/raid6/test/test.c b/lib/raid6/test/test.c
index a3cf071941ab..841a55242aba 100644
--- a/lib/raid6/test/test.c
+++ b/lib/raid6/test/test.c
@@ -19,7 +19,6 @@
 #define NDISKS		16	/* Including P and Q */
 
 const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
-struct raid6_calls raid6_call;
 
 char *dataptrs[NDISKS];
 char data[NDISKS][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
-- 
2.35.1

