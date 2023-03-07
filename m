Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 483B76AEC5A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjCGRyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbjCGRyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:54:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24112104
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:48:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B592B818F6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0DFC433D2;
        Tue,  7 Mar 2023 17:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211333;
        bh=HQK05q2ZPvtWTMQShlHDrzMR9Gk1Rvs7XWMEt3vqTp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AzR+uiIv23ek+/mU1/LDsH8W15INqf3SqEYp3vn5CE/+pOunfFEQ5VPlqsGQkkAdv
         p9Q6u5u0xWMeRPn+BfiqJEHhNaqQ9jRam4Idg/ULTDuoPjIsvOPi5DpYk8gyoxmgNX
         TAupxI+pvTS72NFzc5+P/+mn0LbNnJN00fab5gxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 6.2 0797/1001] fs: dlm: start midcomms before scand
Date:   Tue,  7 Mar 2023 17:59:29 +0100
Message-Id: <20230307170056.334444311@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit aad633dc0cf90093998b1ae0ba9f19b5f1dab644 upstream.

The scand kthread can send dlm messages out, especially dlm remove
messages to free memory for unused rsb on other nodes. To send out dlm
messages, midcomms must be initialized. This patch moves the midcomms
start before scand is started.

Cc: stable@vger.kernel.org
Fixes: e7fd41792fc0 ("[DLM] The core of the DLM for GFS2/CLVM")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lockspace.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -381,23 +381,23 @@ static int threads_start(void)
 {
 	int error;
 
-	error = dlm_scand_start();
+	/* Thread for sending/receiving messages for all lockspace's */
+	error = dlm_midcomms_start();
 	if (error) {
-		log_print("cannot start dlm_scand thread %d", error);
+		log_print("cannot start dlm midcomms %d", error);
 		goto fail;
 	}
 
-	/* Thread for sending/receiving messages for all lockspace's */
-	error = dlm_midcomms_start();
+	error = dlm_scand_start();
 	if (error) {
-		log_print("cannot start dlm midcomms %d", error);
-		goto scand_fail;
+		log_print("cannot start dlm_scand thread %d", error);
+		goto midcomms_fail;
 	}
 
 	return 0;
 
- scand_fail:
-	dlm_scand_stop();
+ midcomms_fail:
+	dlm_midcomms_stop();
  fail:
 	return error;
 }


