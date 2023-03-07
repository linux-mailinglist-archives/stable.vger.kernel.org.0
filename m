Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607056AF1DA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:48:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbjCGSr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbjCGSr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:47:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B213A9B2F8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:36:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3089661514
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37306C433EF;
        Tue,  7 Mar 2023 18:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214168;
        bh=lq1G/BUXca+EVp2xghk6QquWsZc28y79mR+IG24iFZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldvOlHeISK86jhAl89unt4V8py0N4XgRgyWHvWWbS9IvJNWoyen3aYPUfmq47iKVe
         HcJxdmR+fAPj5F4wZGJhhz2yG6vPBJpu2c7n6Q4WFZ2HgvB5eaZ3rREeZNObUYwVB4
         6gGGQbhq0f5Z5q1NBaGSMXcmPv2z1jvHj8f0GXio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matt Bobrowski <mattbobrowski@google.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.1 745/885] ima: fix error handling logic when file measurement failed
Date:   Tue,  7 Mar 2023 18:01:19 +0100
Message-Id: <20230307170034.289346309@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
@@ -335,7 +335,7 @@ static int process_measurement(struct fi
 	hash_algo = ima_get_hash_algo(xattr_value, xattr_len);
 
 	rc = ima_collect_measurement(iint, file, buf, size, hash_algo, modsig);
-	if (rc == -ENOMEM)
+	if (rc != 0 && rc != -EBADF && rc != -EINVAL)
 		goto out_locked;
 
 	if (!pathbuf)	/* ima_rdwr_violation possibly pre-fetched */


