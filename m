Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1128265D8B6
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239761AbjADQRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239853AbjADQRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:17:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF9D112E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:17:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05726B8172B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B148C433D2;
        Wed,  4 Jan 2023 16:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849035;
        bh=UhL82pXauZJasMQywOTQX3Nnrz1ddtxG5TtOTFaSnjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qq5QAg5ca+wmx+IVrCckjcA/rMvmTwFQeAeKKae+4p3J42dU5f481zn/M4EIdJf3D
         mEt59N8oDcmVdr2ENPruN/F7CdEUJQDZ7JBk1fCEGpLwJ7cyhuBKa4zCMc//g7iCWe
         +imLRVy8d6vDOiXkeG+VJOB3+n+wShwkH0p1KVAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roberto Sassu <roberto.sassu@huawei.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 6.1 123/207] ima: Fix memory leak in __ima_inode_hash()
Date:   Wed,  4 Jan 2023 17:06:21 +0100
Message-Id: <20230104160515.808243157@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Roberto Sassu <roberto.sassu@huawei.com>

commit 8c1d6a050a0f16e0a9d32eaf53b965c77279c6f8 upstream.

Commit f3cc6b25dcc5 ("ima: always measure and audit files in policy") lets
measurement or audit happen even if the file digest cannot be calculated.

As a result, iint->ima_hash could have been allocated despite
ima_collect_measurement() returning an error.

Since ima_hash belongs to a temporary inode metadata structure, declared
at the beginning of __ima_inode_hash(), just add a kfree() call if
ima_collect_measurement() returns an error different from -ENOMEM (in that
case, ima_hash should not have been allocated).

Cc: stable@vger.kernel.org
Fixes: 280fe8367b0d ("ima: Always return a file measurement in ima_file_hash()")
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_main.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -542,8 +542,13 @@ static int __ima_inode_hash(struct inode
 
 		rc = ima_collect_measurement(&tmp_iint, file, NULL, 0,
 					     ima_hash_algo, NULL);
-		if (rc < 0)
+		if (rc < 0) {
+			/* ima_hash could be allocated in case of failure. */
+			if (rc != -ENOMEM)
+				kfree(tmp_iint.ima_hash);
+
 			return -EOPNOTSUPP;
+		}
 
 		iint = &tmp_iint;
 		mutex_lock(&iint->mutex);


