Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9196960ACA9
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiJXOLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbiJXOJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:09:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC01C707C;
        Mon, 24 Oct 2022 05:51:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EEC861342;
        Mon, 24 Oct 2022 12:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1F9C433B5;
        Mon, 24 Oct 2022 12:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615915;
        bh=SQBhvpbr67nNnwBS9iLoISYpMqP1aXfZOUUFaVU+bMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yA/NksSg2YRIlIwsu8xBjOkiwiKFBAEj07Iqss7JvNc+OfXwINRKXMqiqe7I+Hn2A
         syGJLzsJMO5oqwon223zQvGKIIvQaQNX2wWgSMrj1vP6GH/4YwyhNly0+IL1IYVxhZ
         i8hvKpRK7pvn/7das8rlnh/bqZR43rXUEeXhZi10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 399/530] selftest: tpm2: Add Client.__del__() to close /dev/tpm* handle
Date:   Mon, 24 Oct 2022 13:32:23 +0200
Message-Id: <20221024113103.139238837@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Berger <stefanb@linux.ibm.com>

[ Upstream commit 2d869f0b458547386fbcd8cf3004b271b7347b7f ]

The following output can bee seen when the test is executed:

  test_flush_context (tpm2_tests.SpaceTest) ... \
    /usr/lib64/python3.6/unittest/case.py:605: ResourceWarning: \
    unclosed file <_io.FileIO name='/dev/tpmrm0' mode='rb+' closefd=True>

An instance of Client does not implicitly close /dev/tpm* handle, once it
gets destroyed. Close the file handle in the class destructor
Client.__del__().

Fixes: 6ea3dfe1e0732 ("selftests: add TPM 2.0 tests")
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/tpm2/tpm2.py | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/tpm2/tpm2.py b/tools/testing/selftests/tpm2/tpm2.py
index f34486cd7342..3e67fdb518ec 100644
--- a/tools/testing/selftests/tpm2/tpm2.py
+++ b/tools/testing/selftests/tpm2/tpm2.py
@@ -370,6 +370,10 @@ class Client:
             fcntl.fcntl(self.tpm, fcntl.F_SETFL, flags)
             self.tpm_poll = select.poll()
 
+    def __del__(self):
+        if self.tpm:
+            self.tpm.close()
+
     def close(self):
         self.tpm.close()
 
-- 
2.35.1



