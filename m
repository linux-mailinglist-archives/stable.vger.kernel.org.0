Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD76608C0F
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJVK6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiJVK5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:57:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC14C319B88;
        Sat, 22 Oct 2022 03:16:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A3E46CE2CB3;
        Sat, 22 Oct 2022 07:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609DBC433D6;
        Sat, 22 Oct 2022 07:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425548;
        bh=X1wE11PrAAWw40XctTtBRMrMg9csj3krl4R38bk5NqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnufLew+vBVIRbhblDTV5C8t1OhIkXxHDh703gR1UrZDT5Z+YWHuBAkFeE0Q7LmGP
         NiSJGA2FzvpcDA96TcQz1j2pQlJssvEnfpM6LIz2HapvTPOLg67pKfr7HdRHyyl3uE
         P7ITTgN3v7Ll5NnKZ/uGa7NOnEZmFOaOGiqtxmUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 538/717] selftest: tpm2: Add Client.__del__() to close /dev/tpm* handle
Date:   Sat, 22 Oct 2022 09:26:57 +0200
Message-Id: <20221022072522.125914615@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 057a4f49c79d..c7363c6764fc 100644
--- a/tools/testing/selftests/tpm2/tpm2.py
+++ b/tools/testing/selftests/tpm2/tpm2.py
@@ -371,6 +371,10 @@ class Client:
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



