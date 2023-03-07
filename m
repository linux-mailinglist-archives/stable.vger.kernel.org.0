Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E096E6AEC7F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCGRzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjCGRzY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:55:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD2CA18B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:50:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 181FE614B2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C509C433EF;
        Tue,  7 Mar 2023 17:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211404;
        bh=FZ0JtNDgYdQBCUu1PhXMpbjFslVVL5vVsghZdVsfp9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGlgkAAM/aDjGpWldRC1hy7YjOAGvFhhaEojtOQ2wFYwFxCJLV3VTYKGSa2zj10hG
         V8zRza68+boElpe7d1ZrOMH4pBDdezNSlMF5UaCfI/6c7XaB6djmqjkYcALtkDpK5P
         h8yAxUHOU6vIuAcdiD1altG2bJ1OBFG+0hbqyGxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matt Bobrowski <mattbobrowski@google.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.2 0851/1001] ima: fix error handling logic when file measurement failed
Date:   Tue,  7 Mar 2023 18:00:23 +0100
Message-Id: <20230307170058.743534389@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Bobrowski <mattbobrowski@google.com>

commit 6dc387d52eb67f45d68caa263704fa4e39ef8e76 upstream.

Restore the error handling logic so that when file measurement fails,
the respective iint entry is not left with the digest data being
populated with zeroes.

Fixes: 54f03916fb89 ("ima: permit fsverity's file digests in the IMA measurement list")
Cc: stable@vger.kernel.org	# 5.19
Signed-off-by: Matt Bobrowski <mattbobrowski@google.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_api.c  |    2 +-
 security/integrity/ima/ima_main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -292,7 +292,7 @@ int ima_collect_measurement(struct integ
 		result = ima_calc_file_hash(file, &hash.hdr);
 	}
 
-	if (result == -ENOMEM)
+	if (result && result != -EBADF && result != -EINVAL)
 		goto out;
 
 	length = sizeof(hash.hdr) + hash.hdr.length;
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -337,7 +337,7 @@ static int process_measurement(struct fi
 	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
 
 	rc = ima_collect_measurement(iint, file, buf, size, hash_algo, modsig);
-	if (rc == -ENOMEM)
+	if (rc != 0 && rc != -EBADF && rc != -EINVAL)
 		goto out_locked;
 
 	if (!pathbuf)	/* ima_rdwr_violation possibly pre-fetched */


