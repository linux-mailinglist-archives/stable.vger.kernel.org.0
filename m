Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26D802C9C7C
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390513AbgLAJSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:18:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389789AbgLAJLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:11:01 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0378221EB;
        Tue,  1 Dec 2020 09:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813846;
        bh=x6g66gI7/WNIPMacygivsWlS0rJdzWKg1uKFt1aUji8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXKokuh+Yt+1NLjbFLzcmGcFu3l+Zmi4B9ZUB6ifkEDBy3eYp4Nj8KiJjh8jaK/1N
         tJxOqMeFAdXFNzCvSowLI0sN40e1clJxY7D6uZp8n9kY6GfnSf+nz5+DjSnPFMmgbT
         JgI4l7RPlTojAAHkXFsrvUU1HUADtLJX36H7QGEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Latypov <dlatypov@google.com>,
        Brendan Higgins <brendanhiggins@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 049/152] kunit: fix display of failed expectations for strings
Date:   Tue,  1 Dec 2020 09:52:44 +0100
Message-Id: <20201201084718.310724514@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Latypov <dlatypov@google.com>

[ Upstream commit 3084db0e0d5076cd48408274ab0911cd3ccdae88 ]

Currently the following expectation
  KUNIT_EXPECT_STREQ(test, "hi", "bye");
will produce:
  Expected "hi" == "bye", but
      "hi" == 1625079497
      "bye" == 1625079500

After this patch:
  Expected "hi" == "bye", but
      "hi" == hi
      "bye" == bye

KUNIT_INIT_BINARY_STR_ASSERT_STRUCT() was written but just mistakenly
not actually used by KUNIT_EXPECT_STREQ() and friends.

Signed-off-by: Daniel Latypov <dlatypov@google.com>
Reviewed-by: Brendan Higgins <brendanhiggins@google.com>
Tested-by: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/kunit/test.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/kunit/test.h b/include/kunit/test.h
index 59f3144f009a5..b68ba33c16937 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -1064,7 +1064,7 @@ do {									       \
 	KUNIT_ASSERTION(test,						       \
 			strcmp(__left, __right) op 0,			       \
 			kunit_binary_str_assert,			       \
-			KUNIT_INIT_BINARY_ASSERT_STRUCT(test,		       \
+			KUNIT_INIT_BINARY_STR_ASSERT_STRUCT(test,	       \
 							assert_type,	       \
 							#op,		       \
 							#left,		       \
-- 
2.27.0



