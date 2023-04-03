Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7446D483E
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbjDCO0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233257AbjDCO0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:26:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D672CAF9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:26:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D85B6B81C15
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:26:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A8FC433EF;
        Mon,  3 Apr 2023 14:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532008;
        bh=auzT78B8sTYFbmdAMJSvXW38zALVULSPkuQHYRo5wJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkHwP3P/21EliQgXunXGtnx190HlDoL6/xHZDXy9Du/NgHtOG5MRYpy7yxOiniIZB
         hVn8IWNv9OiG3h2J9uYyRcT3CH4iEbnCjwVzOe+CZDWlPRmoBTWmbavpahzJztAg/x
         6cLQ1RU25HDe/ymayc6uSIB2/CvvyXDlaKBjxzjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>
Subject: [PATCH 5.10 092/173] tee: amdtee: fix race condition in amdtee_open_session
Date:   Mon,  3 Apr 2023 16:08:27 +0200
Message-Id: <20230403140417.410529300@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rijo Thomas <Rijo-john.Thomas@amd.com>

commit f8502fba45bd30e1a6a354d9d898bc99d1a11e6d upstream.

There is a potential race condition in amdtee_open_session that may
lead to use-after-free. For instance, in amdtee_open_session() after
sess->sess_mask is set, and before setting:

    sess->session_info[i] = session_info;

if amdtee_close_session() closes this same session, then 'sess' data
structure will be released, causing kernel panic when 'sess' is
accessed within amdtee_open_session().

The solution is to set the bit sess->sess_mask as the last step in
amdtee_open_session().

Fixes: 757cc3e9ff1d ("tee: add AMD-TEE driver")
Cc: stable@vger.kernel.org
Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
Acked-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tee/amdtee/core.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -267,35 +267,34 @@ int amdtee_open_session(struct tee_conte
 		goto out;
 	}
 
+	/* Open session with loaded TA */
+	handle_open_session(arg, &session_info, param);
+	if (arg->ret != TEEC_SUCCESS) {
+		pr_err("open_session failed %d\n", arg->ret);
+		handle_unload_ta(ta_handle);
+		kref_put(&sess->refcount, destroy_session);
+		goto out;
+	}
+
 	/* Find an empty session index for the given TA */
 	spin_lock(&sess->lock);
 	i = find_first_zero_bit(sess->sess_mask, TEE_NUM_SESSIONS);
-	if (i < TEE_NUM_SESSIONS)
+	if (i < TEE_NUM_SESSIONS) {
+		sess->session_info[i] = session_info;
+		set_session_id(ta_handle, i, &arg->session);
 		set_bit(i, sess->sess_mask);
+	}
 	spin_unlock(&sess->lock);
 
 	if (i >= TEE_NUM_SESSIONS) {
 		pr_err("reached maximum session count %d\n", TEE_NUM_SESSIONS);
+		handle_close_session(ta_handle, session_info);
 		handle_unload_ta(ta_handle);
 		kref_put(&sess->refcount, destroy_session);
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	/* Open session with loaded TA */
-	handle_open_session(arg, &session_info, param);
-	if (arg->ret != TEEC_SUCCESS) {
-		pr_err("open_session failed %d\n", arg->ret);
-		spin_lock(&sess->lock);
-		clear_bit(i, sess->sess_mask);
-		spin_unlock(&sess->lock);
-		handle_unload_ta(ta_handle);
-		kref_put(&sess->refcount, destroy_session);
-		goto out;
-	}
-
-	sess->session_info[i] = session_info;
-	set_session_id(ta_handle, i, &arg->session);
 out:
 	free_pages((u64)ta, get_order(ta_size));
 	return rc;


