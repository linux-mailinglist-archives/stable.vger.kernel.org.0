Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AA024BE48
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730485AbgHTNXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgHTJdr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:33:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6602B22B49;
        Thu, 20 Aug 2020 09:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916005;
        bh=K9KMQFAcyvXCpKGPLlOIGzdhg4xgO8vb0fMc0YLqKwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCd9f/Sz5efkJPkhyADsA6KX85bQ68hfJOHSW2oKEkeF2dk6IaR/BqbakOnHrAuxf
         OVXUq1t9lYuAZeQWCAgccbszAq3GSoC/CKOtKeKyGjO9uwSOb4ZIUhYbJPDAHG3Y7T
         hx3dmLP4n35kAv7g/AVl2WFbwp+bfBMVi27SzDQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jens Axboe <axboe@kernel.dk>,
        Josh Triplett <josh@joshtriplett.org>,
        Kees Cook <keescook@chromium.org>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Sergey Kvachonok <ravenexp@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        Tony Vroon <chainsaw@gentoo.org>,
        Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 210/232] test_kmod: avoid potential double free in trigger_config_run_type()
Date:   Thu, 20 Aug 2020 11:21:01 +0200
Message-Id: <20200820091622.982699256@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tiezhu Yang <yangtiezhu@loongson.cn>

[ Upstream commit 0776d1231bec0c7ab43baf440a3f5ef5f49dd795 ]

Reset the member "test_fs" of the test configuration after a call of the
function "kfree_const" to a null pointer so that a double memory release
will not be performed.

Fixes: d9c6a72d6fa2 ("kmod: add test driver to stress test the module loader")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Sergey Kvachonok <ravenexp@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tony Vroon <chainsaw@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>
Link: http://lkml.kernel.org/r/20200610154923.27510-4-mcgrof@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_kmod.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_kmod.c b/lib/test_kmod.c
index e651c37d56dbd..eab52770070d6 100644
--- a/lib/test_kmod.c
+++ b/lib/test_kmod.c
@@ -745,7 +745,7 @@ static int trigger_config_run_type(struct kmod_test_device *test_dev,
 		break;
 	case TEST_KMOD_FS_TYPE:
 		kfree_const(config->test_fs);
-		config->test_driver = NULL;
+		config->test_fs = NULL;
 		copied = config_copy_test_fs(config, test_str,
 					     strlen(test_str));
 		break;
-- 
2.25.1



